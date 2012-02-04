#import <Foundation/Foundation.h>

@interface Foo : NSObject <NSURLConnectionDelegate>; @end;

@interface Bar : Foo
- (NSString *)barMethod;
@end

@interface Baz : NSObject; @end;

@interface EncodableObject : NSObject <NSCoding>
- (id)initWithString:(NSString *)theString array:(NSArray *)array;
@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) NSString *string;
@end
