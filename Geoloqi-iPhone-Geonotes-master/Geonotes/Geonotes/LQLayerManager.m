//
//  LQLayerManager.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 10/2/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQLayerManager.h"
#import "LOLDatabase.h"
#import "LQAppDelegate.h"

@implementation LQLayerManager {
    NSMutableArray *layers;
    BOOL isSorted;
    LOLDatabase *db;
}

static LQLayerManager *layerManager;
static NSString *const kLQLayerCategoryName = @"LQLayer";
static NSString *const kLQLayerCollectionName = @"LQLayers";

static NSString *const kLQLayerListPath = @"/layer/app_list";
static NSString *const kLQLayerSubscribePath = @"/layer/subscribe";
static NSString *const kLQLayerUnsubscribePath = @"/layer/unsubscribe";
static NSString *const kLQLayerNameDictionaryKey = @"name";
static NSString *const kLQLayerIDKey = @"layer_id";

#pragma mark -

+ (void)initialize
{
    if (!layerManager)
        layerManager = [self new];
}

+ (LQLayerManager *)sharedManager
{
    return layerManager;
}

#pragma mark -

- (LQLayerManager *)init
{
    self = [super init];
    if (self) {
        db = [[LOLDatabase alloc] initWithPath:[LQAppDelegate cacheDatabasePathForCategory:kLQLayerCategoryName]];
        db.serializer = ^(id object){
            return [LQSDKUtils dataWithJSONObject:object error:NULL];
        };
        db.deserializer = ^(NSData *data) {
            return [LQSDKUtils objectFromJSONData:data error:NULL];
        };
        isSorted = NO;
    }
    return self;
}

#pragma mark -

- (NSArray *)layers
{
    if (!isSorted) {
        [layers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *title1 = [obj1 objectForKey:@"name"];
            NSString *title2 = [obj2 objectForKey:@"name"];
            return [title1 localizedCaseInsensitiveCompare:title2];
        }];
        isSorted = YES;
    }
    return [NSArray arrayWithArray:layers];
}

- (NSInteger)layerCount
{
    
    return layers.count;
}

#pragma mark -

- (void)reloadLayersFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
{
    LQSession *session = [LQSession savedSession];
    NSURLRequest *request = [session requestWithMethod:@"GET"
                                                  path:kLQLayerListPath
                                               payload:nil];
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    } else {
                        
                        NSMutableArray *_layers = [[NSMutableArray alloc] init];
                        
                        for (NSString *key in responseDictionary) {
                            for (NSDictionary *item in [responseDictionary objectForKey:key]) {
                                [db accessCollection:kLQLayerCollectionName
                                           withBlock:^(id<LOLDatabaseAccessor> accessor) {
                                               [accessor setDictionary:item forKey:[item objectForKey:kLQLayerIDKey]];
                                               [_layers addObject:item];
                                           }];
                            }
                        }
                        
                        layers = _layers;
                        isSorted = NO;
                    }
        
                    if(completion) completion(response, responseDictionary, error);
                }];
}

- (void)reloadLayersFromDB
{
    layers = [[NSMutableArray alloc] init];
    [db accessCollection:kLQLayerCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
        [accessor enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *object, BOOL *stop) {
            [layers addObject:object];
        }];
    }];
    isSorted = NO;
}

#pragma mark -

- (void)manageSubscriptionForLayerAtIndex:(NSInteger)index subscribe:(BOOL)subscribe
{
    if (subscribe)
        [LQAppDelegate registerForPushNotificationsIfNotYetRegistered];
    
    LQSession *session = [LQSession savedSession];
    NSDictionary *layer = [layers objectAtIndex:index];
    NSString *path = [NSString stringWithFormat:@"%@/%@",
                      subscribe ? kLQLayerSubscribePath : kLQLayerUnsubscribePath,
                      [layer objectForKey:kLQLayerIDKey]];
    NSURLRequest *request = [session requestWithMethod:@"POST"
                                                  path:path
                                               payload:nil];
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }];
}

@end
