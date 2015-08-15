//
//  FRVPredictionStore.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVPredictionStore.h"
#import "FRVStation.h"
#import "FRVPrediction.h"
#import "FRVFetcher.h"
#import "FRVLastUpdate.h"

@interface FRVPredictionStore ()

@property (nonatomic, readonly) NSMutableDictionary* allItems;

@property NSTimeInterval updateInterval;

@end

@implementation FRVPredictionStore

+ (instancetype)sharedStore
{
    static FRVPredictionStore* store = nil;

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
        _updateInterval = 1 * 60 * 60;  // 1 hour
        _allItems = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Station

- (NSArray*)ofStation:(FRVStation *)station
{
    NSString* key = [NSString stringWithFormat:@"station_predictions_%d", station.id];

    NSArray* predictions = [self.allItems valueForKey:key];

    if (predictions)
        return predictions;

    [self update:NO withStation:station];

    return [self.allItems valueForKey:key];
}

#pragma mark - Database manipulation

- (void)update:(BOOL)force withStation:(FRVStation*)station
{
    NSString* key = [NSString stringWithFormat:@"station_predictions_%d", station.id];

    NSDate* lastUpdate = [FRVLastUpdate lastUpdateForKey:key];

    // need to update if never updated or last update is too far in the past
    if (force || (!lastUpdate) || ([lastUpdate timeIntervalSinceNow] + [self updateInterval] < 0)) {
        NSArray* predictions = [self fetchStation:station];

        if (predictions)
            [self.allItems setValue:predictions forKey:key];
    }
}

- (NSArray*)fetchStation:(FRVStation*)station
{
    NSString* stationId = [NSString stringWithFormat:@"%d", station.id];

    NSDictionary* json = [FRVFetcher jsonWithParts:@[@"/stations", stationId]];

    if (!json) {
        NSLog(@"Station response is nil");
        return nil;
    }

    NSDictionary *jsonStation = [json objectForKey:@"station"];

    if (!jsonStation) {
        NSLog(@"No `station`");
        return nil;
    }

    NSArray* predictions = [jsonStation objectForKey:@"predictions"];

    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (NSDictionary* prediction in predictions)
        [result addObject:[[FRVPrediction alloc] initWithValue:prediction]];

    return [NSArray arrayWithArray:result];
}

@end
