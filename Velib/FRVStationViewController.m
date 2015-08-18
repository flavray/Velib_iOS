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
#import "FRVPredictionCell.h"

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

        // First prediction: current hour (== at most 59 minutes before)
        NSDate* date = [[NSDate date] dateByAddingTimeInterval:-59*60];

        _station = station;
        _predictions = [[FRVPredictionStore sharedStore] ofStation:station after:date];
    }

    return self;
}

#pragma mark - View method

- (void)viewDidLoad
{
    [super viewDidLoad];

    UINib* nib = [UINib nibWithNibName:@"FRVPredictionCell" bundle:nil];
    [self.predictionsTableView registerNib:nib forCellReuseIdentifier:@"FRVPredictionCell"];
}

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
    static NSString *tableIdentifier = @"FRVPredictionCell";

    FRVPrediction* prediction = [self.predictions objectAtIndex:indexPath.row];
    FRVPredictionCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];

    if (!cell) {
        cell = [[FRVPredictionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }

    static NSDateFormatter *formatter = nil;

    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm"];
    }

    cell.timeLabel.text = [formatter stringFromDate:prediction.datetime];
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (unsigned long)[prediction availableBikes]];  // [NSString stringWithFormat:@"%ld/%d", (long)prediction.availableBikeStands, prediction.station.bikeStands];

    return cell;
}

#pragma mark - Dismiss

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openMaps:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.station.latitude, self.station.longitude);

    MKPlacemark* placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];

    MKMapItem* mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.station.name;

    NSDictionary* launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
    MKMapItem* currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
    [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
}

@end
