//
//  MKShape.h
//  MapKit
//
//  Copyright (c) 2010-2012, Apple Inc. All rights reserved.
//

//#import <Foundation/Foundation.h>
//#import <MapKit/MKAnnotation.h>
//#import <MapKit/MKFoundation.h>

#import <Foundation/Foundation.h>
#import "MKAnnotation.h"
#import "MKFoundation.h"

MK_CLASS_AVAILABLE(NA, 4_0)
@interface MKShape : NSObject <MKAnnotation> {
@package
    NSString *_title;
    NSString *_subtitle;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
