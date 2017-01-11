//
//  MKCircleView.h
//  MapKit
//
//  Copyright (c) 2010-2012, Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <MapKit/MKCircle.h>
//#import <MapKit/MKFoundation.h>
//#import <MapKit/MKOverlayPathView.h>

#import "MKCircle.h"
#import "MKFoundation.h"
#import "MKOverlayPathView.h"


MK_CLASS_AVAILABLE(NA, 4_0)
@interface MKCircleView : MKOverlayPathView

- (id)initWithCircle:(MKCircle *)circle;

@property (nonatomic, readonly) MKCircle *circle;

@end
