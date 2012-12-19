//
//  LQAppDelegate.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LQActivityViewController.h"
#import "LQGeonotesViewController.h"
#import "LQNewGeonoteViewController.h"
#import "LQLayersViewController.h"
#import "LQSettingsViewController.h"

// TODO: Switch to LQPushNotificationModeLive before publishing to app store!
static LQPushNotificationMode const PushNotificationMode = LQPushNotificationModeDev;

@interface LQAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    LQActivityViewController *activityViewController;
    
    UINavigationController *newGeonoteNavController;
    LQGeonotesViewController *geonotesViewController;
    UINavigationController *geonotesNavController;
    
    LQLayersViewController *layersViewController;
    LQSettingsViewController *settingsViewController;
    UINavigationController *settingsNavController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

- (IBAction)newGeonoteButtonWasTapped:(UIButton *)sender;
- (void)refreshAllSubTableViews;

- (void)selectSetupAccountView;
- (void)removeAnonymousBanners;

+ (NSString *)cacheDatabasePathForCategory:(NSString *)category;
+ (void)deleteFromTable:(NSString *)collectionName forCategory:(NSString *)category;

+ (void)registerForPushNotificationsIfNotYetRegistered;
+ (BOOL)showLocationServicesDisabledAlertIfDisabled;

@end
