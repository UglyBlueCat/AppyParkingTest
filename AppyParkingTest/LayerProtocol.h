//
//  LayerProtocol.h
//  AppyParkingTest
//
//  Created by Robin Spinks on 05/11/2015.
//  Copyright © 2015 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LayerProtocol <NSObject>

@required

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event layer:(id)layer;

@end
