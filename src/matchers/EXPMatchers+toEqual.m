#import "EXPMatchers+toEqual.h"
#import "EXPMatcherHelpers.h"

EXPMatcherImplementationBegin(_toEqual, (id expected)) {
  match(^BOOL{
      if ([actual isKindOfClass:[NSValue class]] && [expected isKindOfClass:[NSValue class]]) {
        if (EXPIsValueRect(actual) && EXPIsValueRect(expected)) {

#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
            return CGRectEqualToRect((CGRect)[actual rectValue], (CGRect)[expected rectValue]);
#else
            return CGRectEqualToRect([actual CGRectValue], [expected CGRectValue]);
#endif
        }
    }

    if((actual == expected) || [actual isEqual:expected]) {
      return YES;
    } else if([actual isKindOfClass:[NSNumber class]] && [expected isKindOfClass:[NSNumber class]]) {
      if(EXPIsNumberFloat((NSNumber *)actual) || EXPIsNumberFloat((NSNumber *)expected)) {
        return [(NSNumber *)actual floatValue] == [(NSNumber *)expected floatValue];
      }
    }
    return NO;
  });

  failureMessageForTo(^NSString *{
    return [NSString stringWithFormat:@"expected: %@, got: %@", EXPDescribeObject(expected), EXPDescribeObject(actual)];
  });

  failureMessageForNotTo(^NSString *{
    return [NSString stringWithFormat:@"expected: not %@, got: %@", EXPDescribeObject(expected), EXPDescribeObject(actual)];
  });
}
EXPMatcherImplementationEnd
