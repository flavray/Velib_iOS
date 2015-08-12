//
//  FRVFetcher.h
//  Velib
//
//  Created by Flavien Raynaud on 12/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRVFetcher : NSObject

+ (NSDictionary*)json:(NSString*)url;

+ (NSDictionary*)jsonWithParts:(NSArray*)parts;

@end
