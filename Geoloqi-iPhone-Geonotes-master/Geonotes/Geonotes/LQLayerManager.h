//
//  LQLayerManager.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 10/2/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQLayerManager : NSObject

// returns the singleton layer manager instance
//
+ (LQLayerManager *)sharedManager;

// returns a *sorted* immutable copy of the layers list
//
- (NSArray *)layers;

// returns count of layers in the layers list
//
- (NSInteger)layerCount;

// reloads the layer list from the API
//
- (void)reloadLayersFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion;

// reloads the layer list from the DB
//
- (void)reloadLayersFromDB;

// subscribes or unsubscribes from the layer at the given index
//
- (void)manageSubscriptionForLayerAtIndex:(NSInteger)index subscribe:(BOOL)subscribe;

@end
