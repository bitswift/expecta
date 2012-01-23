#import <Foundation/Foundation.h>

@interface Foo : NSObject <NSURLConnectionDelegate>; @end;
@interface Bar : Foo; @end;
@interface Baz : NSObject; @end;
