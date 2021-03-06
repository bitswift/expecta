#import "Fixtures.h"
#import <objc/runtime.h>

@implementation Foo; @end

@implementation Bar
- (NSString *)barMethod {
  return @"Bar!";
}

- (id)copyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] init];
}

- (BOOL)isEqual:(Bar *)obj {
  return [obj isKindOfClass:[Bar class]];
}

@end

@implementation Baz;
+ (void)load {
  class_addProtocol(self, @protocol(NSMutableCopying));
}

@end

@implementation EncodableObject
@synthesize array = m_array;
@synthesize string = m_string;

- (id)initWithString:(NSString *)theString array:(NSArray *)array {
  self = [super init];
  if (!self)
    return nil;

  self.string = theString;
  self.array = array;

  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.string forKey:@"string"];
  [coder encodeObject:self.array forKey:@"array"];
}

- (id)initWithCoder:(NSCoder *)coder {
  NSString *theString = [coder decodeObjectForKey:@"string"];
  NSArray *theArray = [coder decodeObjectForKey:@"array"];
  return [self initWithString:theString array:theArray];
}

- (BOOL)isEqual:(EncodableObject *)object {
  if (![object.array isEqual:object.array])
    return NO;

  if (![object.string isEqual:object.string])
    return NO;

  return YES;
}

@end
