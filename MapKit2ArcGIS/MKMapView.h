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
#import "MKAnnotation.h"
#import "MKAnnotationView.h"
#import "MKPinAnnotationView.h"


@protocol MKMapViewDelegate;


@interface MKMapView : AGSMapView <AGSMapViewLayerDelegate>
{
    BOOL shouldAnimate;
}

@property (nonatomic, assign) id <MKMapViewDelegate> delegate;
@property ( nonatomic, strong) NSMutableDictionary* idtoannotationDictionary;
@property ( nonatomic, strong) AGSGraphicsLayer* annotationGraphicsLayer;
// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;
@property (nonatomic) MKCoordinateRegion savedRegion;
@property ( nonatomic, strong) NSMutableArray* mapannotations;
@property (nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);


// Access the visible region of the map in projected coordinates.
@property (nonatomic) MKMapRect visibleMapRect;
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate;

- (void)setRegion:(MKCoordinateRegion)region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)bAnimated;
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

// Annotations are models used to annotate coordinates on the map.
// Implement mapView:viewForAnnotation: on MKMapViewDelegate to return the annotation view for each annotation.
- (void)addAnnotation:(id <MKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;

- (void)removeAnnotation:(id <MKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray *)annotations;

@property (nonatomic, readonly) NSArray *annotations;
- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect NS_AVAILABLE(NA, 4_2);

// Currently displayed view for an annotation; returns nil if the view for the annotation isn't being displayed.
- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation;
- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;
@end
@protocol MKMapViewDelegate <NSObject>

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end
