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


@interface MKMapView : AGSMapView <AGSMapViewLayerDelegate>

// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;
@property (nonatomic) MKCoordinateRegion savedRegion;

- (void)setRegion:(MKCoordinateRegion)region;

@end
