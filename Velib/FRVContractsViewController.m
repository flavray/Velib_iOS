//
//  FRVContractsViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVContractsViewController.h"

@interface FRVContractsViewController ()

@end

@implementation FRVContractsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        [self.navigationItem setTitle:@"Contracts"];
    }

    return self;
}

@end
