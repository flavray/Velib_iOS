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

- (void)update
{
    NSDate* lastUpdate = [FRVLastUpdate lastUpdateForClass:[self class]];

    // need to update if never updated or last update is too far in the past
    if ((!lastUpdate) || ([lastUpdate timeIntervalSinceNow] + [self updateInterval] < 0)) {
        [self fetch];
        [FRVLastUpdate setLastUpdateForClass:[self class]];
    }
}

- (void)fetch
{
    NSError* error;

    NSData *response = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://localhost:3000/contracts"]];

    NSArray *contracts = [[NSJSONSerialization
                           JSONObjectWithData:response
                           options:kNilOptions
                           error:&error] objectForKey:@"contracts"];

    RLMRealm* realm = [RLMRealm defaultRealm];

    [realm transactionWithBlock:^{
        [realm deleteObjects:[FRVContract allObjects]];

        for (NSDictionary* contract in contracts) {
            [FRVContract createOrUpdateInRealm:realm
                                     withValue:contract];
        }
    }];
}

@end
