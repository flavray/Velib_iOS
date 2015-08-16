//
//  FRVPredictionStore.h
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRVStation;

@interface FRVPredictionStore : NSObject

+ (instancetype)sharedStore;

- (NSArray*)ofStation:(FRVStation*)station;

- (NSArray*)ofStation:(FRVStation *)station after:(NSDate*)date;

@end
