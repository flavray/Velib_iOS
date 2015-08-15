//
//  FRVHelper.h
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Realm/Realm.h>

@interface FRVHelper : NSObject

+ (NSArray*)resultsToArray:(RLMResults*)results;

@end
