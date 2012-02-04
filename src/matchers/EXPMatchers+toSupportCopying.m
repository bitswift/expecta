#import "EXPMatchers+toSupportCopying.h"

EXPMatcherImplementationBegin(toSupportCopying, (void)) {
	BOOL actualIsNil = (actual == nil);

	prerequisite(^BOOL{
		return !(actualIsNil);
	});

	match(^BOOL{
		if (![actual conformsToProtocol:@protocol(NSCopying)])
			return NO;

		id expected = [actual copy];
		if (!expected)
			return NO;

		return [actual isEqual:expected];
	});

	failureMessageForTo(^NSString *{
		if(actualIsNil) return @"the actual value is nil/null";
    return [NSString stringWithFormat:@"expected: an object implementing <NSCopying>, got: an instance of %@, which does not support copying", [actual class]];
	});

	failureMessageForNotTo(^NSString *{
		if(actualIsNil) return @"the actual value is nil/null";
    return [NSString stringWithFormat:@"expected: an object not implementing <NSCopying>, got: an instance of %@, which does support copying", [actual class]];
	});
}

EXPMatcherImplementationEnd
