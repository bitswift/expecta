#import "EXPMatchers+toRespondTo.h"

EXPMatcherImplementationBegin(toRespondTo, (SEL expected)) {
  BOOL actualIsNil = (actual == nil);
  BOOL expectedIsNull = (expected == NULL);

  prerequisite(^BOOL{
    return !(actualIsNil || expectedIsNull);
  });

  match(^BOOL{
    return [actual respondsToSelector:expected];
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNull) return @"the expected value is nil/null";

    NSString *name = NSStringFromSelector(expected);
    return [NSString stringWithFormat:@"expected: an object responding to -%@, got: an instance of %@, which does not respond to -%@", name, [actual class], name];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNull) return @"the expected value is nil/null";

    NSString *name = NSStringFromSelector(expected);
    return [NSString stringWithFormat:@"expected: an object not responding to -%@, got: an instance of %@, which does respond to -%@", name, [actual class], name];
  });
}

EXPMatcherImplementationEnd
