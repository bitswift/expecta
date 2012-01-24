#import "EXPMatcherHelpers.h"

BOOL EXPIsValuePointer(NSValue *value) {
  return [value objCType][0] == @encode(void *)[0];
}

BOOL EXPIsNumberFloat(NSNumber *number) {
  return strcmp([number objCType], @encode(float)) == 0;
}

BOOL EXPIsValueRect(NSValue *value) {
    return strcmp([value objCType], @encode(CGRect)) == 0 || strcmp([value objCType], @encode(NSValue)) == 0;
}