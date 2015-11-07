//
//  LayerView.m
//  AppyParkingTest
//
//  Created by Robin Spinks on 05/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import "LayerView.h"

static const CGFloat height = 40;

@implementation LayerView

- (instancetype)initWithPosition:(int)position
                          colour:(UIColor*)colour {
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y = frame.size.height - height * position;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setPosition:position];
        [self setBackgroundColor:colour];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.expanded = !self.expanded;
    if (self.delegate) {
        [self.delegate touchesBegan:touches withEvent:event layer:self];
    }
}

@end
