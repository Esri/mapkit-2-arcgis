//
//  MKMapView.m
//  SimpleMap
//
//  Created by Al Pascual on 10/15/12.
//  Copyright (c) 2012 Esri. All rights reserved.
//

#import "MKMapView.h"

@implementation MKMapView

- (void)setRegion:(MKCoordinateRegion)region
{
    self.layerDelegate = self;
    self.savedRegion = region;
    
    NSLog(@"Set Region");
    NSURL* url;
    switch (self.mapType)
    {
        case 0:
            url = [NSURL URLWithString: @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
            break;
        case 1 :
            url = [NSURL URLWithString: @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer"];
            break;
        default:
            break;
    }

    AGSTiledMapServiceLayer* layer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: url];
    [self addMapLayer:layer withName:@"basemap"];
    
    
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)bAnimated
{
    shouldAnimate = bAnimated;
    [self setRegion:region];
}


- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    self.idtoannotationDictionary = [[NSMutableDictionary alloc] init];
    self.annotationGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    AGSPoint *wgs84Point = [[AGSPoint alloc] initWithX:self.savedRegion.center.longitude y:self.savedRegion.center.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
    
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *webMercatorPoint = (AGSPoint*)[engine projectGeometry:wgs84Point toSpatialReference:self.spatialReference];
    
   // [self zoomIn:YES];
    [self zoomToResolution:40 withCenterPoint:webMercatorPoint animated:shouldAnimate];

    // Not sure if this is has any importance
   // [self.delegate mapViewDidFinishLoadingMap:self];
    
    // Initialize the Annotations
    self.mapannotations = [[NSMutableArray  alloc] init];
    
}


- (void)removeAnnotation:(id <MKAnnotation>)annotation
{
    [self.mapannotations removeObject:annotation];
}

- (void)removeAnnotations:(NSArray *)annotations
{
    [self.mapannotations removeAllObjects];
}

- (void)addAnnotation:(id <MKAnnotation>)annotation
{
    [self.mapannotations addObject:annotation];
   MKAnnotationView* annotationView =  [self.delegate mapView:self viewForAnnotation:annotation];
    MKPinAnnotationView* pinAnnotationView = (MKPinAnnotationView*) annotationView;
    NSLog(@"reuse ID is %@", annotationView.reuseID);
    // Create the NSDictionary with identifier and annotationView
    if ( ! [self.idtoannotationDictionary objectForKey:annotationView.reuseID])
        [self.idtoannotationDictionary setObject:annotationView forKey:annotationView.reuseID];
    
    // add a new graphic based on the type
    
    
}

- (void)addAnnotations:(NSArray *)annotations
{
    [self.mapannotations addObjectsFromArray:annotations];
    for ( id<MKAnnotation> annotation in annotations)
    {
        [self.delegate mapView:self viewForAnnotation:annotation];
    }
}

- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    // return the graphics view if the layer exists else return NULL
   if ( [self.idtoannotationDictionary objectForKey:identifier])
   {
       return [self.idtoannotationDictionary objectForKey:identifier];
   }
    
    else
    {
        NSLog(@"Graphics doesnt exist");
        return NULL;
    }
}

- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
#warning not implemented
}

- (void)addOverlay:(id <MKOverlay>)overlay
{
    #warning not implemented
}

@end
