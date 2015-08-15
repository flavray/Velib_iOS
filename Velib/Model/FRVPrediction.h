//
//  FRVPrediction.h
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRVPrediction : NSObject

- (instancetype)initWithValue:(NSDictionary*)value;

@property (strong, nonatomic) NSDate* datetime;
@property NSInteger availableBikeStands;

@end
