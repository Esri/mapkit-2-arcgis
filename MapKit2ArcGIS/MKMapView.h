//
//  MKMapView.h
//  SimpleMap
//
//  Created by Al Pascual on 10/15/12.
//  Copyright (c) 2012 Esri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "MKTypes.h"
#import "MKGeometry.h"
#import "MKUserTrackingMode.h"
#import "MKOverlay.h"


@interface MKMapView : AGSMapView <AGSMapViewLayerDelegate>

// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;
@property (nonatomic) MKCoordinateRegion savedRegion;
@property (nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);

- (void)setRegion:(MKCoordinateRegion)region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)bAnimated;
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

@end
