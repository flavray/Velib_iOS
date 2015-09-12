//
//  FRVFetcher.m
//  Velib
//
//  Created by Flavien Raynaud on 12/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVFetcher.h"
#import "Velib.h"

@implementation FRVFetcher

+ (NSString*)buildURL:(NSString*)url
{
    NSString* base = FRVWebserviceURL;
    
    return [NSString stringWithFormat:@"%@%@%@", base, url, @".json"];
}

+ (NSDictionary*)json:(NSString*)url
{
    NSError* error;
    
    NSData *response = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[self buildURL:url]]];

    if (!response) {
        NSLog(@"No response");
        return nil;
    }
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response
                                                           options:kNilOptions
                                                             error:&error];
    
    if (error) {
        NSLog(@"JSON Fetcher error: %@", error);
        return nil;
    }
    
    return result;
}

+ (NSDictionary*)jsonWithParts:(NSArray*)parts
{
    NSString* url = [parts componentsJoinedByString:@"/"];

    return [self json:url];
}

@end
