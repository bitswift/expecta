#import "EXPMatcherHelpers.h"

BOOL EXPIsValuePointer(NSValue *value) {
  return [value objCType][0] == @encode(void *)[0];
}

BOOL EXPIsNumberFloat(NSNumber *number) {
  return strcmp([number objCType], @encode(float)) == 0;
}

BOOL EXPIsValueRect(NSValue *value) {
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
    return strcmp([value objCType], @encode(CGRect)) == 0 || strcmp([value objCType], @encode(NSRect)) == 0;
#else
    return strcmp([value objCType], @encode(CGRect)) == 0;
#endif
}