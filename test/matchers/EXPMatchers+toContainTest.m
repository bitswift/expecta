#import "TestHelper.h"

@interface EXPMatchers_toContainTest : SenTestCase {
  NSArray *array, *array2;
  NSString *string;
  NSSet *set;
  NSOrderedSet *orderedSet;
}
@end

@implementation EXPMatchers_toContainTest

- (void)setUp {
  array = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
  array2 = [NSArray arrayWithObjects:[NSString class], [NSDictionary class], nil];

  set = [NSSet setWithArray:array];
  orderedSet = [NSOrderedSet orderedSetWithArray:array];

  string = @"foo|bar,baz";
}

- (void)test_toContain {
  assertPass(test_expect(array).toContain(@"foo"));
  assertPass(test_expect(array).toContain(@"bar"));
  assertPass(test_expect(array).toContain(@"baz"));
  assertFail(test_expect(array).toContain(@"qux"), @"expected (foo, bar, baz) to contain qux");

  assertPass(test_expect(set).toContain(@"foo"));
  assertPass(test_expect(set).toContain(@"bar"));
  assertPass(test_expect(set).toContain(@"baz"));

  NSString *setFailureMessage = [NSString stringWithFormat:@"expected {(%@)} to contain qux", [[set allObjects] componentsJoinedByString:@", "]];
  assertFail(test_expect(set).toContain(@"qux"), setFailureMessage);

  assertPass(test_expect(orderedSet).toContain(@"foo"));
  assertPass(test_expect(orderedSet).toContain(@"bar"));
  assertPass(test_expect(orderedSet).toContain(@"baz"));
  assertFail(test_expect(orderedSet).toContain(@"qux"), @"expected {(foo, bar, baz)} to contain qux");

  assertPass(test_expect(string).toContain(@"foo"));
  assertPass(test_expect(string).toContain(@"bar"));
  assertPass(test_expect(string).toContain(@"baz"));
  assertFail(test_expect(string).toContain(@"qux"), @"expected foo|bar,baz to contain qux");
  assertFail(test_expect(string).toContain(nil), @"the expected value is nil/null");
  assertFail(test_expect([NSDictionary dictionary]).toContain(@"foo"), @"{} is not an NSString or a collection implementing -containsObject:");
  assertPass(test_expect(array2).toContain([NSString class]));
}

- (void)test_Not_toContain {
  assertPass(test_expect(array).Not.toContain(@"qux"));
  assertPass(test_expect(array).Not.toContain(@"quux"));
  assertFail(test_expect(array).Not.toContain(@"foo"), @"expected (foo, bar, baz) not to contain foo");

  assertPass(test_expect(set).Not.toContain(@"qux"));
  assertPass(test_expect(set).Not.toContain(@"quux"));

  NSString *setFailureMessage = [NSString stringWithFormat:@"expected {(%@)} not to contain foo", [[set allObjects] componentsJoinedByString:@", "]];
  assertFail(test_expect(set).Not.toContain(@"foo"), setFailureMessage);

  assertPass(test_expect(orderedSet).Not.toContain(@"qux"));
  assertPass(test_expect(orderedSet).Not.toContain(@"quux"));
  assertFail(test_expect(orderedSet).Not.toContain(@"foo"), @"expected {(foo, bar, baz)} not to contain foo");

  assertPass(test_expect(string).Not.toContain(@"qux"));
  assertPass(test_expect(string).Not.toContain(@"quux"));
  assertFail(test_expect(string).Not.toContain(@"baz"), @"expected foo|bar,baz not to contain baz");
  assertFail(test_expect(string).Not.toContain(nil), @"the expected value is nil/null");
  assertFail(test_expect([NSDictionary dictionary]).Not.toContain(@"foo"), @"{} is not an NSString or a collection implementing -containsObject:");
  assertPass(test_expect(array2).Not.toContain([NSSet class]));
}

@end
