#import "EXPMatchers+toInvoke.h"
#import <objc/runtime.h>

EXPMatcherImplementationBegin(toInvoke, (id target, SEL action)) {
  BOOL actualIsNil = (actual == nil);
  BOOL targetIsNil = (target == nil);
  BOOL actionIsNil = (action == NULL);

  Class realClass = Nil;
  if (target)
    realClass = object_getClass(target);

  Method method = NULL;
  if (realClass && action)
    method = class_getInstanceMethod(realClass, action);

  prerequisite(^BOOL{
    if (actualIsNil || targetIsNil || actionIsNil)
      return NO;

    if (!method)
      return NO;
    
    return YES;
  });

  match(^BOOL{
    // dynamically create a subclass of the target's class, which it will be set
    // to, so we can intercept the one message we care about
    const char *proxyClassName = [[NSStringFromClass(realClass) stringByAppendingString:@"_EXPToInvokeProxy"] UTF8String];
    Class proxyClass = objc_getClass(proxyClassName);

    if (!proxyClass) {
      proxyClass = objc_allocateClassPair(realClass, proxyClassName, 0);
      objc_registerClassPair(proxyClass);
    }

    // look up an implementation for a method that doesn't exist, thus
    // grabbing a function pointer internal to the runtime, which will forward
    // messages to -forwardInvocation:
    NSString *fakeSelector = [@"_thisReallyTrulyShouldNotExist_" stringByAppendingString:NSStringFromSelector(action)];
    IMP forward = class_getMethodImplementation(proxyClass, NSSelectorFromString(fakeSelector));

    class_replaceMethod(proxyClass, action, forward, method_getTypeEncoding(method));

    __block BOOL invoked = NO;

    // add a custom implementation of -forwardInvocation: which will check for
    // our selector
    id forwardInvocationBlock = ^(id myself, NSInvocation *invocation) {
      if (action == invocation.selector) {
        // We have our answer
        invoked = YES;

        // swizzle back to the original class
        object_setClass(myself, realClass);
      }

      // re-invoke
      [invocation invokeWithTarget:myself];
    };

    const char *forwardInvocationTypeEncoding = method_getTypeEncoding(class_getInstanceMethod(proxyClass, @selector(forwardInvocation:)));
    IMP forwardInvocationIMP = imp_implementationWithBlock((__bridge void *)forwardInvocationBlock);

    class_replaceMethod(proxyClass, @selector(forwardInvocation:), forwardInvocationIMP, forwardInvocationTypeEncoding);

    // add a custom implementation of -methodSignatureForSelector: to support
    // the method forwarding
    id methodSignatureBlock = ^ id (id myself, SEL selector) {
      return [realClass instanceMethodSignatureForSelector:selector];
    };

    const char *methodSignatureTypeEncoding = method_getTypeEncoding(class_getInstanceMethod(proxyClass, @selector(methodSignatureForSelector:)));
    IMP methodSignatureIMP = imp_implementationWithBlock((__bridge void *)methodSignatureBlock);

    class_replaceMethod(proxyClass, @selector(methodSignatureForSelector:), methodSignatureIMP, methodSignatureTypeEncoding);

    // add an -isEqual: method to compare equal to the original class
    id isEqualBlock = ^ BOOL (Class myself, Class otherClass) {
      return [realClass isEqual:otherClass];
    };

    const char *isEqualTypeEncoding = method_getTypeEncoding(class_getClassMethod(proxyClass, @selector(isEqual:)));
    IMP isEqualIMP = imp_implementationWithBlock((__bridge void *)isEqualBlock);

    class_replaceMethod(object_getClass(proxyClass), @selector(isEqual:), isEqualIMP, isEqualTypeEncoding);

    @try {
      // Swizzle the class of the target and run the actual block
      object_setClass(target, proxyClass);
      void (^actualBlock)(void) = actual;

      actualBlock();
    } @finally {
      object_setClass(target, realClass);

      // restore the original method on the proxy, in case it gets reused for
      // future tests
      class_replaceMethod(proxyClass, action, method_getImplementation(method), method_getTypeEncoding(method));
    }

    return invoked;
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action to be invoked is nil/null";
    if(!method) return @"the target does not implement the action";

    return [NSString stringWithFormat:@"expected: %@ to be invoked on %@", NSStringFromSelector(action), target];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action which should not be invoked is nil/null";
    if(!method) return @"the target does not implement the action";

    return [NSString stringWithFormat:@"expected: %@ not to be invoked on %@", NSStringFromSelector(action), target];
  });
}
EXPMatcherImplementationEnd
