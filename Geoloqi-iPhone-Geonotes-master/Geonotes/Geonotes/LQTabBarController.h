//
//  LQTabBarController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQTabBarController : UITabBarController <UITabBarControllerDelegate> {
    UIButton *centerButton;
    UIImage *defaultImage;
    UIImage *highlightedImage;
}

// Create a view controller and setup it's tab bar item with a title and image
- (UIViewController *)viewControllerWithTabTitle:(NSString*)title image:(UIImage*)image;

// Create a custom UIButton and add it to the center of our tab bar
- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

- (void)addCenterButtonTarget:(id)target action:(SEL)sel;

@end
