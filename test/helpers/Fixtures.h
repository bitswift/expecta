#import <Foundation/Foundation.h>

@interface Foo : NSObject <NSURLConnectionDelegate>; @end;

@interface Bar : Foo
- (NSString *)barMethod;
@end

@interface Baz : NSObject; @end;
