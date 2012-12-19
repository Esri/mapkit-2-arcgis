//
//  MKGeometry.m
//  Breadcrumb
//
//  Created by Al Pascual on 10/18/12.
//
//

#import "MKGeometry.h"

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


//@end
