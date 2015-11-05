//
//  LayerView.h
//  AppyParkingTest
//
//  Created by Robin Spinks on 05/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LayerProtocol.h"

@interface LayerView : UIView

@property (nonatomic) BOOL expanded;

@property (nonatomic) id<LayerProtocol> delegate;

- (instancetype)initWithPosition:(int)position
                          colour:(UIColor*)colour;

@end
