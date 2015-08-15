//
//  FRVStationViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVStationViewController.h"
#import "FRVStation.h"
#import "FRVPredictionStore.h"

@interface FRVStationViewController ()

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UILabel* bikeStandsLabel;

@property (strong, nonatomic) FRVStation* station;
@property (strong, nonatomic) NSArray* predictions;

@end

@implementation FRVStationViewController

#pragma mark - Constructor

- (instancetype)initWithStation:(FRVStation*)station
{
    self = [super init];

    if (self) {
        _station = station;
        _predictions = [[FRVPredictionStore sharedStore] ofStation:station];

        NSLog(@"#Predictions for station: %ld", (unsigned long)[_predictions count]);
    }

    return self;
}

#pragma mark - View method

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.nameLabel.text = self.station.name;
    self.addressLabel.text = self.station.address;
    self.bikeStandsLabel.text = [NSString stringWithFormat:@"%d bike stands", self.station.bikeStands];
}

@end
