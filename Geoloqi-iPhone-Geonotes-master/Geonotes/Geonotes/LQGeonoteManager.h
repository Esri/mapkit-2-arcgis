//
//  LQGeonoteManager.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 9/26/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQGeonoteManager : NSObject

// returns the singleton manager instance
//
+ (LQGeonoteManager *)sharedManager;

// returns an immutable copy of the geonote list
//
- (NSArray *)geonotes;

// returns count of messages in the geonote list
//
- (NSInteger)geonoteCount;

// reloads the geonote list from API
//
- (void)reloadGeonotesFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion;

// reloads the activity list from DB
//
- (void)reloadGeonotesFromDB;

// deletes the geonote via the API
//
- (void)deleteGeonote:(NSInteger)index completion:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))block;

@end
