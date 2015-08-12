//
//  FRVContractViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 12/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVContractViewController.h"
#import "FRVContract.h"

#import "Mapbox.h"

@interface FRVContractViewController ()

@end

@implementation FRVContractViewController

#pragma mark - Contructor

- (instancetype)initWithContract:(FRVContract*)contract
{
    self = [super init];
    
    if (self) {
        _contract = contract;
    }
    
    return self;
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoiZmxhdnIiLCJhIjoiZWFkYmQ2YTEzZDRhNDg1MmM2ZDYwZjBiNzkxMzRlODIifQ.hVVth3HEgVYI4wyaWw9BQg"];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"mapbox.streets"];
    
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                            andTilesource:tileSource];

    mapView.zoom = 11;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.contract.latitude, self.contract.longitude);
    mapView.centerCoordinate = center;
    
    [self.view addSubview:mapView];
}

@end
