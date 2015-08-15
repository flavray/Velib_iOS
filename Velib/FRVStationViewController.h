//
//  FRVStationViewController.h
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRVStation;

@interface FRVStationViewController : UIViewController

- (instancetype)initWithStation:(FRVStation*)station;

@end
