//
//  FRVContract.h
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface FRVContract : RLMObject

@property int id;
@property NSString* name;
@property double latitude;
@property double longitude;
@property int stations_count;

@end

RLM_ARRAY_TYPE(FRVContract);
