//
//  LQLoginViewController.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/19/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQLoginViewController.h"
#import "LQSettingsViewController.h"
#import "LQAppDelegate.h"

@interface LQLoginViewController ()

@end

@implementation LQLoginViewController

@synthesize settingsViewController, tableView, settingsTableView,
            emailAddressField, passwordField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSettingsTableView:(UITableView *)_settingsTableView andSettingsViewController:(LQSettingsViewController *)_settingsViewController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.settingsTableView = _settingsTableView;
        self.settingsViewController = _settingsViewController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark -

- (void)resetFields
{
    self.emailAddressField.text = nil;
    self.passwordField.text = nil;
    [self.emailAddressField becomeFirstResponder];
    [buttonTableViewCell setButtonState:NO];
}

- (BOOL)isComplete
{
    return emailAddressField.text.length > 0 && passwordField.text.length > 0;
}

- (IBAction)cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)loginToAccount
{
    [self toggleFormStatus:NO];
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [LQSession requestSessionWithUsername:emailAddressField.text
                                 password:passwordField.text
                               completion:^(LQSession *session, NSError *error) {
                                   if (error) {
                                       [self toggleFormStatus:YES];
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                       message:[[error userInfo] objectForKey:@"error_description"]
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"Ok"
                                                                             otherButtonTitles:nil];
                                       [alert show];
                                   } else {
                                       // Pass the new session to the tracker class so location updates get sent from the new account
                                       [[LQTracker sharedTracker] setSession:session];
                                       [self updateDisplayName:^() {
                                           [self.settingsTableView reloadData];
                                           [self toggleFormStatus:YES];
                                           [self.navigationController popViewControllerAnimated:YES];
                                           LQAppDelegate *appDelegate = (LQAppDelegate *)[[UIApplication sharedApplication] delegate];
                                           [appDelegate refreshAllSubTableViews];
                                           [appDelegate removeAnonymousBanners];
                                           [LQAppDelegate registerForPushNotificationsIfNotYetRegistered];
                                       }];
                                   }
                               }];
}

- (void)toggleFormStatus:(BOOL)status
{
    if (status)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Logging In"];
    self.emailAddressField.enabled = status;
    self.passwordField.enabled = status;
    [buttonTableViewCell setButtonState:status];
}

- (IBAction)textFieldDidEditChanged:(UITextField *)textField
{
    [buttonTableViewCell setButtonState:[self isComplete]];
}

- (void)updateDisplayName:(void (^)())block
{
    LQSession *session = [LQSession savedSession];
    NSURLRequest *req = [session requestWithMethod:@"GET" path:@"/account/profile" payload:nil];
    [session runAPIRequest:req completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[responseDictionary objectForKey:@"display_name"] forKey:kLQDisplayNameUserDefaultsKey];
        [defaults synchronize];
        block();
    }];
}

#pragma mark - table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)inTableView titleForHeaderInSection:(NSInteger)section;
{
	return (section == 0) ? NSLocalizedString(@"Login to your Geoloqi account", nil) : nil;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
{
    int rows;
    switch (section) {
        case 0:
            rows = 2;
            break;
        case 1:
            rows = 1;
            break;
        case 2:
            rows = 1;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        if (indexPath.row == 0) {
            cell.accessoryView = emailAddressField;
            cell.detailTextLabel.text = NSLocalizedString(@"Email", nil);
        } else if (indexPath.row == 1) {
            cell.accessoryView = passwordField;
            cell.detailTextLabel.text = NSLocalizedString(@"Password", nil);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1) {
        buttonTableViewCell = [LQButtonTableViewCell buttonTableViewCellWithTitle:@"Login"
                                                                            owner:self
                                                                          enabled:[self isComplete]
                                                                           target:self
                                                                         selector:@selector(loginToAccount)];
        cell = buttonTableViewCell;
    } else if (indexPath.section == 2) {
        NSString *cellId = @"setup";
        cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.textLabel.text = NSLocalizedString(@"Tap here to setup a new account", nil);
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
    }
	return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [_tableView cellForRowAtIndexPath:indexPath].selected = NO;
        [settingsViewController switchFrom:self to:settingsViewController.setupAccountViewController];
    }
}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    if (textField == emailAddressField) {
        [passwordField becomeFirstResponder];
    } else if (textField == passwordField) {
        [textField resignFirstResponder];
    }
	return YES;
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [emailAddressField becomeFirstResponder];
}

@end
