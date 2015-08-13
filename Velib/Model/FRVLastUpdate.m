//
//  FRVLastUpdate.m
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVLastUpdate.h"

@implementation FRVLastUpdate

+ (NSString*)primaryKey
{
    return @"key";
}

+ (NSDate*)lastUpdateForClass:(__unsafe_unretained Class)aClass
{
    NSString* className = NSStringFromClass(aClass);
    
    return [self lastUpdateForKey:className];
}

+ (void)setLastUpdateForClass:(__unsafe_unretained Class)aClass
{
    NSString* className = NSStringFromClass(aClass);

    return [self setLastUpdateForKey:className];
}

+ (NSDate*)lastUpdateForKey:(NSString*)key
{
    NSString* query = [NSString stringWithFormat:@"key = '%@'",key];
    
    RLMResults* lastUpdates = [FRVLastUpdate objectsWhere:query];
    
    if ([lastUpdates count] == 0)
        return nil;
    
    FRVLastUpdate* lastUpdate = [lastUpdates objectAtIndex:0];
    
    return lastUpdate.lastUpdate;
}

+ (void)setLastUpdateForKey:(NSString*)key
{
    NSDictionary*data = @{ @"key": key, @"lastUpdate": [NSDate date] };
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        [FRVLastUpdate createOrUpdateInRealm:realm
                                   withValue:data];
    }];
}


@end
