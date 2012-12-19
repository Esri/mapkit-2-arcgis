//
//  LQSettingsViewController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Geoloqi.h"
#import "LQSetupAccountViewController.h"
#import "LQLoginViewController.h"

static NSString *const kLQUserHasSetEmailUserDefaultsKey = @"com.geoloqi.geonotes.userHasSetEmail";

@interface LQSettingsViewController : UIViewController <UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) IBOutlet UISwitch *locationTracking;
@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) LQSetupAccountViewController *setupAccountViewController;
@property (nonatomic, strong) LQLoginViewController *loginViewController;
@property (nonatomic, strong) IBOutlet UIViewController *privacyPolicyViewController;

@property (nonatomic, strong) IBOutlet UITableViewCell *logoCell;

- (IBAction)locationTrackingWasSwitched:(UISwitch *)sender;
- (IBAction)fileLoggingWasSwitched:(UISwitch *)sender;

- (void)setupAccountCellWasTapped;
- (void)anonymousBannerWasTapped;
- (void)loginCellWasTapped;

- (void)switchFrom:(UIViewController *)from to:(UIViewController *)to;

@end