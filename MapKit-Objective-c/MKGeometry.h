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

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "MKFoundation.h"


typedef struct {
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} MKCoordinateSpan;

typedef struct {
	CLLocationCoordinate2D center;
	MKCoordinateSpan span;
} MKCoordinateRegion;


NS_INLINE MKCoordinateSpan MKCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
{
    MKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

NS_INLINE MKCoordinateRegion MKCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, MKCoordinateSpan span)
{
	MKCoordinateRegion region;
	region.center = centerCoordinate;
    region.span = span;
	return region;
}

MKCoordinateRegion MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);

// Projected geometry is available in iPhone OS 4.0 and later
#if (__IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED)

// An MKMapPoint is a coordinate that has been projected for use on the
// two-dimensional map.  An MKMapPoint always refers to a place in the world
// and can be converted to a CLLocationCoordinate2D and back.
typedef struct {
    double x;
    double y;
} MKMapPoint;

typedef struct {
    double width;
    double height;
} MKMapSize;

typedef struct {
    MKMapPoint origin;
    MKMapSize size;
} MKMapRect;

// MKZoomScale provides a conversion factor between MKMapPoints and screen points.
// When MKZoomScale = 1, 1 screen point = 1 MKMapPoint.  When MKZoomScale is
// 0.5, 1 screen point = 2 MKMapPoints.
typedef CGFloat MKZoomScale;
#endif

const MKMapSize MKMapSizeWorld NS_AVAILABLE(NA, 4_0);
// The rect that contains every map point in the world.
const MKMapRect MKMapRectWorld NS_AVAILABLE(NA, 4_0);

// Conversion between unprojected and projected coordinates
MKMapPoint MKMapPointForCoordinate(CLLocationCoordinate2D coordinate);

CLLocationCoordinate2D MKCoordinateForMapPoint(MKMapPoint mapPoint);

// Conversion between distances and projected coordinates
CLLocationDistance MKMetersPerMapPointAtLatitude(CLLocationDegrees latitude) NS_AVAILABLE(NA, 4_0);
double MKMapPointsPerMeterAtLatitude(CLLocationDegrees latitude) NS_AVAILABLE(NA, 4_0);

CLLocationDistance MKMetersBetweenMapPoints(MKMapPoint a, MKMapPoint b) NS_AVAILABLE(NA, 4_0);

const MKMapRect MKMapRectNull NS_AVAILABLE(NA, 4_0);

#if (__IPHONE_4_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED)

// Geometric operations on MKMapPoint/Size/Rect.  See CGGeometry.h for
// information on the CGFloat versions of these functions.
NS_INLINE MKMapPoint MKMapPointMake(double x, double y) {
    return (MKMapPoint){x, y};
}
NS_INLINE MKMapSize MKMapSizeMake(double width, double height) {
    return (MKMapSize){width, height};
}
NS_INLINE MKMapRect MKMapRectMake(double x, double y, double width, double height) {
    return (MKMapRect){ MKMapPointMake(x, y), MKMapSizeMake(width, height) };
}
NS_INLINE double MKMapRectGetMinX(MKMapRect rect) {
    return rect.origin.x;
}
NS_INLINE double MKMapRectGetMinY(MKMapRect rect) {
    return rect.origin.y;
}
NS_INLINE double MKMapRectGetMidX(MKMapRect rect) {
    return rect.origin.x + rect.size.width / 2.0;
}
NS_INLINE double MKMapRectGetMidY(MKMapRect rect) {
    return rect.origin.y + rect.size.height / 2.0;
}
NS_INLINE double MKMapRectGetMaxX(MKMapRect rect) {
    return rect.origin.x + rect.size.width;
}
NS_INLINE double MKMapRectGetMaxY(MKMapRect rect) {
    return rect.origin.y + rect.size.height;
}
NS_INLINE double MKMapRectGetWidth(MKMapRect rect) {
    return rect.size.width;
}
NS_INLINE double MKMapRectGetHeight(MKMapRect rect) {
    return rect.size.height;
}
NS_INLINE BOOL MKMapPointEqualToPoint(MKMapPoint point1, MKMapPoint point2) {
    return point1.x == point2.x && point1.y == point2.y;
}
NS_INLINE BOOL MKMapSizeEqualToSize(MKMapSize size1, MKMapSize size2) {
    return size1.width == size2.width && size1.height == size2.height;
}
NS_INLINE BOOL MKMapRectEqualToRect(MKMapRect rect1, MKMapRect rect2) {
    return
    MKMapPointEqualToPoint(rect1.origin, rect2.origin) &&
    MKMapSizeEqualToSize(rect1.size, rect2.size);
}

NS_INLINE BOOL MKMapRectIsNull(MKMapRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y);
}
NS_INLINE BOOL MKMapRectIsEmpty(MKMapRect rect) {
    return MKMapRectIsNull(rect) || (rect.size.width == 0.0 && rect.size.height == 0.0);
}

NS_INLINE NSString *MKStringFromMapPoint(MKMapPoint point) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", point.x, point.y];
}

NS_INLINE NSString *MKStringFromMapSize(MKMapSize size) {
    return [NSString stringWithFormat:@"{%.1f, %.1f}", size.width, size.height];
}

NS_INLINE NSString *MKStringFromMapRect(MKMapRect rect) {
    return [NSString stringWithFormat:@"{%@, %@}", MKStringFromMapPoint(rect.origin), MKStringFromMapSize(rect.size)];
}
#endif

MK_EXTERN MKMapRect MKMapRectUnion(MKMapRect rect1, MKMapRect rect2) NS_AVAILABLE(NA, 4_0);
MKMapRect MKMapRectIntersection(MKMapRect rect1, MKMapRect rect2) NS_AVAILABLE(NA, 4_0);
MKMapRect MKMapRectInset(MKMapRect rect, double dx, double dy) NS_AVAILABLE(NA, 4_0);
MK_EXTERN MKMapRect MKMapRectOffset(MKMapRect rect, double dx, double dy) NS_AVAILABLE(NA, 4_0);
MK_EXTERN void MKMapRectDivide(MKMapRect rect, MKMapRect *slice, MKMapRect *remainder, double amount, CGRectEdge edge) NS_AVAILABLE(NA, 4_0);

MK_EXTERN BOOL MKMapRectContainsPoint(MKMapRect rect, MKMapPoint point) NS_AVAILABLE(NA, 4_0);
MK_EXTERN BOOL MKMapRectContainsRect(MKMapRect rect1, MKMapRect rect2) NS_AVAILABLE(NA, 4_0);
BOOL MKMapRectIntersectsRect(MKMapRect rect1, MKMapRect rect2) NS_AVAILABLE(NA, 4_0);

MK_EXTERN MKCoordinateRegion MKCoordinateRegionForMapRect(MKMapRect rect) NS_AVAILABLE(NA, 4_0);

MK_EXTERN BOOL MKMapRectSpans180thMeridian(MKMapRect rect) NS_AVAILABLE(NA, 4_0);
// For map rects that span the 180th meridian, this returns the portion of the rect
// that lies outside of the world rect wrapped around to the other side of the
// world.  The portion of the rect that lies inside the world rect can be
// determined with MKMapRectIntersection(rect, MKMapRectWorld).
MK_EXTERN MKMapRect MKMapRectRemainder(MKMapRect rect) NS_AVAILABLE(NA, 4_0);


@interface NSValue (NSValueMapKitGeometryExtensions)

+ (NSValue *)valueWithMKCoordinate:(CLLocationCoordinate2D)coordinate;
+ (NSValue *)valueWithMKCoordinateSpan:(MKCoordinateSpan)span;

- (CLLocationCoordinate2D)MKCoordinateValue;
- (MKCoordinateSpan)MKCoordinateSpanValue;

@end
