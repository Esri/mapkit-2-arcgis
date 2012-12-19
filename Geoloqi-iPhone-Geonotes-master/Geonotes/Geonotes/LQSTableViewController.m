//
//  LQSTableViewController.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 8/3/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQSTableViewController.h"
#import "LQAppDelegate.h"


#define OVERLAY_TEXT_COLOR [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]
#define OVERLAY_TITLE_FONT_SIZE  24.0
#define OVERLAY_TEXT_FONT_SIZE   16.0
#define OVERLAY_FONT_LINE_HEIGHT 26.0

#define ANONYMOUS_BANNER_HEIGHT 44
#define ANONYMOUS_BANNER_BACKGROUND_COLOR [UIColor colorWithRed:232.0/255.0 green:136.0/255.0 blue:70.0/255.0 alpha:1.0]

@interface LQSTableViewController ()

@end

@implementation LQSTableViewController

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
	// Do any additional setup after loading the view.
    
    // if this is the very first time the app has loaded, an anonymous account may not have
    // been created yet, so this may return with null.
    [LQSession savedSession:^(LQSession *session) {
        if (!session || [session isAnonymous]) {
            [self addAnonymousBanner];
        }
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)addOverlayWithTitle:(NSString *)title andText:(NSString *)text
{
    // remove if we have one
    [self removeOverlay];
    
    // start off with a label frame big
    overlayTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,480)];
    
    // set all the things
    overlayTitleLabel.textAlignment = UITextAlignmentCenter;
    overlayTitleLabel.text = title;
    overlayTitleLabel.textColor = OVERLAY_TEXT_COLOR;
    overlayTitleLabel.font = [UIFont boldSystemFontOfSize:OVERLAY_TITLE_FONT_SIZE];
    overlayTitleLabel.backgroundColor = DEFAULT_TABLE_VIEW_BACKGROUND_COLOR;
    
    // shrink it up!
    [overlayTitleLabel sizeToFit];
    
    // repeat for text
    overlayTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,320,480)];
    overlayTextLabel.textAlignment = UITextAlignmentCenter;
    overlayTextLabel.text = text;
    overlayTextLabel.textColor = OVERLAY_TEXT_COLOR;
    overlayTextLabel.font = [UIFont systemFontOfSize:OVERLAY_TEXT_FONT_SIZE];
    overlayTextLabel.numberOfLines = 0;
    overlayTextLabel.backgroundColor = DEFAULT_TABLE_VIEW_BACKGROUND_COLOR;
    [overlayTextLabel sizeToFit];
    
    // find widest label
    float widest = overlayTitleLabel.frame.size.width;
    if (overlayTextLabel.frame.size.width > widest)
        widest = overlayTextLabel.frame.size.width;
    
    // set both frames to same (max) width
    CGRect f = overlayTitleLabel.frame;
    f.size.width = widest;
    if (f.size.height < OVERLAY_FONT_LINE_HEIGHT) f.size.height = OVERLAY_FONT_LINE_HEIGHT;
    overlayTitleLabel.frame = f;
    
    // also set origin Y of text frame to bottom of title frame
    f = overlayTextLabel.frame;
    f.size.width = widest;
    f.origin.y = overlayTitleLabel.frame.size.height;
    if (f.size.height < (OVERLAY_FONT_LINE_HEIGHT * 2)) f.size.height = (OVERLAY_FONT_LINE_HEIGHT * 2);
    overlayTextLabel.frame = f;
    
    // find origin for centering view
    float combinedHeight = (overlayTitleLabel.frame.size.height + overlayTextLabel.frame.size.height);
    CGRect tableViewFrame = self.tableView.frame;
    float originX = (tableViewFrame.size.width - widest) / 2;
    float originY = (tableViewFrame.size.height - combinedHeight) / 2;
    
    // make view, add labels...
    overlayView = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, widest, combinedHeight)];
    [overlayView addSubview:overlayTitleLabel];
    [overlayView addSubview:overlayTextLabel];
    
    // show it!
    [self.tableView addSubview:overlayView];
}

- (void)removeOverlay
{
    if (overlayView) [overlayView removeFromSuperview];
}

#pragma mark -

- (void)addAnonymousBanner
{
    CGRect _tvf = self.tableView.frame;
    CGRect tvf = CGRectMake(_tvf.origin.x,
                            (_tvf.origin.y + ANONYMOUS_BANNER_HEIGHT),
                            _tvf.size.width,
                            (_tvf.size.height - ANONYMOUS_BANNER_HEIGHT));
    CGRect bannerFrame = CGRectMake(_tvf.origin.x, _tvf.origin.y, _tvf.size.width, ANONYMOUS_BANNER_HEIGHT);
    anonymousBanner = [UIButton buttonWithType:UIButtonTypeCustom];
    anonymousBanner.frame = bannerFrame;
    anonymousBanner.backgroundColor = ANONYMOUS_BANNER_BACKGROUND_COLOR;
    [anonymousBanner setTitle:@"You are using Geonotes anonymously" forState:UIControlStateNormal];
    [anonymousBanner setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    anonymousBanner.titleLabel.font = [UIFont systemFontOfSize:12];
    [anonymousBanner setUserInteractionEnabled:YES];
    [anonymousBanner addTarget:[[UIApplication sharedApplication] delegate]
                        action:@selector(selectSetupAccountView)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.frame = tvf;
    [self.view addSubview:anonymousBanner];
}

- (void)removeAnonymousBanner
{
    if (anonymousBanner) {
        [anonymousBanner removeFromSuperview];
        CGRect frame = self.tableView.frame;
        frame.origin.y -= ANONYMOUS_BANNER_HEIGHT;
        frame.size.height += ANONYMOUS_BANNER_HEIGHT;
        self.tableView.frame = frame;
        anonymousBanner = nil;
    }
}

@end
