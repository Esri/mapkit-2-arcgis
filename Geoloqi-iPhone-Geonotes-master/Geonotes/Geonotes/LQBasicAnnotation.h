//
//  LQBasicAnnotation.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/9/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LQBasicAnnotation : NSObject <MKAnnotation> {
	NSString *title;
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;

@end
