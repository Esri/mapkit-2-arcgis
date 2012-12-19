//
//  LQFirstViewController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQActivityViewController.h"
#import "LQActivityItemViewController.h"
#import "LQTableHeaderView.h"
#import "LQTableFooterView.h"
#import "LQActivityManager.h"
#import "LQAppDelegate.h"

#import "NSString+URLEncoding.h"

@implementation LQActivityViewController {
    LQActivityManager *activityManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Activity", @"Activity");
        self.tabBarItem.image = [UIImage imageNamed:@"activity"];
    }
    
    activityManager = [LQActivityManager sharedManager];
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Activity View Loaded");

    [self.tableView setBackgroundColor:DEFAULT_TABLE_VIEW_BACKGROUND_COLOR];

    // set the custom view for "pull to refresh". See LQTableHeaderView.xib
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LQTableHeaderView" owner:self options:nil];
    LQTableHeaderView *headerView = (LQTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = headerView;
    
    // set the custom view for "load more". See LQTableFooterView.xib
    nib = [[NSBundle mainBundle] loadNibNamed:@"LQTableFooterView" owner:self options:nil];
    LQTableFooterView *footerView = (LQTableFooterView *)[nib objectAtIndex:0];
    self.footerView = footerView;
    
    // Load the stored notes from the local database
    [activityManager reloadActivityFromDB];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addOrRemoveOverlay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addOrRemoveOverlay
{
    if (activityManager.activityCount == 0)
        [self addOverlayWithTitle:@"No Activity Yet" andText:@"Try subscribing to layers or\nleave yourself a Geonote"];
    else
        [self removeOverlay];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
    [super pinHeaderView];
    
    // do custom handling for the header view
    LQTableHeaderView *hv = (LQTableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = @"Loading...";
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    // do custom handling for the header view
    [[(LQTableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Update the header text while the user is dragging
// 
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    LQTableHeaderView *hv = (LQTableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text = @"Release to refresh...";
    else
        hv.title.text = @"Pull down to refresh...";
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// refresh the list. Do your async calls here.
// Retrieve newer entries for the top of the list
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    
    [activityManager reloadActivityFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        
        // Tell the table to reload
        [self.tableView reloadData];
        [self addOrRemoveOverlay];
        
        // Call this to indicate that we have finished "refreshing".
        // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
        [self refreshCompleted];
        
        // apparently need to recall loadMoreCompleted to reset the loadMore state
        [self loadMoreCompleted];

    }];

    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// The method -loadMore was called and will begin fetching data for the next page (more). 
// Do custom handling of -footerView if you need to.
//
- (void) willBeginLoadingMore
{
    if (activityManager.canLoadMore) {
        LQTableFooterView *fv = (LQTableFooterView *)self.footerView;
        [fv.activityIndicator startAnimating];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Do UI handling after the "load more" process was completed. In this example, -footerView will
// show a "No more items to load" text.
//
- (void) loadMoreCompleted
{
    [super loadMoreCompleted];
    
    LQTableFooterView *fv = (LQTableFooterView *)self.footerView;
    [fv.activityIndicator stopAnimating];
    
    if (!activityManager.canLoadMore) {

        // Do something if there are no more items to load
        
        // We can hide the footerView by: [self setFooterViewVisibility:NO];
        
        // Just show a textual info that there are no more items to load
        fv.infoLabel.hidden = NO;
    } else {
        fv.infoLabel.hidden = YES;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
    if (![super loadMore])
        return NO;
    
    if (activityManager.activityCount == 0) {
        [self loadMoreCompleted];
        return YES;
    }
    
    [activityManager loadMoreActivityFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {

        // Tell the table to reload
        [self.tableView reloadData];

        // Inform STableViewController that we have finished loading more items
        [self loadMoreCompleted];
    }];
    
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Standard TableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected row: %d", indexPath.row);
    
    LQActivityItemViewController *itemViewController = [[LQActivityItemViewController alloc] init];
    [itemViewController loadStory:[activityManager.activity objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:itemViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.5;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return activityManager.activityCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LQActivityItemCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LQActivityItemCellView" owner:self options:nil];
		cell = tableCellView;
	}
    
    id item = [activityManager.activity objectAtIndex:indexPath.row];
    if (item) {
        if([item respondsToSelector:@selector(objectForKey:)]) {
            cell.headerText.text = [item objectForKey:@"title"];
            cell.secondaryText.text = [[item objectForKey:@"object"] objectForKey:@"summary"];

            cell.dateText.text = [item objectForKey:@"displayDate"];
            
            NSString *imageURL;
            if(![[[[item objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"url"] isEqualToString:@""]) {
                imageURL = [[[item objectForKey:@"actor"] objectForKey:@"image"] objectForKey:@"url"];
            } else if(![[[[item objectForKey:@"generator"] objectForKey:@"image"] objectForKey:@"url"] isEqualToString:@""]) {
                imageURL = [[[item objectForKey:@"generator"] objectForKey:@"image"] objectForKey:@"url"];
            }
            if(![imageURL isEqualToString:@""]) {
                [cell setImageFromURL:imageURL];
            }
        } else {
            cell.secondaryText.text = item;
        }
    }
    return cell;
}

@end
