//
//  FRVStationViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 16/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVStationViewController.h"
#import "FRVStation.h"
#import "FRVPrediction.h"
#import "FRVPredictionStore.h"

@interface FRVStationViewController ()

@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* addressLabel;
@property (weak, nonatomic) IBOutlet UILabel* bikeStandsLabel;
@property (weak, nonatomic) IBOutlet UITableView *predictionsTableView;

@property (strong, nonatomic) FRVStation* station;
@property (strong, nonatomic) NSArray* predictions;

@end

@implementation FRVStationViewController

#pragma mark - Constructor

- (instancetype)initWithStation:(FRVStation*)station
{
    self = [super init];

    if (self) {
        [self.navigationItem setTitle:station.name];

        _station = station;
        _predictions = [[FRVPredictionStore sharedStore] ofStation:station];
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

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.predictions)
        return 0;

    return [self.predictions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PredictionCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)[[self.predictions objectAtIndex:indexPath.row] availableBikeStands]];

    return cell;
}

@end
