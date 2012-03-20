#import "TestHelper.h"

@interface EXPMatchers_toTriggerNotificationForKeyPathTest : SenTestCase
@property (nonatomic, assign) NSUInteger someValue;
@end

@implementation EXPMatchers_toTriggerNotificationForKeyPathTest
@synthesize someValue = _someValue;

- (void)setUp {
  self.someValue = 0;
}

- (void)test_toTriggerNotificationForKeyPath {
  assertFail(test_expect([^{
    _someValue = 5;
  } copy]).toTriggerNotificationForKeyPath(self, @"someValue"), @"expected: a KVO notification for \"someValue\" to be triggered");

  assertEquals(self.someValue, (NSUInteger)5);

  assertPass(test_expect([^{
    self.someValue = 10;
  } copy]).toTriggerNotificationForKeyPath(self, @"someValue"));

  assertEquals(self.someValue, (NSUInteger)10);
}

- (void)test_Not_toTriggerNotificationForKeyPath {
  assertFail(test_expect([^{
    self.someValue = 15;
  } copy]).Not.toTriggerNotificationForKeyPath(self, @"someValue"), @"expected: a KVO notification for \"someValue\" not to be triggered");

  assertEquals(self.someValue, (NSUInteger)15);

  assertPass(test_expect([^{
    _someValue = 20;
  } copy]).Not.toTriggerNotificationForKeyPath(self, @"someValue"));

  assertEquals(self.someValue, (NSUInteger)20);
}

@end
