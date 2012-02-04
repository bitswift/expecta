//
//  EXPMatchers+toSupportArchiving.m
//  Expecta
//
//  Created by Josh Vera on 1/30/12.
//  Copyright (c) 2012 Peter Jihoon Kim. All rights reserved.
//

#import "EXPMatchers+toSupportArchiving.h"

EXPMatcherImplementationBegin(toSupportArchiving, (void)) {
    BOOL actualIsNil = (actual == nil);
    
    prerequisite(^BOOL{
        return !(actualIsNil);
    });
    
    match(^BOOL{
        if (![actual conformsToProtocol:@protocol(NSCoding)])
            return NO;
        
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:actual];
        if (!archivedData)
            return NO;
        
        id expected = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        if (!expected)
            return NO;
        
        return [actual isEqual:expected];
    });
    
    failureMessageForTo(^NSString *{
        if(actualIsNil) return @"the actual value is nil/null";
        return @"the actual value does not conform to <NSCoding>";
    });
    
    failureMessageForNotTo(^NSString *{
        if(actualIsNil) return @"the actual value is nil/null";
        return @"the actual value does not conform to <NSCoding>";        
    });
}

EXPMatcherImplementationEnd