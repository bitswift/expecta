#import "TestHelper.h"

@interface EXPMatchers_toConformToTest : SenTestCase {
  Foo *foo;
  Bar *bar;
  Baz *baz;
  id qux;
}

@end

@implementation EXPMatchers_toConformToTest

- (void)setUp {
  foo = [[Foo new] autorelease];
  bar = [[Bar new] autorelease];
  baz = [[Baz new] autorelease];
  qux = [[NSObject alloc] init];
}

- (void)test_toConformTo {
  assertPass(test_expect(foo).toConformTo(@protocol(NSURLConnectionDelegate)));
  assertPass(test_expect([foo class]).toConformTo(@protocol(NSURLConnectionDelegate)));
  assertPass(test_expect(bar).toConformTo(@protocol(NSURLConnectionDelegate)));
  assertPass(test_expect(bar).toConformTo(@protocol(NSObject)));
  assertFail(test_expect(nil).toConformTo(@protocol(NSURLConnectionDelegate)), @"the actual value is nil/null");
  assertFail(test_expect(foo).toConformTo(nil), @"the expected value is nil/null");
  assertFail(test_expect(foo).toConformTo(@protocol(NSCoding)), @"expected: an object conforming to <NSCoding>, got: an instance of Foo, which does not conform to <NSCoding>");
  assertFail(test_expect(baz).toConformTo(@protocol(NSURLConnectionDelegate)), @"expected: an object conforming to <NSURLConnectionDelegate>, got: an instance of Baz, which does not conform to <NSURLConnectionDelegate>");
  assertPass(test_expect(qux).toConformTo(@protocol(NSObject)));

  // Baz nominally conforms to <NSMutableCopying>, but doesn't implement all of
  // the required methods
  assertFail(test_expect(baz).toConformTo(@protocol(NSMutableCopying)), @"expected: an object conforming to <NSMutableCopying>, got: an instance of Baz, which does not respond to -mutableCopyWithZone:");
  assertFail(test_expect([baz class]).toConformTo(@protocol(NSMutableCopying)), @"expected: an object conforming to <NSMutableCopying>, got: an instance of Baz, which does not respond to -mutableCopyWithZone:");
}

- (void)test_Not_toConformTo {
  assertPass(test_expect(foo).Not.toConformTo(@protocol(NSCoding)));
  assertPass(test_expect([foo class]).Not.toConformTo(@protocol(NSCoding)));
  assertPass(test_expect(bar).Not.toConformTo(@protocol(NSCoding)));
  assertPass(test_expect(baz).Not.toConformTo(@protocol(NSURLConnectionDelegate)));
  assertFail(test_expect(nil).Not.toConformTo(@protocol(NSURLConnectionDelegate)), @"the actual value is nil/null");
  assertFail(test_expect(foo).Not.toConformTo(nil), @"the expected value is nil/null");
  assertFail(test_expect(foo).Not.toConformTo(@protocol(NSURLConnectionDelegate)), @"expected: an object not conforming to <NSURLConnectionDelegate>, got: an instance of Foo, which does conform to <NSURLConnectionDelegate>");
  assertFail(test_expect(bar).Not.toConformTo(@protocol(NSURLConnectionDelegate)), @"expected: an object not conforming to <NSURLConnectionDelegate>, got: an instance of Bar, which does conform to <NSURLConnectionDelegate>");
  assertPass(test_expect(qux).Not.toConformTo(@protocol(NSURLConnectionDelegate)));

  assertPass(test_expect(baz).Not.toConformTo(@protocol(NSMutableCopying)));
  assertPass(test_expect([baz class]).Not.toConformTo(@protocol(NSMutableCopying)));
}

@end
