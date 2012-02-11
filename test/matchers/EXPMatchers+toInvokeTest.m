#import "TestHelper.h"

@interface EXPMatchers_toInvokeTest : SenTestCase
@property (nonatomic, assign) NSUInteger someValue;
@property (nonatomic, assign) NSUInteger anotherValue;
@end

@implementation EXPMatchers_toInvokeTest

@synthesize someValue = m_someValue;
@synthesize anotherValue = m_anotherValue;

- (void)setUp {
  self.someValue = 0;
  self.anotherValue = 0;
}

- (void)test_toInvoke {
  NSString *failureMessage = [NSString stringWithFormat:@"expected: setAnotherValue: to be invoked on %@", self];

  assertFail(test_expect([^{
    self.someValue = 5;
  } copy]).toInvoke(self, @selector(setAnotherValue:)), failureMessage);
  assertEquals(self.someValue, (NSUInteger)5);

  assertPass(test_expect([^{
    self.someValue = 10;
  } copy]).toInvoke(self, @selector(setSomeValue:)));
  assertEquals(self.someValue, (NSUInteger)10);
}

@end
