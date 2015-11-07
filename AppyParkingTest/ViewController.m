//
//  ViewController.m
//  AppyParkingTest
//
//  Created by Robin Spinks on 01/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "MapPin.h"
#import "LayerView.h"
#import "LayerProtocol.h"

static const CGFloat height = 40;

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, LayerProtocol>

@property (nonatomic) MKMapView *mapView;
@property (nonatomic) CLLocationManager  *locationManager;
@property BOOL OKToLocate;
@property (nonatomic) NSMutableArray* annotations;
@property (nonatomic) NSMutableArray* layers;

@end

@implementation ViewController

#pragma mark ViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMapView];
    [self configureLocationManager];
    [self populateMap];
    [self.mapView showAnnotations:self.annotations animated:YES];
    [self addLayers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark custom methods

- (void)configureMapView {
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.mapView setVisibleMapRect:MKMapRectWorld];
    [self.mapView setDelegate:self];
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

- (NSArray*)loadData {
    NSArray* data;
    __autoreleasing NSError* error;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PaidBays" ofType:@"json"];
    NSData* jsonData = [[NSData alloc] initWithContentsOfFile:filePath options:0 error:&error];
    if (error) {
        NSLog(@"%s Error loading data: %@", __PRETTY_FUNCTION__, error.debugDescription);
    } else {
        id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (error) {
            NSLog(@"%s Error converting JSON: %@", __PRETTY_FUNCTION__, error.debugDescription);
        } else {
            data = [[NSArray alloc] initWithArray:object];
        }
    }
    return data;
}

- (void)populateMap {
    self.annotations = [[NSMutableArray alloc] init];
    NSArray* paidBays = [self loadData];
    
    for (NSDictionary* paidBay in paidBays) {
        NSString* cost = paidBay[@"costForRequestedOrMaximumDuration"];
        NSString* latitude = paidBay[@"latitude"];
        NSString* longitude = paidBay[@"longitude"];

        CLLocationDegrees degreesLatitude  = latitude.doubleValue;
        CLLocationDegrees degreesLongitude = longitude.doubleValue;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(degreesLatitude, degreesLongitude);
        MapPin* pin = [[MapPin alloc] initWithCoordinates:coordinate
                                              description:cost];
        [self.annotations addObject:pin];
    }
    [self.mapView addAnnotations:self.annotations];
}

- (void)addLayers {
    self.layers = [NSMutableArray new];
    [self createLayerAtPosition:4 withColour:[UIColor darkGrayColor]];
    [self createLayerAtPosition:3 withColour:[UIColor colorWithRed:1 green:0 blue:1 alpha:1]];
    [self createLayerAtPosition:2 withColour:[UIColor blueColor]];
    [self createLayerAtPosition:1 withColour:[UIColor greenColor]];
}

- (void)createLayerAtPosition:(int)position withColour:(UIColor*)colour {
    LayerView* layer = [[LayerView alloc] initWithPosition:position colour:colour];
    layer.delegate = self;
    [self.view addSubview:layer];
    [self.layers addObject:layer];
}

- (void)repositionLayers {
    for (LayerView* layer in self.layers) {
        CGRect frame = layer.frame;
        frame.origin.y = layer.frame.size.height - height * layer.position;
        [layer setFrame:frame];
    }
}

- (void)expandLayer:(LayerView*)layerView {
    for (LayerView* layer in self.layers) {
        CGRect frame = layer.frame;
        if (layer == layerView) {
            frame.origin.y = 0;
        } else {
            frame.origin.y = layer.frame.size.height;
        }
        [layer setFrame:frame];
    }
}

#pragma mark MKAnnotationView methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MapPin class]]) {
        MapPin *pin = (MapPin *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        if (annotationView == nil) {
            annotationView = pin.annotationView;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    } else {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
}

#pragma mark CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
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

#pragma mark LayerProtocol methods

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event layer:(LayerView*)layer {
    [UIView animateWithDuration:0.5 animations:^{
        if (layer.expanded) {
            [self expandLayer:layer];
        } else {
            [self repositionLayers];
        }
    }];
}

@end
