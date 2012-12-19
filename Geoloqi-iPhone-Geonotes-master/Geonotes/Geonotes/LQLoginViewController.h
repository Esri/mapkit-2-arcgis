//
//  LQLoginViewController.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/19/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LQButtonTableViewCell.h"

@class LQSettingsViewController;

@interface LQLoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    
    LQButtonTableViewCell *buttonTableViewCell;
}

@property (nonatomic, strong) LQSettingsViewController *settingsViewController;
@property (nonatomic, strong) IBOutlet UITableView *settingsTableView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextField *emailAddressField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSettingsTableView:(UITableView *)settingsTableView andSettingsViewController:(LQSettingsViewController *)settingsViewController;

- (void)resetFields;

@end
