//
//  FRVLastUpdate.h
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Realm/Realm.h>

@interface FRVLastUpdate : RLMObject

@property NSString* className;
@property NSDate* lastUpdate;

+ (NSDate*)lastUpdateForClass:(__unsafe_unretained Class)aClass;
+ (void)setLastUpdateForClass:(__unsafe_unretained Class)aClass;

@end

RLM_ARRAY_TYPE(FRVLastUpdate)
