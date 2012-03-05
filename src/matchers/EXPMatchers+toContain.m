#import "EXPMatchers+toContain.h"

EXPMatcherImplementationBegin(_toContain, (id expected)) {
  BOOL actualIsCompatible = ![actual isKindOfClass:[NSDictionary class]] && ([actual isKindOfClass:[NSString class]] || [actual respondsToSelector:@selector(containsObject:)]);
  BOOL expectedIsNil = (expected == nil);

  prerequisite(^BOOL{
    return actualIsCompatible && !expectedIsNil;
  });

  match(^BOOL{
    if(actualIsCompatible) {
      if([actual isKindOfClass:[NSString class]]) {
        return [(NSString *)actual rangeOfString:[expected description]].location != NSNotFound;
      } else {
        return [actual containsObject:expected];
      }
    }
    return NO;
  });

  failureMessageForTo(^NSString *{
    if(!actualIsCompatible) return [NSString stringWithFormat:@"%@ is not an NSString or a collection implementing -containsObject:", EXPDescribeObject(actual)];
    if(expectedIsNil) return @"the expected value is nil/null";
    return [NSString stringWithFormat:@"expected %@ to contain %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
  });

  failureMessageForNotTo(^NSString *{
    if(!actualIsCompatible) return [NSString stringWithFormat:@"%@ is not an NSString or a collection implementing -containsObject:", EXPDescribeObject(actual)];
    if(expectedIsNil) return @"the expected value is nil/null";
    return [NSString stringWithFormat:@"expected %@ not to contain %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
  });
}
EXPMatcherImplementationEnd
