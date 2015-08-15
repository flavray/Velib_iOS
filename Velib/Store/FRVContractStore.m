//
//  FRVContractStore.m
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Realm/Realm.h>

#import "FRVContractStore.h"
#import "FRVContract.h"
#import "FRVFetcher.h"
#import "FRVLastUpdate.h"

@interface FRVContractStore ()

@property NSTimeInterval updateInterval;

@end

@implementation FRVContractStore

+ (instancetype)sharedStore
{
    static FRVContractStore* store = nil;

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
        [self update];

        _allItems = [FRVContract allObjects];
    }

    return self;
}

#pragma mark - Database manipulation

- (void)refresh
{
    [self update:YES];

    _allItems = [FRVContract allObjects];
}

- (void)update:(BOOL)force
{
    NSDate* lastUpdate = [FRVLastUpdate lastUpdateForClass:[self class]];

    // need to update if never updated or last update is too far in the past
    if (force || (!lastUpdate) || ([lastUpdate timeIntervalSinceNow] + [self updateInterval] < 0)) {
        if ([self fetch])
            [FRVLastUpdate setLastUpdateForClass:[self class]];
    }
}

- (void)update
{
    [self update:NO];
}

- (BOOL)fetch
{
    NSDictionary* json = [FRVFetcher json:@"/contracts"];
    
    if (!json) {
        NSLog(@"Contracts response is nil");
        return NO;
    }

    NSArray *contracts = [json objectForKey:@"contracts"];

    if (!contracts) {
        NSLog(@"No `contracts`");
        return NO;
    }
    
    RLMRealm* realm = [RLMRealm defaultRealm];

    [realm transactionWithBlock:^{
        [realm deleteObjects:[FRVContract allObjects]];

        for (NSDictionary* contract in contracts) {
            [FRVContract createOrUpdateInRealm:realm
                                     withValue:contract];
        }
    }];
    
    return YES;
}

@end
