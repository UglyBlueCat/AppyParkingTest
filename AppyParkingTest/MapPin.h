//
//  MapPin.h
//  AppyParkingTest
//
//  Created by Robin Spinks on 03/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface MapPin : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *cost;

- (MKAnnotationView *)annotationView;
- (id)initWithCoordinates:(CLLocationCoordinate2D)location
              description:(NSString *)description;

@end
