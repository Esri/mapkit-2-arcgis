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
    
    NSURL* url = [NSURL URLWithString: @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"];
    AGSTiledMapServiceLayer* layer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: url];
    
    [self addMapLayer:layer withName:@"basemap"];
    
    
}


- (void)mapViewDidLoad:(AGSMapView *)mapView
{
    AGSPoint *wgs84Point = [[AGSPoint alloc] initWithX:self.savedRegion.center.longitude y:self.savedRegion.center.latitude spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326]];
    
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *webMercatorPoint = (AGSPoint*)[engine projectGeometry:wgs84Point toSpatialReference:self.spatialReference];
    
    //[self zoomToGeometry:webMercatorPoint withPadding:0 animated:NO];
    [self zoomToResolution:22000 withCenterPoint:webMercatorPoint animated:NO];
}
@end
