#import "TestHelper.h"

@interface EXPMatchers_toSupportArchivingTest : SenTestCase {
  Foo *foo;
  EncodableObject *encodableObject;
}

@end

@implementation EXPMatchers_toSupportArchivingTest

- (void)setUp {
  foo = [[Foo new] autorelease];
  encodableObject = [[[EncodableObject alloc] initWithString:@"EncodableString" array:[NSArray arrayWithObject:@"Hello"]] autorelease];
}

- (void)test_toSupportArchiving {
  assertPass(test_expect(encodableObject).toSupportArchiving());
}

- (void)test_Not_toSupportArchiving {
  assertPass(test_expect(foo).Not.toSupportArchiving());
}

@end
