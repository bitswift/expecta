#import "TestHelper.h"

@interface EXPMatchers_toInvokeTest : SenTestCase
@property (nonatomic, assign) NSUInteger someValue;
@property (nonatomic, assign) NSUInteger anotherValue;
@end

@implementation EXPMatchers_toInvokeTest

@synthesize someValue = m_someValue;

- (void)setAnotherValue:(NSUInteger)value {
  self.someValue = value;
}

- (NSUInteger)anotherValue {
  return self.someValue;
}

- (void)setUp {
  self.someValue = 0;
  self.anotherValue = 0;
}

- (void)test_toInvoke {
  NSString *failureMessage = [NSString stringWithFormat:@"expected: setAnotherValue: to be invoked on %@", self];

  assertFail(test_expect([^{
    self.someValue = 5;

    // verify that the class of 'self' is still correct within the block
    assertEqualObjects(self.class, [EXPMatchers_toInvokeTest class]);
  } copy]).toInvoke(self, @selector(setAnotherValue:)), failureMessage);

  assertEquals(self.someValue, (NSUInteger)5);

  assertPass(test_expect([^{
    self.someValue = 10;
  } copy]).toInvoke(self, @selector(setSomeValue:)));

  assertEquals(self.someValue, (NSUInteger)10);

  assertPass(test_expect([^{
    self.anotherValue = 15;
  } copy]).toInvoke(self, @selector(setSomeValue:)));

  assertEquals(self.anotherValue, (NSUInteger)15);
  assertEquals(self.someValue, (NSUInteger)15);
}

- (void)test_toInvoke_Reentrancy {
  NSObject *obj = [[[NSObject alloc] init] autorelease];

  // verify that toInvoke() can be nested
  assertPass(test_expect([^{
    assertPass(test_expect([^{
      self.someValue = 10;

      // and other matchers can be nested within too
      assertPass(test_expect(self.someValue).toEqual(10));
    } copy]).Not.toInvoke(self, @selector(setAnotherValue:)));

    [obj description];
  } copy]).toInvoke(obj, @selector(description)));
}

- (void)test_Not_toInvoke {
  NSString *failureMessage = [NSString stringWithFormat:@"expected: setAnotherValue: not to be invoked on %@", self];

  assertFail(test_expect([^{
    self.anotherValue = 15;
    
    // verify that the class of 'self' is still correct within the block
    assertEqualObjects(self.class, [EXPMatchers_toInvokeTest class]);
  } copy]).Not.toInvoke(self, @selector(setAnotherValue:)), failureMessage);
  assertEquals(self.anotherValue, (NSUInteger)15);

  assertPass(test_expect([^{
    self.someValue = 20;
  } copy]).Not.toInvoke(self, @selector(setAnotherValue:)));
  assertEquals(self.someValue, (NSUInteger)20);

  failureMessage = [NSString stringWithFormat:@"expected: setSomeValue: not to be invoked on %@", self];

  assertFail(test_expect([^{
    self.anotherValue = 15;
  } copy]).Not.toInvoke(self, @selector(setSomeValue:)), failureMessage);
  assertEquals(self.anotherValue, (NSUInteger)15);
  assertEquals(self.someValue, (NSUInteger)15);
}

@end
