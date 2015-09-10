//
//  FRVHelper.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVHelper.h"

@implementation FRVHelper

+ (NSArray*)resultsToArray:(RLMResults*)results
{
    NSMutableArray* response = [[NSMutableArray alloc] init];

    for (id item in results)
        [response addObject:item];

    return response;
}

@end
