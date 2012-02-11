#import "EXPMatchers+toInvoke.h"
#import <objc/runtime.h>

/**
 * We can't put ivars in here, because we're going to swizzle some classes.
 *
 * In fact, this is an empty class, waiting to be filled with a block for its
 * forwardInvocation: selector.
 */
@interface EXPMatcherToInvokeProxy : NSProxy
@end


EXPMatcherImplementationBegin(toInvoke, (id target, SEL action)) {
  BOOL actualIsNil = (actual == nil);
  BOOL targetIsNil = (target == nil);
  BOOL actionIsNil = (action == NULL);

  prerequisite(^BOOL{
    return !(actualIsNil || targetIsNil || actionIsNil);
  });

  match(^BOOL{

    Class realClass = object_getClass(target);
    __block BOOL invoked = NO;

    id forwardInvocationBlock = ^(id myself, NSInvocation *invocation) {
      @try {
        // Re-swizzle class
        object_setClass(myself, realClass);

        // Call original implementation
        [invocation invokeWithTarget:myself];

        if (action == invocation.selector) {
          // We have our answer
          invoked = YES;
        }
      } @catch (NSException *ex) {
      } @finally {
        object_setClass(myself, [EXPMatcherToInvokeProxy class]);
      }
    };

    id methodSignatureBlock = ^(id myself, SEL selector) {
      return [realClass instanceMethodSignatureForSelector:selector];
    };

    // Set forwardSelectorBlock as the forwardSelector: implementation on EXPMatcherToInvokeProxy
    const char *forwardInvocationTypeEncoding = method_getTypeEncoding(class_getInstanceMethod([EXPMatcherToInvokeProxy class], @selector(forwardInvocation:)));
    IMP forwardInvocationIMP = imp_implementationWithBlock((__bridge void *)forwardInvocationBlock);

    class_replaceMethod([EXPMatcherToInvokeProxy class], @selector(forwardInvocation:), forwardInvocationIMP, forwardInvocationTypeEncoding);

    // Set methodSignatureBlock as the methodSignatureForSelector: implementation
    const char *methodSignatureTypeEncoding = method_getTypeEncoding(class_getInstanceMethod([EXPMatcherToInvokeProxy class], @selector(methodSignatureForSelector:)));
    IMP methodSignatureIMP = imp_implementationWithBlock((__bridge void *)methodSignatureBlock);

    class_replaceMethod([EXPMatcherToInvokeProxy class], @selector(methodSignatureForSelector:), methodSignatureIMP, methodSignatureTypeEncoding);

    // Swizzle the class of the target and run the actual block
    object_setClass(target, [EXPMatcherToInvokeProxy class]);
    void (^actualBlock)(void) = actual;
    actualBlock();

    object_setClass(target, realClass);
    return invoked;
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action to be invoked is nil/null";
    return [NSString stringWithFormat:@"expected: %@ to be invoked on %@", NSStringFromSelector(action), target];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action which should not be invoked is nil/null";
    return [NSString stringWithFormat:@"expected: %@ not to be invoked on %@", NSStringFromSelector(action), target];
  });
}
EXPMatcherImplementationEnd


@implementation EXPMatcherToInvokeProxy

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSLog(@"%s should never be invoked before being swizzled", __func__);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSLog(@"%s should never be invoked before being swizzled", __func__);
    return nil;
}

@end
