//
//  ViewController.m
//  SimpleMap
//
//  Created by Al Pascual on 10/10/12.
//  Copyright (c) 2012 Esri. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    	self.mapView.mapType = MKMapTypeStandard;
    
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    
	region.center.latitude = 40.105085;
	region.center.longitude = -99.005237;
	region.span.latitudeDelta = 36;
	region.span.longitudeDelta = 36;
    
	[self.mapView setRegion:region];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
