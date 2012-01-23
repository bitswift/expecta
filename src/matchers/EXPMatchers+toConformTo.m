#import "EXPMatchers+toConformTo.h"
#import <objc/runtime.h>

EXPMatcherImplementationBegin(toConformTo, (Protocol *expected)) {
  BOOL actualIsNil = (actual == nil);
  BOOL expectedIsNil = (expected == nil);

  prerequisite(^BOOL{
    return !(actualIsNil || expectedIsNil);
  });

  match(^BOOL{
    return [actual conformsToProtocol:expected];
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNil) return @"the expected value is nil/null";

    const char *name = protocol_getName(expected);
    return [NSString stringWithFormat:@"expected: an object conforming to <%s>, got: an instance of %@, which does not conform to <%s>", name, [actual class], name];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(expectedIsNil) return @"the expected value is nil/null";

    const char *name = protocol_getName(expected);
    return [NSString stringWithFormat:@"expected: an object not conforming to <%s>, got: an instance of %@, which does conform to <%s>", name, [actual class], name];
  });
}

EXPMatcherImplementationEnd
