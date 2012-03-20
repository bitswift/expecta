#import "EXPMatchers+toTriggerNotificationForKeyPath.h"

static char * const EXPToTriggerNotificationObserverContext = "EXPToTriggerNotificationObserverContext";

@interface EXPToTriggerNotificationObserver : NSObject
@property (nonatomic, assign) BOOL invoked;
@end

EXPMatcherImplementationBegin(toTriggerNotificationForKeyPath, (id object, NSString *keyPath)) {
  BOOL actualIsNil = (actual == nil);
  BOOL objectIsNil = (object == nil);
  BOOL keyPathIsNil = (keyPath == nil);

  prerequisite(^BOOL{
    if (actualIsNil || objectIsNil || keyPathIsNil)
      return NO;
    
    return YES;
  });

  match(^BOOL{
    void (^actualBlock)(void) = actual;

    EXPToTriggerNotificationObserver *observer = [[EXPToTriggerNotificationObserver alloc] init];
    [object addObserver:observer forKeyPath:keyPath options:0 context:EXPToTriggerNotificationObserverContext];

    @try {
      actualBlock();
    } @finally {
      [object removeObserver:observer forKeyPath:keyPath context:EXPToTriggerNotificationObserverContext];
    }

    BOOL invoked = observer.invoked;
    [observer release];

    return invoked;
  });

  failureMessageForTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(objectIsNil) return @"the object is nil/null";
    if(keyPathIsNil) return @"the key path to be notified of is nil/null";

    return [NSString stringWithFormat:@"expected: a KVO notification for \"%@\" to be triggered", keyPath];
  });

  failureMessageForNotTo(^NSString *{
    if(actualIsNil) return @"the actual value is nil/null";
    if(objectIsNil) return @"the object is nil/null";
    if(keyPathIsNil) return @"the key path which to not be notified of is nil/null";

    return [NSString stringWithFormat:@"expected: a KVO notification for \"%@\" not to be triggered", keyPath];
  });
}
EXPMatcherImplementationEnd

@implementation EXPToTriggerNotificationObserver
@synthesize invoked = _invoked;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (context == EXPToTriggerNotificationObserverContext)
    self.invoked = YES;
  else
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
