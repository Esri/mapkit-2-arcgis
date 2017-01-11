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
