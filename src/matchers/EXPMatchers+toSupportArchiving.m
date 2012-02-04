#import "EXPMatchers+toSupportArchiving.h"

EXPMatcherImplementationBegin(toSupportArchiving, (void)) {
  BOOL actualIsNil = (actual == nil);

  prerequisite(^BOOL{
    return !(actualIsNil);
  });

  match(^BOOL{
    if (![actual conformsToProtocol:@protocol(NSCoding)])
      return NO;

    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:actual];
    if (!archivedData)
      return NO;

    id expected = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    if (!expected)
      return NO;

    return [actual isEqual:expected];
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    return [NSString stringWithFormat:@"expected: an object implementing <NSCoding>, got: an instance of %@, which does not support archiving", [actual class]];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    return [NSString stringWithFormat:@"expected: an object not implementing <NSCoding>, got: an instance of %@, which does support archiving", [actual class]];
  });
}

EXPMatcherImplementationEnd
