//
//  FRVPrediction.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVPrediction.h"

@implementation FRVPrediction

- (instancetype)initWithValue:(NSDictionary *)value
{
    self = [super init];

    if (self) {
        NSTimeInterval timestamp = [[value objectForKey:@"timestamp"] doubleValue];

        _datetime = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _availableBikeStands = [[value objectForKey:@"available_bike_stands"] integerValue];
    }

    return self;
}

@end
