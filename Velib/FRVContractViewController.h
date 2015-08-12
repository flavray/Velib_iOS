//
//  FRVContractViewController.h
//  Velib
//
//  Created by Flavien Raynaud on 12/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRVContract;

@interface FRVContractViewController : UIViewController

@property (strong, nonatomic) FRVContract* contract;

- (instancetype)initWithContract:(FRVContract*)contract;

@end
