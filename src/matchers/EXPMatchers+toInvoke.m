#import "EXPMatchers+toInvoke.h"

EXPMatcherImplementationBegin(toInvoke, (id target, SEL action)) {
  BOOL actualIsNil = (actual == nil);
  BOOL targetIsNil = (target == nil);
  BOOL actionIsNil = (action == NULL);

  prerequisite(^BOOL{
    return !(actualIsNil || targetIsNil || actionIsNil);
  });

  match(^BOOL{
    return NO;
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action to be invoked is nil/null";
    return [NSString stringWithFormat:@"expected: %@ to be invoked on %@", NSStringFromSelector(action), EXPDescribeObject(target)];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(targetIsNil) return @"the target is nil/null";
    if(actionIsNil) return @"the action which should not be invoked is nil/null";
    return [NSString stringWithFormat:@"expected: %@ not to be invoked on %@", NSStringFromSelector(action), EXPDescribeObject(target)];
  });
}
EXPMatcherImplementationEnd
