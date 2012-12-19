//
//  LQNewGeonoteViewController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQNewGeonoteViewController.h"

@interface LQNewGeonoteViewController ()

- (UIBarButtonItem *)createCancelButton;
//- (UIBarButtonItem *)createSaveButton;

@end

@implementation LQNewGeonoteViewController

@synthesize tableView = _tableView,
            geonote,
            geonoteTextView,
            cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"New Geonote";
        self.navigationItem.leftBarButtonItem = [self createCancelButton];
//        self.navigationItem.rightBarButtonItem = [self createSaveButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [geonoteTextView becomeFirstResponder];
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

#pragma mark - buttons

- (UIBarButtonItem *)createCancelButton
{
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(cancelButtonWasTapped:)];
    self.cancelButton = cancel;
    return cancel;
}

//- (UIBarButtonItem *)createSaveButton
//{
//    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithTitle:@"Save"
//                                                             style:UIBarButtonItemStyleDone
//                                                            target:self
//                                                            action:@selector(saveButtonWasTapped:)];
//    save.tintColor = [UIColor blueColor];
//    save.enabled = NO;
//    self.saveButton = save;
//    return save;
//}

#pragma mark - IBActions & utils

- (IBAction)cancelButtonWasTapped:(id)sender
{
    if ((self.geonote.text == nil || self.geonote.text.length == 0) && (self.geonote.location == nil)) {
        [self cancelGeonote];
    } else {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:@"Delete Draft"
                                               otherButtonTitles:nil];
        [as showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self cancelGeonote];
    }
}

- (void)cancelGeonote
{
    self.geonote = nil;
    mapViewController.geonote = nil;
    self.geonoteTextView.text = nil;
    [buttonTableViewCell setButtonState:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

- (IBAction)saveButtonWasTapped:(id)sender
{
    [self.geonoteTextView resignFirstResponder];
    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Saving"];
    [self.geonote save:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else if ([[responseDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
            [self cancelGeonote];
            // if the geonote is close enough, we need the server to tell us about it to set up
            // a region to monitor there; do this with a location update.
            [[LQTracker sharedTracker] enqueueCurrentLocationUpdate];
            if (self.saveComplete) self.saveComplete();
        }
    }];
}

- (LQGeonote *)geonote
{
    if (!geonote)
        geonote = [[LQGeonote alloc] initWithDelegate:self];
    return geonote;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
            if (mapViewController == nil)
                mapViewController = [[LQNewGeonoteMapViewController alloc] init];
            if (mapViewController.geonote == nil)
                mapViewController.geonote = [self geonote];

            [self.navigationController pushViewController:mapViewController animated:YES];
            break;
    }
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat f = 44;
    if (indexPath.section == 0)
        f = 180;
    return f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[NSArray alloc] initWithObjects:nil, @"Location", nil, nil];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"text"];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
            
            CGRect textViewRect = CGRectMake(10, 10, 280, 150);
            geonoteTextView = [[UITextView alloc] initWithFrame:textViewRect];
            geonoteTextView.font = [UIFont systemFontOfSize:16];
            geonoteTextView.returnKeyType = UIReturnKeyDone;
            [geonoteTextView setDelegate:self];
            if (self.geonote)
                geonoteTextView.text = self.geonote.text;
            cell.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:geonoteTextView];
            
            CGRect characterCountRect = CGRectMake(270, 160, 20, 18);
            characterCount = [[UILabel alloc] initWithFrame:characterCountRect];
            
            NSInteger chars = TOTAL_CHARACTER_COUNT - geonoteTextView.text.length;
            characterCount.text = [NSString stringWithFormat:@"%d", chars];
            characterCount.textColor = (chars < 0) ? [UIColor redColor] : [UIColor darkTextColor];
            
            characterCount.textAlignment = UITextAlignmentRight;
            characterCount.font = [UIFont systemFontOfSize:10];
            [cell.contentView addSubview:characterCount];
            
            break;
        }
            
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"location"];
            if (!cell)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"location"];
            
            if (self.geonote.location &&
                self.geonote.location.coordinate.latitude &&
                self.geonote.location.coordinate.longitude) {
                
                cell.textLabel.text = [NSString stringWithFormat:@"%f, %f",
                                       self.geonote.location.coordinate.latitude, self.geonote.location.coordinate.longitude];
                cell.textLabel.textColor = [UIColor blueColor];

            } else {
                cell.textLabel.text = @"Pick Location";
                cell.textLabel.textColor = [UIColor darkTextColor];
            }
            cell.textLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case 2:
        {
            buttonTableViewCell = [LQButtonTableViewCell buttonTableViewCellWithTitle:@"Create"
                                                                                owner:self
                                                                              enabled:[self.geonote isSaveable:TOTAL_CHARACTER_COUNT]
                                                                               target:self
                                                                             selector:@selector(saveButtonWasTapped:)];
            cell = buttonTableViewCell;
            break;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    switch (section) {
        case 0:
            break;
        case 1:
            header = @"Location";
            break;
    }
    return header;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    NSInteger chars = TOTAL_CHARACTER_COUNT - geonoteTextView.text.length;
    characterCount.textColor = (chars < 0) ? [UIColor redColor] : [UIColor darkTextColor];
    characterCount.text = [NSString stringWithFormat:@"%d", chars];
    self.geonote.text = textView.text;
    [buttonTableViewCell setButtonState:[self.geonote isSaveable:TOTAL_CHARACTER_COUNT]];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL should = NO;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    } else {
        should = YES;
    }
    return should;
}

#pragma mark - LQGeonoteDelegate

- (void)geonote:(LQGeonote *)_geonote locationDidChange:(CLLocation *)newLocation
{
    [buttonTableViewCell setButtonState:[_geonote isSaveable:TOTAL_CHARACTER_COUNT]];
    [self.tableView reloadData];
}

@end
