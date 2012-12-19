//
//  LQGeonoteDelegate.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/31/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LQGeonote;

@protocol LQGeonoteDelegate <NSObject>

@required
- (void)geonote:(LQGeonote *)geonote locationDidChange:(CLLocation *)newLocation;

@optional
- (void)geonote:(LQGeonote *)geonote radiusDidChange:(CGFloat)newRadius;
- (void)geonote:(LQGeonote *)geonote textDidChange:(NSString *)newText;

@end
