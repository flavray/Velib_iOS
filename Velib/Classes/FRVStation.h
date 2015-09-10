//
//  FRVStation.h
//  Velib
//
//  Created by Flavien Raynaud on 13/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Realm/Realm.h>

@interface FRVStation : RLMObject

@property int id;
@property NSString* name;
@property NSString* address;
@property int bikeStands;
@property double latitude;
@property double longitude;
@property int contractId;

@end

RLM_ARRAY_TYPE(FRVStation);
