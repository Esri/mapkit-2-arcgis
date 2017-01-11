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

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "MKTypes.h"
#import "MKGeometry.h"
#import "MKUserTrackingMode.h"
#import "MKOverlay.h"
#import "MKOverlayView.h"
#import "MKAnnotation.h"
#import "MKAnnotationView.h"
#import "MKPinAnnotationView.h"
#import "AnnotationTemplate.h"
#import "MKUserLocation.h"
#import "MKCircle.h"
#import "MKCircleView.h"


@protocol MKMapViewDelegate;


@interface MKMapView : AGSMapView <AGSMapViewLayerDelegate, MKAnnotation, AGSMapViewCalloutDelegate, MKOverlayViewDelegate>
{
    BOOL shouldAnimate;
}

@property (nonatomic, assign) id <MKMapViewDelegate> delegate;
@property ( nonatomic, strong) NSMutableDictionary* idtoannotationDictionary;
@property ( nonatomic, strong) AGSGraphicsLayer* annotationGraphicsLayer;
@property (nonatomic,strong) AnnotationTemplate* templateAnnotation;
// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;
@property (nonatomic) MKCoordinateRegion savedRegion;
@property (nonatomic,strong) AGSPoint* wgs84Point;
@property (nonatomic,strong) NSMutableArray* mapannotations;
@property (nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);
@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;


// Access the visible region of the map in projected coordinates.
@property (nonatomic) MKMapRect visibleMapRect;

- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
- (void)setShowsUserLocation;
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate;

- (void)setRegion:(MKCoordinateRegion)region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)bAnimated;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

// Annotations are models used to annotate coordinates on the map.
// Implement mapView:viewForAnnotation: on MKMapViewDelegate to return the annotation view for each annotation.
- (void)addAnnotation:(id <MKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;

- (void)removeAnnotation:(id <MKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray *)annotations;
//- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

- (void)setZoomEnable:(BOOL)enabled;
- (void)setScrollEnable:(BOOL)enabled;

@property (nonatomic, readonly) NSArray *annotations;
- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect NS_AVAILABLE(NA, 4_2);

// Currently displayed view for an annotation; returns nil if the view for the annotation isn't being displayed.
- (MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation;
- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

@property (nonatomic) BOOL showsUserLocation;
// The annotation representing the user's location
@property (nonatomic, strong) MKUserLocation *userLocation;
@end

@interface MKMapView (OverlaysAPI)

// Overlays are models used to represent areas to be drawn on top of the map.
// This is in contrast to annotations, which represent points on the map.
// Implement -mapView:viewForOverlay: on MKMapViewDelegate to return the view for each overlay.
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);
- (void)addOverlays:(NSArray *)overlays NS_AVAILABLE(NA, 4_0);

- (void)removeOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);
- (void)removeOverlays:(NSArray *)overlays NS_AVAILABLE(NA, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index NS_AVAILABLE(NA, 4_0);
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2 NS_AVAILABLE(NA, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay aboveOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(NA, 4_0);
- (void)insertOverlay:(id <MKOverlay>)overlay belowOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(NA, 4_0);



@property (nonatomic, readonly) NSArray *overlays NS_AVAILABLE(NA, 4_0);

// Currently displayed view for overlay; returns nil if the view has not been created yet.
- (MKOverlayView *)viewForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

@end

@protocol MKMapViewDelegate <NSObject>

@optional
- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error;

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation;


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(NA, 4_0);

// Called after the provided overlay views have been added and positioned in the map.
- (void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews NS_AVAILABLE(NA, 4_0);

- (void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(NA, 4_0);


@end
