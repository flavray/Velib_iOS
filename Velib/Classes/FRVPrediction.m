//
//  FRVPrediction.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVPrediction.h"
#import "FRVStation.h"

@implementation FRVPrediction

- (instancetype)initWithValue:(NSDictionary *)value station:(FRVStation*)station
{
    self = [super init];

    if (self) {
        NSTimeInterval timestamp = [[value objectForKey:@"timestamp"] doubleValue];

        _datetime = [NSDate dateWithTimeIntervalSince1970:timestamp];
        _available_bike_stands = [[value objectForKey:@"availableBikeStands"] integerValue];

        _station = station;
    }

    return self;
}

- (NSInteger)availableBikes
{
    return self.station.bike_stands - self.available_bike_stands;
}

@end
