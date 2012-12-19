//
//  LQNewGeonoteMapViewController.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/27/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LQGeonote.h"

@class LQNewGeonoteMapViewController;

@interface LQNewGeonoteMapViewController : UIViewController {
    BOOL pinUp;
}

@property (nonatomic, strong) LQGeonote *geonote;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *locateMeButton;

@property (nonatomic, strong) IBOutlet UIImageView *geonotePin;
@property (nonatomic, strong) IBOutlet UIImageView *geonotePinShadow;
@property (nonatomic, strong) IBOutlet UIImageView *geonoteTarget;

- (IBAction)pickButtonWasTapped:(UIBarButtonItem *)pickButton;

@end
