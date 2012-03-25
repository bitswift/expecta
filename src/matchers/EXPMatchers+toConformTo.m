#import "EXPMatchers+toConformTo.h"
#import <objc/runtime.h>

EXPMatcherImplementationBegin(toConformTo, (Protocol *expected)) {
  BOOL actualIsNil = (actual == nil);
  BOOL expectedIsNil = (expected == nil);

  __block SEL missingMethod = NULL;
  __block BOOL missingMethodIsInstanceMethod = NO;

  prerequisite(^BOOL{
    return !(actualIsNil || expectedIsNil);
  });

  match(^BOOL{
    missingMethod = NULL;

    if (![actual conformsToProtocol:expected])
      return NO;

    // make sure the object responds to all the required instance methods
    unsigned instanceMethodCount = 0;
    struct objc_method_description *instanceMethodDescriptions = protocol_copyMethodDescriptionList(expected, YES, YES, &instanceMethodCount);
    
    for (unsigned i = 0; i < instanceMethodCount; ++i) {
      SEL name = instanceMethodDescriptions[i].name;
      if (![actual respondsToSelector:name]) {
        missingMethod = name;
        missingMethodIsInstanceMethod = YES;
        return NO;
      }
    }

    free(instanceMethodDescriptions);

    // make sure the class responds to all the required class methods
    unsigned classMethodCount = 0;
    struct objc_method_description *classMethodDescriptions = protocol_copyMethodDescriptionList(expected, YES, NO, &classMethodCount);
    
    for (unsigned i = 0; i < classMethodCount; ++i) {
      SEL name = classMethodDescriptions[i].name;
      if (![actual respondsToSelector:name])
        missingMethod = name;
        missingMethodIsInstanceMethod = NO;
        return NO;
    }

    free(classMethodDescriptions);
    return YES;
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNil) return @"the expected value is nil/null";

    const char *name = protocol_getName(expected);

    if (missingMethod) {
      NSString *missingMethodName = NSStringFromSelector(missingMethod);

      if (missingMethodIsInstanceMethod)
        missingMethodName = [@"-" stringByAppendingString:missingMethodName];
      else
        missingMethodName = [@"+" stringByAppendingString:missingMethodName];

      return [NSString stringWithFormat:@"expected: an object conforming to <%s>, got: an instance of %@, which does not respond to %@", name, [actual class], missingMethodName];
    } else {
      return [NSString stringWithFormat:@"expected: an object conforming to <%s>, got: an instance of %@, which does not conform to <%s>", name, [actual class], name];
    }
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNil) return @"the expected value is nil/null";

    const char *name = protocol_getName(expected);
    return [NSString stringWithFormat:@"expected: an object not conforming to <%s>, got: an instance of %@, which does conform to <%s>", name, [actual class], name];
  });
}

EXPMatcherImplementationEnd
