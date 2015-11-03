//
//  MapPin.m
//  AppyParkingTest
//
//  Created by Robin Spinks on 03/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin

@synthesize coordinate = _coordinate;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location description:(NSString *)description {
    self = [super init];
    if (self != nil) {
        _coordinate = location;
        _cost = description;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self
                                                                    reuseIdentifier:@"CustomAnnotation"];
    
    annotationView.enabled = YES;
    annotationView.image = [UIImage imageNamed:@"paid-bay.png"];
    annotationView.centerOffset = CGPointMake(0, -annotationView.frame.size.height / 2);
    
    return annotationView;
}

@end
