//
//  LQCreditsViewController.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 8/13/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQCreditsViewController.h"

@interface LQCreditsViewController ()

@end

@implementation LQCreditsViewController

@synthesize tableView = _tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *header;
    switch (section) {
        case 0:
            header = @"Authors";
            break;
        case 1:
            header = @"Thanks";
            break;
    }
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Aaron Parecki";
                    cell.detailTextLabel.text = @"aaron@geoloqi.com";
                    break;
                case 1:
                    cell.textLabel.text = @"Kenichi Nakamura";
                    cell.detailTextLabel.text = @"kenichi@geoloqi.com";
                    break;
                case 2:
                    cell.textLabel.text = @"Patrick Arlt";
                    cell.detailTextLabel.text = @"pat@geoloqi.com";
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Sounds";
                    cell.detailTextLabel.text = @"ThanksSoundDesign.com";
                    break;
                case 1:
                    cell.textLabel.text = @"Icons";
                    cell.detailTextLabel.text = @"Glyphish.com";
                    break;
                case 2:
                    cell.textLabel.text = @"Support";
                    cell.detailTextLabel.text = @"community.geoloqi.com";
                    break;
            }
            break;
    }
    
    return cell;
}

@end
