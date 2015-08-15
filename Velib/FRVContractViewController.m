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

#import <CoreLocation/CoreLocation.h>

@interface FRVContractViewController ()

@property (strong, nonatomic) FRVContract* contract;
@property (strong, nonatomic) RLMResults* stations;

@property (strong, nonatomic) RMMapView* mapView;

@property (strong, nonatomic) CLLocationManager* locationManager;

@property BOOL locationFound;

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
        
        NSLog(@"%lu", (unsigned long)[self.stations count]);

        [self initLocation];
    }
    
    return self;
}

- (void)initLocation
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];

    _locationFound = NO;
}

#pragma mark - View methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[RMConfiguration sharedInstance] setAccessToken:@"pk.eyJ1IjoiZmxhdnIiLCJhIjoiZWFkYmQ2YTEzZDRhNDg1MmM2ZDYwZjBiNzkxMzRlODIifQ.hVVth3HEgVYI4wyaWw9BQg"];
    
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"mapbox.streets"];
    
    self.mapView = [[RMMapView alloc] initWithFrame:self.view.bounds
                                      andTilesource:tileSource];

    self.mapView.delegate = self;

    self.mapView.zoom = 13.0f;

    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.contract.latitude, self.contract.longitude);
    self.mapView.centerCoordinate = center;


    self.mapView.showsUserLocation = YES;

    self.mapView.hideAttribution = YES;
    
    [self.view addSubview:self.mapView];
    
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    NSDate* start = [NSDate date];

    for (FRVStation* station in self.stations) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(station.latitude, station.longitude);

        RMAnnotation* annotation = [[RMAnnotation alloc] initWithMapView:self.mapView
                                                              coordinate:coordinate
                                                                andTitle:station.name];
        [self.mapView addAnnotation:annotation];
        annotation.userInfo = station;  // Store the station to retrieve it later in other methods
    }

    NSLog(@"%lf", -[start timeIntervalSinceNow]);
    
    self.mapView.clusteringEnabled = YES;
}

- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation
{
    NSLog(@"%@", (FRVStation*)annotation.userInfo);
}

#pragma mark - Annotation layers

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMapLayer* layer = nil;

    if (annotation.isUserLocationAnnotation) {
        layer = [self userAnnotationLayer];
    } else if (annotation.isClusterAnnotation) {
        layer = [self clusterAnnotationLayer:[annotation.clusteredAnnotations count]];
    } else {
        layer = [self basicAnnotationLayer];
    }

    return layer;
}

- (RMMapLayer*)userAnnotationLayer
{
    return [[RMMarker alloc] initWithMapboxMarkerImage:@"pitch"
                                             tintColor:[UIColor colorWithRed:0.124 green:0.571 blue:0.480 alpha:1.000]];
}

- (RMMapLayer*)clusterAnnotationLayer:(NSUInteger)clusterSize
{
    CGFloat radius = (CGFloat)clusterSize * 12.5f;

    RMCircle *circle = [[RMCircle alloc] initWithView:self.mapView radiusInMeters:radius];

    circle.lineColor = [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000];
    circle.fillColor = [UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:0.250];
    circle.lineWidthInPixels = 2.0;

    // [(RMMarker *)circle setTextForegroundColor:[UIColor whiteColor]];
    // [(RMMarker *)circle changeLabelUsingText:[NSString stringWithFormat:@"%lu", (unsigned long)clusterSize]];

    return circle;
}

- (RMMapLayer*)basicAnnotationLayer
{
    RMMarker* marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"bicycle"
                                            tintColor:[UIColor colorWithRed:0.224 green:0.671 blue:0.780 alpha:1.000]];

    marker.canShowCallout = YES;

    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    return marker;
}

#pragma mark - Callout

- (void)tapOnCalloutAccessoryControl:(UIControl *)control
                       forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSLog(@"Callout for station %@", (FRVStation*)annotation.userInfo);
}

#pragma mark - Clustering on zoom

- (void)afterMapZoom:(RMMapView *)map byUser:(BOOL)wasUserAction
{
    if (self.mapView.clusteringEnabled && (self.mapView.zoom >= 14.0f))
        self.mapView.clusteringEnabled = NO;
    else if ((!self.mapView.clusteringEnabled) && (self.mapView.zoom < 14.0f))
        self.mapView.clusteringEnabled = YES;
}

#pragma mark - Location service

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.locationFound)
        return;

    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    self.mapView.zoom = 14.0f;
    self.mapView.clusteringEnabled = NO;
    self.locationFound = YES;
}

@end
