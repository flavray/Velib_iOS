//
//  FRVContractStore.h
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRVContractStore : NSObject

@property (nonatomic, readonly) RLMResults* allItems;

+ (instancetype) sharedStore;

@end
