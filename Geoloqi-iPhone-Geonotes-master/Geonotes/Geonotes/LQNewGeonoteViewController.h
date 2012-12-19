//
//  LQNewGeonoteViewController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

#import "LQGeonote.h"
#import "LQNewGeonoteMapViewController.h"
#import "LQButtonTableViewCell.h"

#define TOTAL_CHARACTER_COUNT 140

typedef void(^CompletionCallback)(void);

@interface LQNewGeonoteViewController : UIViewController <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, LQGeonoteDelegate, UIActionSheetDelegate> {
    LQNewGeonoteMapViewController *mapViewController;
    UILabel *characterCount;
    NSString *geonoteLocationDescription;
    LQButtonTableViewCell *buttonTableViewCell;
}

@property (nonatomic, strong) CompletionCallback saveComplete;
@property (nonatomic, strong) LQGeonote *geonote;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITextView *geonoteTextView;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)cancelButtonWasTapped:(id)sender;
- (IBAction)saveButtonWasTapped:(id)sender;

@end