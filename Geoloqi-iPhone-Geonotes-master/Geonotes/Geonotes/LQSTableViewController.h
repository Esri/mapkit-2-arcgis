//
//  LQSTableViewController.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 8/3/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "STableViewController.h"

@interface LQSTableViewController : STableViewController {
    UIButton *anonymousBanner;
    UIView *overlayView;
    UILabel *overlayTitleLabel;
    UILabel *overlayTextLabel;
}

- (void)addOverlayWithTitle:(NSString *)title andText:(NSString *)text;
- (void)removeOverlay;

- (void)addAnonymousBanner;
- (void)removeAnonymousBanner;

@end
