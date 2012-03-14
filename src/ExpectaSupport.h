#import "EXPExpect.h"

id _EXPObjectify(char *type, ...);
EXPExpect *_EXP_expect(id testCase, int lineNumber, char *fileName, EXPIdBlock actualBlock);

void EXPFail(id testCase, int lineNumber, char *fileName, NSString *message);
NSString *EXPDescribeObject(id obj);

// workaround for the categories bug: http://developer.apple.com/library/mac/#qa/qa1490/_index.html
#define EXPFixCategoriesBug(name) \
@interface EXPFixCategoriesBug##name; @end \
@implementation EXPFixCategoriesBug##name; @end

#define _EXPMatcherInterface(matcherName, matcherArguments) \
@interface EXPExpect (matcherName##Matcher) \
@property (nonatomic, readonly) void(^ matcherName) matcherArguments; \
@end

#define _EXPMatcherImplementationBegin(matcherName, matcherArguments) \
EXPFixCategoriesBug(EXPMatcher##matcherName##Matcher); \
@implementation EXPExpect (matcherName##Matcher) \
@dynamic matcherName;\
- (void(^) matcherArguments) matcherName { \
  __block id actual = self.actual; \
  void (^prerequisite)(EXPBoolBlock block) = ^(EXPBoolBlock block) { self.prerequisiteBlock = block; }; \
  void (^match)(EXPBoolBlock block) = ^(EXPBoolBlock block) { self.matchBlock = block; }; \
  void (^failureMessageForTo)(EXPStringBlock block) = ^(EXPStringBlock block) { self.failureMessageForToBlock = block; }; \
  void (^failureMessageForNotTo)(EXPStringBlock block) = ^(EXPStringBlock block) { self.failureMessageForNotToBlock = block; }; \
  prerequisite(nil); match(nil); failureMessageForTo(nil); failureMessageForNotTo(nil); \
  void (^matcherBlock) matcherArguments = ^ matcherArguments { \
    {

#define _EXPMatcherImplementationEnd \
    } \
    [self applyMatcher:&actual]; \
  }; \
  return [[matcherBlock copy] autorelease]; \
} \
@end
