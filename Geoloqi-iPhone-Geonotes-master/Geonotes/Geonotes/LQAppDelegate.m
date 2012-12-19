//
//  LQAppDelegate.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQAppDelegate.h"
//#import "LOLDatabase.h"
#import "sqlite3.h"
#import "Geoloqi.h"
#import "LQTabBarController.h"

#import "LQActivityManager.h"
#import "LQGeonoteManager.h"
#import "LQLayerManager.h"

@implementation LQAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

// This method is called by the Geonotes and Layers tabs when a new geonote is created or when a layer is subscribed to.
// The goal is to not prompt the user for push notifications until absolutely needed to avoid the double-popup problem on first launch.
// Also, now called during login callback. -kenichi
// If the app has never launched before, then show the prompt.
+ (void)registerForPushNotificationsIfNotYetRegistered {
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasRegisteredForPushNotifications"]){
        [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
            if(error){
                NSLog(@"Failed to register for push tokens: %@", error);
            } else {
                NSLog(@"Got a push token! %@", deviceToken);
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRegisteredForPushNotifications"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
	}
}

+ (BOOL)showLocationServicesDisabledAlertIfDisabled
{
    BOOL didShow = NO;
    // If they have explicitly denied location permission, show an alert with a warning
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *a = [[UIAlertView alloc] initWithTitle:@"Location Disabled"
                                                    message:@"Geonotes requires location services to be enabled. Please enable them using the Settings application."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [a show];
        didShow = YES;
    }
    return didShow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	[LQSession setAPIKey:LQ_APIKey secret:LQ_APISecret];
    [[LQSession savedSession] log:@"didFinishLaunchingWithOptions: %@", launchOptions];
    [[LQSession savedSession] log:@"monitored regions: %@", [[CLLocationManager new] monitoredRegions]];

    activityViewController = [[LQActivityViewController alloc] init];
    UINavigationController *activityNavController = [[UINavigationController alloc] initWithRootViewController:activityViewController];
    activityNavController.navigationBar.tintColor = [UIColor blackColor];

    geonotesViewController = [[LQGeonotesViewController alloc] init];
    geonotesNavController = [[UINavigationController alloc] initWithRootViewController:geonotesViewController];
    geonotesNavController.navigationBar.tintColor = [UIColor blackColor];

    UIViewController *newGeonotePlaceholderController = [[UINavigationController alloc] init];
    newGeonotePlaceholderController.title = @"New Geonote";

    layersViewController = [[LQLayersViewController alloc] init];
    UINavigationController *layersNavController = [[UINavigationController alloc] initWithRootViewController:layersViewController];
    layersNavController.navigationBar.tintColor = [UIColor blackColor];

    settingsViewController = [[LQSettingsViewController alloc] init];
    settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    settingsNavController.navigationBar.tintColor = [UIColor blackColor];
    
    self.tabBarController = [[LQTabBarController alloc] init];
    self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                activityNavController, 
                                                geonotesNavController,
                                                newGeonotePlaceholderController,
                                                layersNavController,
                                                settingsNavController,
                                                nil];
    [(LQTabBarController *)self.tabBarController addCenterButtonTarget:self action:@selector(newGeonoteButtonWasTapped:)];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    if(![LQSession savedSession]) {
		[LQSession createAnonymousUserAccountWithUserInfo:nil completion:^(LQSession *session, NSError *error) {
			//If we successfully created an anonymous session, tell the tracker to use it
			if (session) {
				NSLog(@"Created an anonymous user with access token: %@", session.accessToken);
				
				[[LQTracker sharedTracker] setSession:session]; // This saves the session so it will be restored on next app launch
				[[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive]; // This will cause the location prompt to appear the first time
			} else {
				NSLog(@"Error creating an anonymous user: %@", error);
			}
		}];
    } else {
        NSLog(@"Access Token: %@", [LQSession savedSession].accessToken);
        // Set up the tracker when the app re-launches
        [LQTracker sharedTracker];
    }

    // Tell the SDK the app finished launching so it can properly handle push notifications, etc
    [LQSession application:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (BOOL)reInitializeSessionFromSettingsPanel
{
    BOOL didSomething = NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults boolForKey:@"com.geoloqi.geonotes.clearLocalDatabase"]) {

        // Erase and reload the activity feed
        [activityViewController refresh];

        // tell all managers to reloadFromAPI, this clears the local database as well
        [[LQActivityManager sharedManager] reloadActivityFromAPI:nil];
        [[LQGeonoteManager sharedManager] reloadGeonotesFromAPI:nil];
        [[LQLayerManager sharedManager] reloadLayersFromAPI:nil];

        [defaults removeObjectForKey:@"com.geoloqi.geonotes.clearLocalDatabase"];
        didSomething = YES;
    }

    if([defaults valueForKey:@"com.geoloqi.geonotes.newAccessToken"]) {
        NSString *newAccessToken = [defaults valueForKey:@"com.geoloqi.geonotes.newAccessToken"];
        [defaults removeObjectForKey:@"com.geoloqi.geonotes.newAccessToken"];
        didSomething = YES;
        [LQSession setSavedSession:nil];
        LQSession *newSession = [LQSession sessionWithAccessToken:newAccessToken];
        [[LQTracker sharedTracker] setSession:newSession];
        NSLog(@"Re-initialized session!");
    }
    
    return didSomething;
}

- (void)refreshAllSubTableViews
{
    [activityViewController refresh];
    [geonotesViewController refresh];
    [layersViewController refresh];
}

- (IBAction)newGeonoteButtonWasTapped:(UIButton *)sender
{
    NSLog(@"New geonote");
    [LQAppDelegate registerForPushNotificationsIfNotYetRegistered];
    
    if (newGeonoteNavController == nil) {
        LQNewGeonoteViewController *newGeonoteController = [[LQNewGeonoteViewController alloc] init];
        newGeonoteController.saveComplete = ^{
            self.tabBarController.selectedViewController = geonotesNavController;
            [geonotesViewController refresh];
        };
        newGeonoteNavController = [[UINavigationController alloc] initWithRootViewController:newGeonoteController];
        newGeonoteNavController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        newGeonoteNavController.navigationBar.tintColor = [UIColor blackColor];

    }
    [self.tabBarController presentViewController:newGeonoteNavController animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    LQSession *session = [LQSession savedSession];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!SHOW_LOG_SETTINGS && [session fileLogging])
        [session setFileLogging:NO];
    [settingsViewController.tableView reloadData];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    // In the Settings panel for this app, you can enter an access token. If set, this function
    // re-initializes the LQSession with that account.
    if ([self reInitializeSessionFromSettingsPanel])
        [self refreshAllSubTableViews];
    
    [LQAppDelegate showLocationServicesDisabledAlertIfDisabled];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
	//For push notification support, we need to get the push token from UIApplication via this method.
	//If you like, you can be notified when the relevant web service call to the Geoloqi API succeeds.
    [LQSession registerDeviceToken:deviceToken withMode:PushNotificationMode];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
{
    [LQSession handleDidFailToRegisterForRemoteNotifications:error];
}

/**
 * This is called when a push notification is received if the app is running in the foreground. If the app was in the
 * background when the push was received, this will be run as soon as the app is brought to the foreground by tapping the notification.
 * The SDK will also call this method in application:didFinishLaunchingWithOptions: if the app was launched because of a push notification.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [LQSession handlePush:userInfo];
    // TODO get story id out of push data, prepend story to items and cache, show activity detail view
}

+ (NSString *)cacheDatabasePathForCategory:(NSString *)category
{
	NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lol.sqlite", category]];
}

// clears all rows from a table in a database
+ (void)deleteFromTable:(NSString *)collectionName forCategory:(NSString *)category
{
    sqlite3 *db;
    if(sqlite3_open([[LQAppDelegate cacheDatabasePathForCategory:category] UTF8String], &db) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'", collectionName];
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
    }
}

- (void)selectSetupAccountView
{
    self.tabBarController.selectedViewController = settingsNavController;
    [settingsViewController anonymousBannerWasTapped];
}

- (void)removeAnonymousBanners
{
    [activityViewController removeAnonymousBanner];
    [geonotesViewController removeAnonymousBanner];
    [layersViewController removeAnonymousBanner];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    NSLog(@"should select %@", viewController);
    return YES;
}

@end
