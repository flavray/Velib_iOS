//
//  FRVStationStore.m
//  Velib
//
//  Created by Flavien Raynaud on 13/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Realm/Realm.h>

#import "FRVStationStore.h"
#import "FRVContract.h"
#import "FRVStation.h"
#import "FRVFetcher.h"
#import "FRVLastUpdate.h"

@interface FRVStationStore ()

@property (nonatomic, readonly) NSMutableDictionary* allItems;

@property NSTimeInterval updateInterval;

@end

@implementation FRVStationStore


+ (instancetype)sharedStore
{
    static FRVStationStore* store = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[self alloc] initPrivate];
    });
    
    return store;
}

#pragma mark - Constructors

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [FRVContractStore sharedStore]"
                                 userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _updateInterval = 10 * 24 * 60 * 60;  // 10 days
        // [self update];
        
        // _allItems = [FRVContract allObjects];
    }
    
    return self;
}

#pragma mark - Database manipulation

- (RLMResults*)ofContract:(FRVContract*)contract
{
    NSString* contractId = [NSString stringWithFormat:@"%i", contract.id];
    
    RLMResults* results = [self.allItems objectForKey:contractId];
    
    if (results)
        return results;
    
    [self update:NO withContract:contractId];
    
    results = [self stationsForContract:contract];
    
    [self.allItems setValue:results forKey:contractId];
    
    return results;
}

- (void)update:(BOOL)force withContract:(NSString*)contractId
{
    NSDate* lastUpdate = [FRVLastUpdate lastUpdateForKey:contractId];
    
    // need to update if never updated or last update is too far in the past
    if (force || (!lastUpdate) || ([lastUpdate timeIntervalSinceNow] + [self updateInterval] < 0)) {
        if ([self fetchContract:contractId])
            [FRVLastUpdate setLastUpdateForKey:contractId];
    }
}

- (BOOL)fetchContract:(NSString*)contractId
{
    NSDictionary* json = [FRVFetcher jsonWithParts:@[@"/contracts", contractId, @"stations"]];
    
    if (!json)
        return NO;
    
    NSArray *stations = [json objectForKey:@"stations"];
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    [realm transactionWithBlock:^{
        RLMResults* allStations = [FRVStation objectsWhere:@"contractId = %d", [contractId intValue]];
        [realm deleteObjects:allStations];
        
        for (NSDictionary* station in stations) {
            [FRVStation createOrUpdateInRealm:realm
                                     withValue:station];
        }
    }];
    
    return YES;
}

- (RLMResults*)stationsForContract:(FRVContract*)contract
{
    return [FRVStation objectsWhere:@"contractId = %d", contract.id];
}

@end
