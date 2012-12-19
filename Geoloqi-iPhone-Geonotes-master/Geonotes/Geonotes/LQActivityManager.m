//
//  LQActivityManager.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 9/21/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQActivityManager.h"
#import "LOLDatabase.h"
#import "LQAppDelegate.h"
#import "LQSDKUtils.h"
#import "NSString+URLEncoding.h"

@interface LQActivityManager ()
- (void)reloadActivityFromAPI:(NSString *)path onSuccess:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))success;
@end

@implementation LQActivityManager {
    NSMutableArray *activities;
    LOLDatabase *db;
}

@synthesize canLoadMore;

static LQActivityManager *activityManager;
static NSString *const kLQActivityCategoryName = @"LQActivity";
static NSString *const kLQActivityCollectionName = @"LQActivities";

+ (void)initialize
{
    if (!activityManager)
        activityManager = [self new];
}

+ (LQActivityManager *)sharedManager
{
    return activityManager;
}

#pragma mark -

- (LQActivityManager *)init
{
    self = [super init];
    if (self) {
        db = [[LOLDatabase alloc] initWithPath:[LQAppDelegate cacheDatabasePathForCategory:kLQActivityCategoryName]];
        db.serializer = ^(id object){
            return [LQSDKUtils dataWithJSONObject:object error:NULL];
        };
        db.deserializer = ^(NSData *data) {
            return [LQSDKUtils objectFromJSONData:data error:NULL];
        };
        
        self.canLoadMore = YES;
    }
    return self;
}

- (NSArray *)activity
{
    return [NSArray arrayWithArray:activities];
}

- (NSInteger)activityCount
{
    return activities.count;
}

#pragma mark -

- (void)reloadActivityFromAPI:(NSString *)path onSuccess:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))success
{
    LQSession *session = [LQSession savedSession];
    NSURLRequest *request = [session requestWithMethod:@"GET"
                                                  path:path
                                               payload:nil];
    [session runAPIRequest:request completion:^(NSHTTPURLResponse *_response, NSDictionary *_responseDictionary, NSError *_error) {
        if (_error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[_error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            success(_response, _responseDictionary, _error);
        }
    }];
}

- (void)reloadActivityFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
{
    // reset local arrays and database
    NSMutableArray *_activities = [NSMutableArray new];
    [LQAppDelegate deleteFromTable:kLQActivityCollectionName forCategory:kLQActivityCategoryName];
    
    [self reloadActivityFromAPI:@"/timeline/messages" onSuccess:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        for (NSDictionary *item in [responseDictionary objectForKey:@"items"]) {
            [db accessCollection:kLQActivityCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
                [accessor setDictionary:item forKey:[item objectForKey:@"published"]];
                [_activities addObject:item];
            }];
        }
        
        activities = _activities;
        
        if ([[responseDictionary objectForKey:@"paging"] objectForKey:@"next_offset"])
            self.canLoadMore = YES;
        else
            self.canLoadMore = NO;
        
        if (completion) completion(response, responseDictionary, error);
    }];
}

- (void)loadMoreActivityFromAPI:(void (^)(NSHTTPURLResponse *, NSDictionary *, NSError *))completion
{
    if (self.canLoadMore) {
        NSString *lastItemDate = [[[activities objectAtIndex:(activities.count - 1)] objectForKey:@"published"] urlEncodeUsingEncoding:NSUTF8StringEncoding];
        NSString *path = [NSString stringWithFormat:@"/timeline/messages?before=%@", lastItemDate];
        
        [self reloadActivityFromAPI:path onSuccess:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
            for (NSDictionary *item in [responseDictionary objectForKey:@"items"]) {
                [db accessCollection:kLQActivityCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
                    [accessor setDictionary:item forKey:[item objectForKey:@"published"]];
                    [activities addObject:item];
                }];
            }
            
            if ([[responseDictionary objectForKey:@"paging"] objectForKey:@"next_offset"])
                self.canLoadMore = YES;
            else
                self.canLoadMore = NO;
            
            if (completion) completion(response, responseDictionary, error);
        }];
    }
}

- (void)reloadActivityFromDB
{
    activities = [NSMutableArray new];
    [db accessCollection:kLQActivityCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
        [accessor enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *object, BOOL *stop) {
            [activities addObject:object];
        }];
    }];
    
    // TODO rip out LOLDatabase, this is ridiculous
    [activities sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        NSString *pub1 = [obj1 objectForKey:@"published"];
        NSString *pub2 = [obj2 objectForKey:@"published"];
        return [pub2 localizedCaseInsensitiveCompare:pub1];
    }];
}

@end