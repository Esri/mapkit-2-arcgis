//
//  MKGeometry.m
//  Breadcrumb
//
//  Created by Al Pascual on 10/18/12.
//
//

#import "MKGeometry.h"
#import <ArcGIS/ArcGIS.h>

//@implementation MKGeometry

CLLocationCoordinate2D MKCoordinateForMapPoint(MKMapPoint mapPoint)
{
    //   #warning convert to AGSPoint
    CLLocationCoordinate2D location;
    location.latitude = mapPoint.x;
    location.longitude = mapPoint.y;
    
    return location;
}

MKCoordinateRegion MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters)
{
#warning implement this methond
    MKCoordinateRegion region;
    return region;
}

MKMapPoint MKMapPointForCoordinate(CLLocationCoordinate2D coordinate)
{    
    return (MKMapPoint) { coordinate.latitude, coordinate.longitude };
}

BOOL MKMapRectIntersectsRect(MKMapRect rect1, MKMapRect rect2)
{
    AGSPoint *point1 = [[AGSPoint alloc] initWithX:rect1.origin.x y:rect1.origin.y spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    AGSPoint *point2 = [[AGSPoint alloc] initWithX:rect2.origin.x y:rect2.origin.y spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    AGSGeometryEngine *engine = [AGSGeometryEngine defaultGeometryEngine];
    
    return [engine geometry:point1.envelope intersectsGeometry:point2.envelope];
}

MKMapRect MKMapRectInset(MKMapRect rect, double dx, double dy)
{
    MKMapRect newRect;
    newRect.size = rect.size;
    newRect.origin.x = rect.origin.x - dx;
    newRect.origin.y = rect.origin.y - dy;
    
    return newRect;
}

MKMapRect MKMapRectIntersection(MKMapRect rect1, MKMapRect rect2)
{
#warning implement this methond
    
    MKMapRect newRect;
    return newRect;
}

CLLocationDistance MKMetersBetweenMapPoints(MKMapPoint a, MKMapPoint b)
{
#warning implement this methond
    CLLocationDistance distance;
    return distance;
}


//@end
