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
    [self addMapLayer:self.annotationGraphicsLayer withName:@"Annotation Graphics Layer"];
    
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
    [self.annotationGraphicsLayer removeAllGraphics];
}

- (void)removeAnnotations:(NSArray *)annotations
{
    [self.mapannotations removeAllObjects];
    [self.annotationGraphicsLayer removeAllGraphics];
}

- (void)addAnnotation:(id <MKAnnotation>)annotation
{
    [self.mapannotations addObject:annotation];
   MKAnnotationView* annotationView =  [self.delegate mapView:self viewForAnnotation:annotation];
   MKPinAnnotationView* pinAnnotationView = (MKPinAnnotationView*) annotationView;
   // Create the NSDictionary with identifier and annotationView
   if ( ! [self.idtoannotationDictionary objectForKey:annotationView.reuseID])
        [self.idtoannotationDictionary setObject:annotationView forKey:annotationView.reuseID];
    
   // add a new graphic based on the type
   AGSPictureMarkerSymbol* pictureMarkerSymbol;
   if ( pinAnnotationView.image)
   {
       pictureMarkerSymbol  = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImage:pinAnnotationView.image];
   }
   else
   {
       pictureMarkerSymbol  = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"BlueStickpin.png"];
   }
    
   AGSPoint* markerPoint = [AGSPoint pointWithX:annotation.coordinate.longitude y:annotation.coordinate.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
    
   AGSPoint* newMarkerPoint = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:markerPoint toSpatialReference:self.spatialReference];
   AGSGraphic* myGraphic = [AGSGraphic graphicWithGeometry:newMarkerPoint symbol:pictureMarkerSymbol attributes:nil infoTemplateDelegate:nil];
    
    AnnotationTemplate* template = [[AnnotationTemplate alloc] init];
    template.title = annotation.title;
    template.subtitle = annotation.subtitle;
    if ( pinAnnotationView.leftCalloutAccessoryView)
    {
        template.leftView =  [[UIView alloc] initWithFrame:pinAnnotationView.leftCalloutAccessoryView.frame];
        template.leftView = pinAnnotationView.leftCalloutAccessoryView;
        //template.image = imageView.image;
    }
    
    if ( pinAnnotationView.rightCalloutAccessoryView)
    {
        template.rightView = pinAnnotationView.rightCalloutAccessoryView;
    }
    
   myGraphic.infoTemplateDelegate = template;
   [self.annotationGraphicsLayer addGraphic:myGraphic];
   [self.annotationGraphicsLayer dataChanged];
    
}

- (void)addAnnotations:(NSArray *)annotations
{
    [self.mapannotations addObjectsFromArray:annotations];
    for ( id<MKAnnotation> annotation in annotations)
    {
        [self addAnnotation:annotation];
    }
}

- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier
{
    // return the graphics view if the layer exists else return NULL
   if ( [self.idtoannotationDictionary objectForKey:identifier])
       return [self.idtoannotationDictionary objectForKey:identifier];
   else
        return NULL;
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
