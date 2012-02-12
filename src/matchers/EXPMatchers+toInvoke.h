#import "Expecta.h"

// The actual value passed to expect must be a heap allocated block.
EXPMatcherInterface(toInvoke, (id target, SEL action));
