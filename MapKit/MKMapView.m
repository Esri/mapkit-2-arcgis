//
//  MKMapView.m
//  SimpleMap
//
//  Created by Al Pascual on 10/15/12.
//  Copyright (c) 2012 Esri. All rights reserved.
//

#import "MKMapView.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@implementation MKMapView

- (void)setRegion:(MKCoordinateRegion)region
{
    self.layerDelegate = self;
    self.savedRegion = region;
    self.wgs84Point = [[AGSPoint alloc] initWithX:self.savedRegion.center.longitude y:self.savedRegion.center.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];

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
            url = [NSURL URLWithString: @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
            break;
    }

    if (! [self mapLayerForName:@"basemap"])
    {
        AGSTiledMapServiceLayer* layer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: url];
        [self insertMapLayer:layer withName:@"basemap" atIndex:0];
    }
}

- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)bAnimated
{
    shouldAnimate = bAnimated;
    [self setRegion:region];
}

-(void) setVisibleMapRect:(MKMapRect)visibleMapRect
{
   self.wgs84Point = [[AGSPoint alloc] initWithX:visibleMapRect.origin.x y:visibleMapRect.origin.y spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
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
    if (! [self mapLayerForName:@"basemap"])
    {
        AGSTiledMapServiceLayer* layer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: url];
        [self addMapLayer:layer withName:@"basemap"];
    }
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated
{
    AGSPoint *centerPoint = [[AGSPoint alloc] initWithX:coordinate.longitude y:coordinate.latitude spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    [self centerAtPoint:centerPoint animated:animated];
}

- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    self.idtoannotationDictionary = [[NSMutableDictionary alloc] init];
    self.annotationGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    
    if ( ![self mapLayerForName:@"Annotation Graphics Layer"])
        [self addMapLayer:self.annotationGraphicsLayer withName:@"Annotation Graphics Layer"];
    
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *webMercatorPoint = (AGSPoint*)[engine projectGeometry:self.wgs84Point toSpatialReference:self.spatialReference];
    
    [self zoomIn:YES];
    [self zoomToResolution:30 withCenterPoint:webMercatorPoint animated:shouldAnimate];
   // [self centerAtPoint:webMercatorPoint animated:shouldAnimate];

    if ( self.showsUserLocation)
    {
        [self.locationDisplay startDataSource];
        [self registerAsObserver];
    }
    
    
    // Initialize the Annotations
    self.mapannotations = [[NSMutableArray  alloc] init];
    
    // Create the watermark image view...
	// you could also use IB to place an image view, then create an IBOutlet in the header and hook it up
	// that way.
    
    CGFloat bottomY = 350;
    if ( IS_IPHONE5 == YES)
        bottomY = 440;
    
	UIImageView *watermarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, bottomY, 43, 25)];
	
	// this will load the @2x version automatically if on iPhone4
	watermarkIV.image = [UIImage imageNamed:@"esriLogo.png"];
	watermarkIV.userInteractionEnabled = NO;
    
	[mapView.superview addSubview:watermarkIV];
    
}
//- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view
//{
//    return [self convertCoordinate:coordinate toPointToView:view];
//}

- (void)registerAsObserver {
    [ self.locationDisplay addObserver:self
                        forKeyPath:@"location"
                           options:(NSKeyValueObservingOptionNew)
                           context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"location"])
    {
        CLLocation* loc = [[CLLocation alloc] initWithLatitude:self.locationDisplay.location.point.y longitude:self.locationDisplay.location.point.x];
        
        self.userLocation = [[MKUserLocation alloc] init];
        self.userLocation.location = loc;

        // self.userLocation.location.point = self.locationDisplay.location.point;
        [self.delegate mapView:self didUpdateUserLocation:self.userLocation];
    }
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
    
   AGSPoint* newMarkerPoint = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:markerPoint toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:102100]];
   AGSGraphic* myGraphic = [AGSGraphic graphicWithGeometry:newMarkerPoint symbol:pictureMarkerSymbol attributes:nil infoTemplateDelegate:nil];
    
    AnnotationTemplate* template = [[AnnotationTemplate alloc] init];
    if ( [annotation respondsToSelector:@selector(title)])
        template.title = annotation.title;
    if ( [annotation respondsToSelector:@selector(subtitle)])
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
   [self.annotationGraphicsLayer refresh];
    
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


#pragma mark - MapOverlay functions

-(void) addOverlay:(id<MKOverlay>)overlay
{
    /*MKOverlayView* overlayView = [self.delegate mapView:self viewForOverlay:overlay];
    // TO FIX adding a View to the Map does not work in 10.1.1
    [self addSubview:overlayView];
     */
    
    CLLocationCoordinate2D coordinates = [overlay coordinate];
    
    AGSPoint* markerPoint = [AGSPoint pointWithX:coordinates.longitude y:coordinates.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
    AGSPoint* newMarkerPoint = [[AGSGeometryEngine defaultGeometryEngine] projectGeometry:markerPoint toSpatialReference:[AGSSpatialReference spatialReferenceWithWKID:102100]];
    
    if ( self.annotationGraphicsLayer == nil ) {
        self.annotationGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
        [self addMapLayer:self.annotationGraphicsLayer withName:@"Annotation Graphics Layer"];
    }
    
    AGSSimpleMarkerSymbol *symbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
       
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:newMarkerPoint symbol:symbol attributes:nil infoTemplateDelegate:nil];
    [self.annotationGraphicsLayer addGraphic:graphic];
    
}

- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated
{
#warning not implemented
}


#pragma mark - OverlayViewDelegate
-(CGPoint) pointForMapPoint:(MKMapPoint)mapPoint
{
    AGSPoint* agsPoint = [AGSPoint pointWithX:mapPoint.x y:mapPoint.y spatialReference:self.spatialReference];
    return  [self toScreenPoint:agsPoint];
}

-(MKMapPoint) mapPointForPoint:(CGPoint)point
{
    AGSPoint* agsPoint = [self toMapPoint:point];
    MKMapPoint mapPoint = MKMapPointMake(agsPoint.x, agsPoint.y);
    return mapPoint;
}

-(CGRect)rectForMapRect:(MKMapRect)mapRect
{
    AGSEnvelope* envelope = [AGSEnvelope envelopeWithXmin:MKMapRectGetMinX(mapRect) ymin:MKMapRectGetMinY(mapRect) xmax:MKMapRectGetMaxX(mapRect) ymax:MKMapRectGetMaxY(mapRect) spatialReference:self.spatialReference];
    return  [self toScreenRect:envelope];
}

-(MKMapRect) mapRectForRect:(CGRect)rect
{
    AGSEnvelope* envelope = [self toMapEnvelope:rect];
    MKMapRect mapRect = MKMapRectMake(envelope.xmin, envelope.ymin, envelope.width, envelope.height);
    return mapRect;
}

@end
