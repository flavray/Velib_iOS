//
//  FRVStationStore.h
//  Velib
//
//  Created by Flavien Raynaud on 13/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class FRVContract;

@interface FRVStationStore : NSObject

+ (instancetype)sharedStore;

- (NSArray*)ofContract:(FRVContract*)contract;

@end
