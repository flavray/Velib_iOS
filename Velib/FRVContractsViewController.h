//
//  FRVContractsViewController.h
//  Velib
//
//  Created by Flavien Raynaud on 09/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface FRVContractsViewController : UITableViewController

@property (strong, nonatomic) RLMResults* contracts;

@end
