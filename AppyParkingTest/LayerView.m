//
//  LayerView.m
//  AppyParkingTest
//
//  Created by Robin Spinks on 05/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import "LayerView.h"

static const CGFloat height = 40;

@implementation LayerView {
    int _position;
}

- (instancetype)initWithPosition:(int)position
                          colour:(UIColor*)colour {
    _position = position;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y = frame.size.height - height * position;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:colour];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate) {
        [self.delegate touchesBegan:touches withEvent:event layer:self];
    }
}

- (void)returnToPosition {
    
}

@end
