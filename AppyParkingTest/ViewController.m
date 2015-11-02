//
//  ViewController.m
//  AppyParkingTest
//
//  Created by Robin Spinks on 01/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

//@import MapKit;

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationManager  *locationManager;
@property BOOL OKToLocate;

@end

@implementation ViewController

#pragma mark ViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMapView];
    [self configureLocationManager];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark custom methods

- (void)configureMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setVisibleMapRect:MKMapRectWorld];
    [self.view addSubview:self.mapView];
}

- (void)configureLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self updateLocationManager];
}

- (void)updateLocationManager {
    if (self.OKToLocate) {
        [self.locationManager startUpdatingLocation];
        [self.mapView setShowsUserLocation:YES];
    }
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s: %@", __PRETTY_FUNCTION__, error.debugDescription);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.OKToLocate = YES;
    } else {
        self.OKToLocate = NO;
    }
    [self updateLocationManager];
}

@end
