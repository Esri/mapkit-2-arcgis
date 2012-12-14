//
//  MKPinAnnotationView.h
//  MapKit
//
//  Copyright (c) 2009-2012, Apple Inc. All rights reserved.
//

#import <MapKit/MKAnnotationView.h>

enum {
    MKPinAnnotationColorRed = 0,
    MKPinAnnotationColorGreen,
    MKPinAnnotationColorPurple
};
typedef NSUInteger MKPinAnnotationColor;

@class MKPinAnnotationViewInternal;

MK_CLASS_AVAILABLE(NA, 3_0)
@interface MKPinAnnotationView : MKAnnotationView
{
@private
    MKPinAnnotationViewInternal *_pinInternal;
}

@property (nonatomic) MKPinAnnotationColor pinColor;

@property (nonatomic) BOOL animatesDrop;

@end
