//
//  LQTabBarController.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQTabBarController.h"

@interface LQTabBarController ()

@end

@implementation LQTabBarController

// Create a view controller and setup it's tab bar item with a title and image
- (UIViewController *)viewControllerWithTabTitle:(NSString*) title image:(UIImage*)image
{
    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image tag:0];
    return viewController;
}

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    // Store images as local variables
    defaultImage = buttonImage;
    highlightedImage = highlightImage;

    centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    centerButton = [[UIImageView alloc] initWithImage:buttonImage];
    centerButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    centerButton.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [centerButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [centerButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];


    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        centerButton.center = self.tabBar.center;
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0;
        centerButton.center = center;
    }
    
    [self.view addSubview:centerButton];
}

- (void)addCenterButtonTarget:(id)target action:(SEL)sel
{
    [centerButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"newGeonote.png"] 
                    highlightImage:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
