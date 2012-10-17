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
    CGPoint point;
    
    return point;
}
- (MKMapPoint)mapPointForPoint:(CGPoint)point
{
    MKMapPoint mapPoint;
    
    return mapPoint;
}

- (CGRect)rectForMapRect:(MKMapRect)mapRect
{
    CGRect rect;
    
    return rect;
}
- (MKMapRect)mapRectForRect:(CGRect)rect
{
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
    
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{
    
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
{
    
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
                       zoomScale:(MKZoomScale)zoomScale
{
    
}

@end
