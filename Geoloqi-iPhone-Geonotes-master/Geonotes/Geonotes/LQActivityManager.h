//
//  LQActivityManager.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 9/21/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQActivityManager : NSObject

// based off the paging response, true if more messages are available, false otherwise
//
@property BOOL canLoadMore;

// returns the singleton manager instance
//
+ (LQActivityManager *)sharedManager;

// returns an immutable copy of the activity list
//
- (NSArray *)activity;

// returns count of messages in the activity list
//
- (NSInteger)activityCount;

// reloads the activity list from API
//
- (void)reloadActivityFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion;

// load more activity from the API
//
- (void)loadMoreActivityFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion;

// reloads the activity list from DB
//
- (void)reloadActivityFromDB;

@end
