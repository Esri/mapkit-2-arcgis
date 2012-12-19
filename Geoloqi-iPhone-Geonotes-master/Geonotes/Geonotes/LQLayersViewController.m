//
//  LQLayersViewController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQLayersViewController.h"
#import "LQTableHeaderView.h"
#import "LQLayerManager.h"
#import "LQAppDelegate.h"

@implementation LQLayersViewController {
    LQLayerManager *layerManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Layers", @"Layers");
        self.tabBarItem.image = [UIImage imageNamed:@"layers"];
    }

    placeholderImage = [UIImage imageNamed:@"defaultLayerIcon"];
    layerManager = [LQLayerManager sharedManager];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Layers View Loaded");

    [self.tableView setBackgroundColor:[UIColor colorWithWhite:249.0/255.0 alpha:1.0]];

    // set the custom view for "pull to refresh". See LQTableHeaderView.xib
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LQTableHeaderView" owner:self options:nil];
    LQTableHeaderView *headerView = (LQTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = headerView;

    // Load the list from the local database
    [layerManager reloadLayersFromDB];
    
    // If there are no layers, then force an API call
    if (layerManager.layerCount == 0) {
        [self refresh];
    }
}

- (void)subscribeWasTapped:(UISwitch *)sender
{
    [layerManager manageSubscriptionForLayerAtIndex:sender.tag subscribe:sender.on];
}

#pragma mark - Pull to Refresh

- (void) pinHeaderView
{
    [super pinHeaderView];
    
    // do custom handling for the header view
    LQTableHeaderView *hv = (LQTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"Loading...";
}

- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    // do custom handling for the header view
    [[(LQTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    LQTableHeaderView *hv = (LQTableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text = @"Release to refresh...";
    else
        hv.title.text = @"Pull down to refresh...";
}

- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    [layerManager reloadLayersFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        [self.tableView reloadData];
        [self refreshCompleted];
    }];
    
    return YES;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return layerManager.layerCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LQLayerItemCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LQLayerItemCellView" owner:self options:nil];
		cell = tableCellView;
	}
    
    id item = [[layerManager layers] objectAtIndex:indexPath.row];
    if(item) {
        cell.layerID = [item objectForKey:@"layer_id"];
        cell.titleText.text = [item objectForKey:@"name"];
        cell.descriptionText.text = [item objectForKey:@"description"];
        cell.subscriptionSwitch.on = [[item objectForKey:@"subscribed"] boolValue];
        cell.subscriptionSwitch.tag = indexPath.row;
        [cell.subscriptionSwitch addTarget:self action:@selector(subscribeWasTapped:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // TODO: Remove this to enable selecting rows again
        [cell setImageFromURL:[item objectForKey:@"icon"] placeholderImage:placeholderImage];
    }
    return cell;
}

#pragma mark -

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

@end
