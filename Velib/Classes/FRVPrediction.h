//
//  FRVPrediction.h
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRVStation;

@interface FRVPrediction : NSObject

@property (strong, nonatomic) NSDate* datetime;
@property NSInteger availableBikeStands;

@property (strong, nonatomic) FRVStation* station;

- (instancetype)initWithValue:(NSDictionary*)value station:(FRVStation*)station;

- (NSInteger)availableBikes;

@end
