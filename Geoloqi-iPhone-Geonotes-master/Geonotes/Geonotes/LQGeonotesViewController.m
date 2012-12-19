//
//  LQSecondViewController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQGeonotesViewController.h"
#import "LQTableHeaderView.h"
#import "LQAppDelegate.h"
#import "LQGeonoteManager.h"

@interface LQGeonotesViewController ()

@end

@implementation LQGeonotesViewController {
    LQGeonoteManager *geonoteManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Geonotes", @"Geonotes");
        self.tabBarItem.image = [UIImage imageNamed:@"geonote"];
    }
    
    geonoteManager = [LQGeonoteManager sharedManager];
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Geonotes View Loaded");

    [self.tableView setBackgroundColor:[UIColor colorWithWhite:249.0/255.0 alpha:1.0]];
    
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
    self.navigationItem.leftBarButtonItem.action = @selector(editWasTapped:);
        
    // set the custom view for "pull to refresh". See LQTableHeaderView.xib
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LQTableHeaderView" owner:self options:nil];
    LQTableHeaderView *headerView = (LQTableHeaderView *)[nib objectAtIndex:0];
    self.headerView = headerView;

    // Provide an empty footer view to hide the separators between cells
    // http://stackoverflow.com/questions/1491033/how-to-display-a-table-with-zero-rows-in-uitableview
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    // Load the list from the local database
    [geonoteManager reloadGeonotesFromDB];
    
    // If there are no layers, then force an API call
    if (geonoteManager.geonoteCount == 0)
        [self refresh];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self addOrRemoveOverlay];
}

- (void)editWasTapped:(id)sender 
{
    if(self.tableView.editing) {
        [super setEditing:NO animated:YES];
        [self.tableView setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem.title = @"Edit";
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem.title = @"Done";
    }
}

- (void)addOrRemoveOverlay
{
    if (geonoteManager.geonoteCount == 0)
        [self addOverlayWithTitle:@"No Active Geonotes" andText:@"You should leave yourself a Geonote"];
    else
        [self removeOverlay];
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
    
    [geonoteManager reloadGeonotesFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        
        // Tell the table to reload
        [self.tableView reloadData];
        [self addOrRemoveOverlay];
        
        // Call this to indicate that we have finished "refreshing".
        // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
        [self refreshCompleted];
    }];
    
    return YES;
}


#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74.0;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return geonoteManager.geonoteCount;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    LQGeonoteItemCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"LQGeonoteItemCellView" owner:self options:nil];
		cell = tableCellView;
	}
    
    id item = [geonoteManager.geonotes objectAtIndex:indexPath.row];
    if(item) {
        cell.placeName.text = [item objectForKey:@"place_name"];
        cell.secondaryText.text = [item objectForKey:@"text"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // TODO: Remove this to enable selecting rows again
        
        cell.dateText.text = [item objectForKey:@"display_date"];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return YES;
}
   
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [geonoteManager deleteGeonote:indexPath.row completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
            
            // Animate deletion
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            
            [self addOrRemoveOverlay];

        }];
        
    }
}


#pragma mark -


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
