//
//  MKOverlayView.m
//  Breadcrumb
//
//  Created by Al Pascual on 10/17/12.
//
//

#import "MKOverlayView.h"

@implementation MKOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Convert screen points relative to this view to absolute MKMapPoints
- (CGPoint)pointForMapPoint:(MKMapPoint)mapPoint
{
#warning not implemented
    CGPoint point;
    
    return point;
}
- (MKMapPoint)mapPointForPoint:(CGPoint)point
{
    #warning not implemented
    MKMapPoint mapPoint;
    
    return mapPoint;
}

- (CGRect)rectForMapRect:(MKMapRect)mapRect
{
    #warning not implemented
    CGRect rect;
    
    return rect;
}
- (MKMapRect)mapRectForRect:(CGRect)rect
{
    #warning not implemented
    MKMapRect mapRec;
    return mapRec;
}

// Return YES if the view is currently ready to draw in the specified rect.
// Return NO if the view will not draw in the specified rect or if the
// data necessary to draw in the specified rect is not available.  In the
// case where the view may want to draw in the specified rect but the data is
// not available, use setNeedsDisplayInMapRect:zoomLevel: to signal when the
// data does become available.
- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale
{
    #warning not implemented
    return NO;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    #warning not implemented
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
{
    #warning not implemented
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
                       zoomScale:(MKZoomScale)zoomScale
{
    #warning not implemented
}

@end
