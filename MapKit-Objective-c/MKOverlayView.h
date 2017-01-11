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

#import <UIKit/UIKit.h>
#import "MKOverlay.h"
#import <ArcGIS/ArcGIS.h>



@protocol MKOverlayViewDelegate <NSObject>

- (CGPoint)pointForMapPoint:(MKMapPoint)mapPoint;
- (MKMapPoint)mapPointForPoint:(CGPoint)point;

- (CGRect)rectForMapRect:(MKMapRect)mapRect;
- (MKMapRect)mapRectForRect:(CGRect)rect;

@end

MK_CLASS_AVAILABLE(NA, 4_0)
@interface MKOverlayView : UIView {
    
    @package
    id <MKOverlay> _overlay;
    MKMapRect _boundingMapRect;
    MKZoomScale _mapZoomScale;
    id _geometryDelegate;
    id _canDrawCache;
    
    CFTimeInterval _lastTile;
    CFRunLoopTimerRef _scheduledScaleTimer;
    
    struct {
        unsigned int keepAlive:1;
        unsigned int levelCrossFade:1;
        unsigned int drawingDisabled:1;
        unsigned int usesTiledLayer:1;
    } _flags;
}


@property ( nonatomic, strong) id < MKOverlayViewDelegate> delegate;
- (id)initWithOverlay:(id <MKOverlay>)overlay;

@property (nonatomic, readonly) id <MKOverlay> overlay;

// Convert screen points relative to this view to absolute MKMapPoints
- (CGPoint)pointForMapPoint:(MKMapPoint)mapPoint;
- (MKMapPoint)mapPointForPoint:(CGPoint)point;

- (CGRect)rectForMapRect:(MKMapRect)mapRect;
- (MKMapRect)mapRectForRect:(CGRect)rect;

// Return YES if the view is currently ready to draw in the specified rect.
// Return NO if the view will not draw in the specified rect or if the
// data necessary to draw in the specified rect is not available.  In the
// case where the view may want to draw in the specified rect but the data is
// not available, use setNeedsDisplayInMapRect:zoomLevel: to signal when the
// data does become available.
- (BOOL)canDrawMapRect:(MKMapRect)mapRect
             zoomScale:(MKZoomScale)zoomScale;

- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)context;

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect;

- (void)setNeedsDisplayInMapRect:(MKMapRect)mapRect
                       zoomScale:(MKZoomScale)zoomScale;

@end

// Road widths are typically not drawn to scale on the map.  This function
// returns the approximate width in points of roads at the specified zoomScale.
// The result of this function is suitable for use with CGContextSetLineWidth.
CGFloat MKRoadWidthAtZoomScale(MKZoomScale zoomScale) NS_AVAILABLE(NA, 4_0);
