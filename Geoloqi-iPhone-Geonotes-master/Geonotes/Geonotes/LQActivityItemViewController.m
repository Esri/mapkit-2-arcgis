//
//  LQActivityItemViewController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/9/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQActivityItemViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "LQBasicAnnotation.h"

#define BORDER_COLOR [[UIColor colorWithHue:0 saturation:0 brightness:0.67 alpha:1.0] CGColor]
#define BORDER_WIDTH 1.0
#define BODY_TEXT_DELTA_MIN -10.0

@interface LQActivityItemViewController () {
    NSDictionary *storyData;
}
@end

@implementation LQActivityItemViewController

@synthesize scrollView, detailContainerView, titleTextView, linkLabel, urlLabel, mapView, bodyTextView, imageView, detailView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // if there's no place, there's no map, so start the text views at the top
    CGFloat originY = 0.0;

    if([storyData objectForKey:@"location"]) {
        
        // add a border to the top of the map
        CALayer *topMapBorder = [CALayer layer];
        topMapBorder.frame = CGRectMake(0.0, 0.0, self.scrollView.frame.size.width, BORDER_WIDTH);
        topMapBorder.backgroundColor = BORDER_COLOR;
        [self.scrollView.layer addSublayer:topMapBorder];
        
        // add a border to the bottom of the map
        CALayer *bottomMapBorder = [CALayer layer];
        bottomMapBorder.frame = CGRectMake(0.0, 130.0, self.scrollView.frame.size.width, BORDER_WIDTH);
        bottomMapBorder.backgroundColor = BORDER_COLOR;
        [self.scrollView.layer addSublayer:bottomMapBorder];
        
        // Center the map on the location and add a marker
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake([[[storyData objectForKey:@"location"] objectForKey:@"latitude"] floatValue], [[[storyData objectForKey:@"location"] objectForKey:@"longitude"] floatValue]);
        [self setMapLocation:center radius:[[[storyData objectForKey:@"location"] objectForKey:@"radius"] floatValue]];

        [mapView addAnnotation:[[LQBasicAnnotation alloc] initWithTitle:[[storyData objectForKey:@"location"] objectForKey:@"displayName"] andCoordinate:center]];

        // otherwise, push the text views down below the map
        originY = 130.0;
    } else {
        [self.mapView removeFromSuperview];
    }
    
    // add all the text
    self.titleTextView.text = [storyData objectForKey:@"title"];
    self.bodyTextView.text = [[storyData objectForKey:@"object"] objectForKey:@"summary"];
    sourceURL = [[storyData objectForKey:@"object"] objectForKey:@"sourceURL"];
    if (sourceURL && ![sourceURL isEqualToString:@""]) {
        self.urlLabel.text = sourceURL;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(urlLabelWasTapped:)];
        urlLabel.userInteractionEnabled = YES;
        [urlLabel addGestureRecognizer:tap];
    } else {
        [self.linkLabel removeFromSuperview];
        [self.urlLabel removeFromSuperview];
    }

    // add image
    NSString *imageURL;
    if(![[[[storyData objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"url"] isEqualToString:@""]) {
        imageURL = [[[storyData objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"url"];
    } else if(![[[[storyData objectForKey:@"generator"] objectForKey:@"image"] objectForKey:@"url"] isEqualToString:@""]) {
        imageURL = [[[storyData objectForKey:@"generator"] objectForKey:@"image"] objectForKey:@"url"];
    }
    if(![imageURL isEqualToString:@""]) {
        [self.imageView setImageWithURL:[NSURL URLWithString:imageURL]];
    }
    
    // make the nice rounded box behind the text
    self.detailContainerView.layer.cornerRadius = 10.0;
    self.detailContainerView.layer.masksToBounds = YES;
    self.detailContainerView.layer.borderWidth = BORDER_WIDTH;
    self.detailContainerView.layer.borderColor = BORDER_COLOR;

    // add the nice rounded box
    [self.scrollView addSubview:detailView];
    
    // can only get contentSize after view has been added
    // so now we can go through each text view and figure out the delta between its view frame height
    // and the contentSize height (which should be enough to show all the text).
    // for each text view, we'll add the delta to this:
    CGFloat yToAddToFrameHeight = 0.0;
    
    // these two are reused for each text view
    CGFloat delta;
    CGRect frame;
    
    // frames of views have immutable properties, but the frame property itself is assignable...
    // so, we grab a copy, set the heights, and reassign it back to the view.
    
    // figure out the height needed to add to show the title text properly (TODO: can be negative?)
    frame = self.titleTextView.frame;
    delta = self.titleTextView.contentSize.height - frame.size.height;
    yToAddToFrameHeight += delta;
    frame.size.height += delta;
    self.titleTextView.frame = frame;

    // figure out the height needed to add to show the body text properly
    frame = self.bodyTextView.frame;
    frame.origin.y += yToAddToFrameHeight;
    delta = self.bodyTextView.contentSize.height - frame.size.height;
    
    // in this case, do not let delta drop below BODY_TEXT_DELTA_MIN
    if (delta < BODY_TEXT_DELTA_MIN) { delta += (fabs(delta - BODY_TEXT_DELTA_MIN)); }
    yToAddToFrameHeight += delta;
    frame.size.height += delta;
    self.bodyTextView.frame = frame;
    
    // now, add the height we need to the container view's frame
    frame = self.detailContainerView.frame;
    frame.size.height += yToAddToFrameHeight;
    self.detailContainerView.frame = frame;
    
    // if we have a link, push it down below the text container view box
    if (sourceURL && ![sourceURL isEqualToString:@""]) {
        frame = self.linkLabel.frame;
        frame.origin.y += yToAddToFrameHeight;
        self.linkLabel.frame = frame;
        
        frame = self.urlLabel.frame;
        frame.origin.y += yToAddToFrameHeight;
        self.urlLabel.frame = frame;
    }
    
    // now, set the detail view's frame to the whole size, so that it will scroll properly
    detailView.frame = CGRectMake(0.0, originY, self.scrollView.frame.size.width, (self.scrollView.frame.size.height + yToAddToFrameHeight));
    // same with contentSize of the scroll view
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.detailView.frame.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)loadStory:(NSDictionary *)_storyData {
    storyData = _storyData;
    NSLog(@"storyData: %@", storyData);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setMapLocation:(CLLocationCoordinate2D)center radius:(CGFloat)radius
{
    /*MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center, radius, radius);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
     */
}

- (IBAction)urlLabelWasTapped:(UILabel *)urlLabel
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sourceURL]];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *viewId = @"MKPinAnnotationView";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView*)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    annotationView.image = [UIImage imageNamed:@"map-marker.png"];
    return annotationView;
}

@end
