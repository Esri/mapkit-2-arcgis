/*
 Copyright 2013 Esri
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ArcGIS/ArcGIS.h>
#import "MKAnnotation.h"

@class CLLocation;

@interface MKUserLocation : NSObject <MKAnnotation> {

}

// Returns YES if the user's location is being updated.
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

// Returns nil if the owning MKMapView's showsUserLocation is NO or the user's location has yet to be determined.
@property ( nonatomic, strong) CLLocation *location;

// Returns nil if not in MKUserTrackingModeFollowWithHeading
@property (readonly, nonatomic, retain) CLHeading *heading NS_AVAILABLE(NA, 5_0);

// The title to be displayed for the user location annotation.
@property (nonatomic, copy) NSString *title;

// The subtitle to be displayed for the user location annotation.
@property (nonatomic, copy) NSString *subtitle;

@end

