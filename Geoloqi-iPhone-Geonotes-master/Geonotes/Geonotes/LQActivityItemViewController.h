//
//  LQActivityItemViewController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/9/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LQActivityItemViewController : UIViewController <MKMapViewDelegate> {
    NSString *sourceURL;
}

@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIView *detailContainerView;
@property IBOutlet UITextView *titleTextView;
@property IBOutlet UILabel *linkLabel;
@property IBOutlet UILabel *urlLabel;
@property IBOutlet UITextView *bodyTextView;
@property IBOutlet MKMapView *mapView;
@property IBOutlet UIImageView *imageView;
@property IBOutlet UIView *detailView;

- (void)loadStory:(NSDictionary *)storyData;

- (void)setMapLocation:(CLLocationCoordinate2D)center radius:(CGFloat)radius;
- (IBAction)urlLabelWasTapped:(UILabel *)urlLabel;

@end
