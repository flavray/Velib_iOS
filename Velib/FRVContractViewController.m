//
//  FRVContractViewController.m
//  Velib
//
//  Created by Flavien Raynaud on 12/08/15.
//  Copyright (c) 2015 Flavien Raynaud. All rights reserved.
//

#import "FRVContractViewController.h"
#import "FRVContract.h"
#import "FRVStation.h"
#import "FRVStationStore.h"

@interface FRVContractViewController ()

@property (strong, nonatomic) FRVContract* contract;
@property (strong, nonatomic) RLMResults* stations;

@end

@implementation FRVContractViewController

#pragma mark - Contructor

- (instancetype)initWithContract:(FRVContract*)contract
{
    self = [super init];
    
    if (self) {
        [self.navigationItem setTitle:contract.name];

        _contract = contract;
        _stations = [[FRVStationStore sharedStore] ofContract:self.contract];
        
        NSLog(@"%li", self.stations.count);
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

    mapView.delegate = self;

    mapView.zoom = 11;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.contract.latitude, self.contract.longitude);
    mapView.centerCoordinate = center;
    
    [self.view addSubview:mapView];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    for (FRVStation* station in self.stations) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude);
        [mapView addAnnotation:[[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:coordinate
                                                            andTitle:station.name]];
    }
    
    mapView.clusteringEnabled = YES;
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    RMMapLayer *marker = nil;
    
    if (annotation.isClusterAnnotation) {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"circle.png"]];
        
        marker.opacity = 0.85;
        
        // set the size of the circle
        marker.bounds = CGRectMake(0, 0, 90, 90);
        
        /*
        // change the size of the circle depending on the cluster's size
        if ([annotation.clusteredAnnotations count] > 100) {
            layer.bounds = CGRectMake(0, 0, 70, 70);
        } else if ([annotation.clusteredAnnotations count] > 200) {
            layer.bounds = CGRectMake(0, 0, 100, 100);
        } else if ([annotation.clusteredAnnotations count] > 300) {
            layer.bounds = CGRectMake(0, 0, 120, 120);
        }
        */
        
        [(RMMarker *)marker setTextForegroundColor:[UIColor whiteColor]];
        
        [(RMMarker *)marker changeLabelUsingText:[NSString stringWithFormat:@"%lu",
                                                 (unsigned long)[annotation.clusteredAnnotations count]]];
    }
    else {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"bicycle"
                                                  tintColor:[UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000]];
        
        marker.canShowCallout = YES;
    }
    
    return marker;
}

- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation
{
    NSLog(@"%@", annotation);
}

/*
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    // add Maki icon and color the marker
    RMMarker *marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"bicycle"
                                                         tintColor:[UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000]];
    
    marker.canShowCallout = YES;
    
    return marker;
}
 */

@end
