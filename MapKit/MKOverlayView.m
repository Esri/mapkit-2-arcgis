//
//  MKOverlayView.m
//  Breadcrumb
//
//  Created by Al Pascual on 10/17/12.
//
//

#import "MKOverlayView.h"

@implementation MKOverlayView


- (id)initWithOverlay:(id <MKOverlay>)overlay;
{
    self = [super init];
    if (self) {
        // Initialization code
        _overlay = overlay;
    }
    return self;
}

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
//#warning not implemented
    return [self.delegate pointForMapPoint:mapPoint];
}
- (MKMapPoint)mapPointForPoint:(CGPoint)point
{
    
    return [self.delegate mapPointForPoint:point];
}

- (CGRect)rectForMapRect:(MKMapRect)mapRect
{
    return [self.delegate rectForMapRect:mapRect];
}
- (MKMapRect)mapRectForRect:(CGRect)rect
{
    return [self.delegate mapRectForRect:rect];
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
    
    return NO;
}

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context
{

    CGRect boundaryRect =[self rectForMapRect:mapRect];
    CGContextFillRect(context, boundaryRect);
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
{
    //#warning not implemented
}

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
                       zoomScale:(MKZoomScale)zoomScale
{
   // #warning not implemented
}

CGFloat MKRoadWidthAtZoomScale(MKZoomScale zoomScale)
{
#warning implement this, remove this hack
    CGFloat roadWidth = zoomScale;
    return roadWidth;
}

@end
