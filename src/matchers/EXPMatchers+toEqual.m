#import "EXPMatchers+toEqual.h"
#import "EXPMatcherHelpers.h"

EXPMatcherImplementationBegin(_toEqual, (id expected)) {
  match(^BOOL{
      if ([actual isKindOfClass:[NSValue class]] && [expected isKindOfClass:[NSValue class]]) {
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
        if (EXPIsValueRect(actual) && EXPIsValueRect(expected)) {
            return CGRectEqualToRect([actual rectValue], [expected rectValue]);
        } else if (EXPIsValueSize(actual) && EXPIsValueSize(expected)) {
            return CGSizeEqualToSize([actual sizeValue], [expected sizeValue]);
        } else if (EXPIsValuePoint(actual) && EXPIsValuePoint(expected)) {
            return CGPointEqualToPoint([actual pointValue], [expected pointValue]);
        }
#else
        if (EXPIsValueRect(actual) && EXPIsValueRect(expected)) {
            return CGRectEqualToRect([actual CGRectValue], [expected CGRectValue]);
        } else if (EXPIsValueSize(actual) && EXPIsValueSize(expected)) {
            return CGSizeEqualToSize([actual CGSizeValue], [expected CGSizeValue]);
        } else if (EXPIsValuePoint(actual) && EXPIsValuePoint(expected)) {
            return CGPointEqualToPoint([actual CGPointValue], [expected CGPointValue]);
        }
#endif
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
