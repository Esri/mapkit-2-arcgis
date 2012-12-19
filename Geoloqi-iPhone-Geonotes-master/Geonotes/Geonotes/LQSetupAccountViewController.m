//
//  LQSetupAccountViewController.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/19/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQSetupAccountViewController.h"
#import "LQSettingsViewController.h"

@interface LQSetupAccountViewController ()

@end

@implementation LQSetupAccountViewController

@synthesize settingsViewController,
            tableView = _tableView,
            emailAddressField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSettingsViewController:(LQSettingsViewController *)_settingsViewController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void)resetField
{
    self.emailAddressField.text = nil;
    [buttonTableViewCell setButtonState:NO];
}

- (BOOL)isComplete;
{
	return emailAddressField.text.length > 0;
}

- (IBAction)cancel
{
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

- (IBAction)setupAccount
{
    [self.emailAddressField resignFirstResponder];
    [self toggleFormStatus:NO];
    LQSession *session = [LQSession savedSession];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:emailAddressField.text, @"email", nil];
    NSURLRequest *r = [session requestWithMethod:@"POST" path:@"/account/anonymous_set_email" payload:params];
    [session runAPIRequest:r
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    [self toggleFormStatus:YES];
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:@"NSLocalizedDescription"]
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                    NSString *res = (NSString *)[responseDictionary objectForKey:@"response"];
                    if (res && [res isEqualToString:@"ok"]) {
                        
                        // set flag that the user has gone through the setup account process at least once
                        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
                        [d setBool:YES forKey:kLQUserHasSetEmailUserDefaultsKey];
                        [d synchronize];
                        
                        // this is to append the message to the account section footer about checking email
                        [self.settingsViewController.tableView reloadData];
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
    ];
}

- (void)toggleFormStatus:(BOOL)status
{
    if (status)
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    else
        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Saving"];

    self.emailAddressField.enabled = status;
    [buttonTableViewCell setButtonState:status];
}

#pragma mark - table view datasource

- (NSString *)tableView:(UITableView *)inTableView titleForHeaderInSection:(NSInteger)section;
{
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Create your Geoloqi account", nil);
            break;
    }
    return title;
}

- (NSString *)tableView:(UITableView *)inTableView titleForFooterInSection:(NSInteger)section;
{
    NSString *footer;
    switch (section) {
        case 0:
            footer = NSLocalizedString(@"You'll get an email to complete the setup.", nil);
            break;
    }
    return footer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	UITableViewCell *cell;
    NSString *cellId;
    switch (indexPath.section) {
        case 0:
            cellId = @"email";
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
            cell.accessoryView = emailAddressField;
            cell.detailTextLabel.text = NSLocalizedString(@"Email", nil);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        case 1:
            buttonTableViewCell = [LQButtonTableViewCell buttonTableViewCellWithTitle:@"Save"
                                                                                owner:self
                                                                              enabled:[self isComplete]
                                                                               target:self
                                                                             selector:@selector(setupAccount)];
            cell = buttonTableViewCell;
            break;
            
        case 2:
            cellId = @"login";
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.textLabel.text = NSLocalizedString(@"Tap here to login with an existing account", nil);
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
            cell.backgroundColor = [UIColor clearColor];
            break;
    }

	return cell;
}

#pragma mark - table view delegate

- (IBAction)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        [settingsViewController switchFrom:self to:settingsViewController.loginViewController];
    }
}

#pragma mark - text field delegate

- (IBAction)textFieldDidEditChanged:(UITextField *)textField
{
    [buttonTableViewCell setButtonState:[self isComplete]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
	if ([self isComplete]) [self setupAccount];
	return YES;
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [emailAddressField becomeFirstResponder];
}

@end
