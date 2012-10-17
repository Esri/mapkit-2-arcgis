//
//  MKUserLocation.h
//  MapKit
//
//  Copyright (c) 2009-2012, Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MKAnnotation.h"

@class CLLocation;

@interface MKUserLocation : NSObject <MKAnnotation> {

}

// Returns YES if the user's location is being updated.
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

// Returns nil if the owning MKMapView's showsUserLocation is NO or the user's location has yet to be determined.
@property (readonly, retain, nonatomic) CLLocation *location;

// Returns nil if not in MKUserTrackingModeFollowWithHeading
@property (readonly, nonatomic, retain) CLHeading *heading NS_AVAILABLE(NA, 5_0);

// The title to be displayed for the user location annotation.
@property (nonatomic, copy) NSString *title;

// The subtitle to be displayed for the user location annotation.
@property (nonatomic, copy) NSString *subtitle;

@end

