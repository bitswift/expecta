#import "TestHelper.h"

@interface EXPMatchers_toSupportCopyingTest : SenTestCase {
  Foo *foo;
  Bar *bar;
}

@end

@implementation EXPMatchers_toSupportCopyingTest

- (void)setUp {
  foo = [[Foo new] autorelease];
  bar = [[Bar new] autorelease];
}

- (void)test_toSupportArchiving {
  assertFail(test_expect(foo).toSupportCopying(), @"expected: an object implementing <NSCopying>, got: an instance of Foo, which does not support copying");
  assertPass(test_expect(bar).toSupportCopying());
}

- (void)test_Not_toSupportArchiving {
  assertPass(test_expect(foo).Not.toSupportCopying());
  assertFail(test_expect(bar).Not.toSupportCopying(), @"expected: an object not implementing <NSCopying>, got: an instance of Bar, which does support copying");
}

@end
