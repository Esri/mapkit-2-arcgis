//
//  LQNewGeonoteMapViewController.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/27/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQNewGeonoteMapViewController.h"
#import "MTLocation/MTLocateMeBarButtonItem.h"

#define MINIMUM_GEONOTE_RADIUS 150.0

#define PIN_Y_DELTA            30
#define PIN_SHADOW_X_DELTA     10
#define PIN_SHADOW_Y_DELTA     20
#define PIN_ANIMATION_DURATION 0.2

@interface LQNewGeonoteMapViewController ()

@end

@implementation LQNewGeonoteMapViewController

@synthesize mapView, toolbar, locateMeButton,
            geonotePin, geonotePinShadow, geonoteTarget;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [self pickButton];
        pinUp = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.locateMeButton = [[MTLocateMeBarButtonItem alloc] initWithMapView:mapView];
    [self.toolbar setItems:[NSArray arrayWithObjects:self.locateMeButton, nil] animated:NO];
    [self zoomMapToLocation:[[[CLLocationManager alloc] init] location]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

#pragma mark -

- (void)zoomMapToLocation:(CLLocation *)_location
{
    if (_location) {
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.05;
        span.longitudeDelta = 0.05;
        
        MKCoordinateRegion region;
        
        [mapView setCenterCoordinate:_location.coordinate animated:YES];
        
        region.center = _location.coordinate;
        region.span   = span;
        
        [mapView setRegion:region animated:YES];
    }
}

- (void)setGeonotePositionFromMapCenter
{
	MKCoordinateSpan currentSpan = mapView.region.span;
	// 111.0 km/degree of latitude * 1000 m/km * current delta * 20% of the half-screen width
	CGFloat desiredRadius = 111.0 * 1000 * currentSpan.latitudeDelta * 0.2;
    self.geonote.location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude
                                                       longitude:mapView.centerCoordinate.longitude];
	self.geonote.radius = desiredRadius < MINIMUM_GEONOTE_RADIUS ? MINIMUM_GEONOTE_RADIUS : desiredRadius;
}

#pragma mark -

- (UIBarButtonItem *)pickButton
{
    UIBarButtonItem *pick = [[UIBarButtonItem alloc] initWithTitle:@"Pick"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(pickButtonWasTapped:)];
    pick.tintColor = [UIColor blueColor];
    return pick;
}

#pragma mark -

- (IBAction)pickButtonWasTapped:(UIBarButtonItem *)pickButton
{
    [self setGeonotePositionFromMapCenter];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self liftGeonotePin];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self dropGeonotePin];
}

- (void)liftGeonotePin
{
    if (!pinUp) {
        self.geonoteTarget.hidden = NO;
        [UIView beginAnimations:@"" context:NULL];
        self.geonotePin.center = (CGPoint) {
            self.geonotePin.center.x,
            (self.geonotePin.center.y - PIN_Y_DELTA)
        };
        self.geonotePinShadow.center = (CGPoint) {
            (self.geonotePinShadow.center.x + PIN_SHADOW_X_DELTA),
            (self.geonotePinShadow.center.y - PIN_SHADOW_Y_DELTA)
        };
        [UIView setAnimationDuration:PIN_ANIMATION_DURATION];
        [UIView setAnimationDelay:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
        pinUp = YES;
    }
}

- (void)dropGeonotePin
{
    if (pinUp) {
        self.geonoteTarget.hidden = YES;
        [UIView beginAnimations:@"" context:NULL];
        self.geonotePin.center = (CGPoint) {
            self.geonotePin.center.x,
            (self.geonotePin.center.y + PIN_Y_DELTA)
        };
        self.geonotePinShadow.center = (CGPoint) {
            (self.geonotePinShadow.center.x - PIN_SHADOW_X_DELTA),
            (self.geonotePinShadow.center.y + PIN_SHADOW_Y_DELTA)
        };
        [UIView setAnimationDuration:PIN_ANIMATION_DURATION];
        [UIView setAnimationDelay:UIViewAnimationCurveEaseIn];
        [UIView commitAnimations];
        
        pinUp = NO;
    }
}

@end
