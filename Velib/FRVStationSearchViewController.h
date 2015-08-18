//
//  FRVStationSearchViewController.h
//  Velib
//
//  Created by Flavien Raynaud on 18/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FRVStation;

@interface FRVStationSearchViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate>

- (instancetype)initWithStations:(NSArray*)stations;

@end
