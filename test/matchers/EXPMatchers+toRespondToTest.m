#import "TestHelper.h"

@interface EXPMatchers_toRespondToTest : SenTestCase {
  Foo *foo;
  Bar *bar;
  Baz *baz;
  id qux;
}

@end

@implementation EXPMatchers_toRespondToTest

- (void)setUp {
  foo = [[Foo new] autorelease];
  bar = [[Bar new] autorelease];
  baz = [[Baz new] autorelease];
  qux = [[NSObject alloc] init];
}

- (void)test_toRespondTo {
  assertPass(test_expect(foo).toRespondTo(@selector(description)));
  assertPass(test_expect(bar).toRespondTo(@selector(description)));
  assertPass(test_expect(bar).toRespondTo(@selector(barMethod)));
  assertFail(test_expect(nil).toRespondTo(@selector(description)), @"the actual value is nil/null");
  assertFail(test_expect(foo).toRespondTo(NULL), @"the expected value is nil/null");
  assertFail(test_expect(foo).toRespondTo(@selector(length)), @"expected: an object responding to -length, got: an instance of Foo, which does not respond to -length");
  assertFail(test_expect(baz).toRespondTo(@selector(barMethod)), @"expected: an object responding to -barMethod, got: an instance of Baz, which does not respond to -barMethod");
  assertPass(test_expect(qux).toRespondTo(@selector(self)));
}

- (void)test_Not_toRespondTo {
  assertPass(test_expect(foo).Not.toRespondTo(@selector(barMethod)));
  assertPass(test_expect(bar).Not.toRespondTo(@selector(length)));
  assertPass(test_expect(baz).Not.toRespondTo(@selector(barMethod)));
  assertFail(test_expect(nil).Not.toRespondTo(@selector(description)), @"the actual value is nil/null");
  assertFail(test_expect(foo).Not.toRespondTo(NULL), @"the expected value is nil/null");
  assertFail(test_expect(foo).Not.toRespondTo(@selector(init)), @"expected: an object not responding to -init, got: an instance of Foo, which does respond to -init");
  assertFail(test_expect(bar).Not.toRespondTo(@selector(barMethod)), @"expected: an object not responding to -barMethod, got: an instance of Bar, which does respond to -barMethod");
  assertPass(test_expect(qux).Not.toRespondTo(@selector(barMethod)));
}

@end
