//
//  LQGeonoteManager.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 9/26/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQGeonoteManager.h"
#import "LOLDatabase.h"
#import "LQAppDelegate.h"

@implementation LQGeonoteManager {
    NSMutableArray *geonotes;
    LOLDatabase *db;
}

static LQGeonoteManager *geonoteManager;
static NSString *const kLQGeonoteCategoryName = @"LQGeonote";
static NSString *const kLQGeonoteCollectionName = @"LQGeonotes";
static NSString *const kLQGeonoteIDKey = @"geonote_id";
static NSString *const kLQGeonoteResponseDictionaryKey = @"geonotes";

static NSString *const kLQGeonoteListPath = @"/geonote/list_set";
static NSString *const kLQGeonoteDeletePath = @"/trigger/delete";

+ (void)initialize
{
    if (!geonoteManager)
        geonoteManager = [self new];
}

+ (LQGeonoteManager *)sharedManager
{
    return geonoteManager;
}

#pragma mark -

- (LQGeonoteManager *)init
{
    self = [super init];
    if (self) {
        db = [[LOLDatabase alloc] initWithPath:[LQAppDelegate cacheDatabasePathForCategory:kLQGeonoteCategoryName]];
        db.serializer = ^(id object){
            return [LQSDKUtils dataWithJSONObject:object error:NULL];
        };
        db.deserializer = ^(NSData *data) {
            return [LQSDKUtils objectFromJSONData:data error:NULL];
        };
    }
    return self;
}

- (NSArray *)geonotes
{
    return [NSArray arrayWithArray:geonotes];
}

- (NSInteger)geonoteCount
{
    return geonotes.count;
}

#pragma mark -

- (void)reloadGeonotesFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
{
    // reset local arrays and database
    NSMutableArray *_geonotes = [NSMutableArray new];
    [LQAppDelegate deleteFromTable:kLQGeonoteCollectionName forCategory:kLQGeonoteCategoryName];
    
    LQSession *session = [LQSession savedSession];
    NSURLRequest *request = [session requestWithMethod:@"GET"
                                                  path:kLQGeonoteListPath
                                               payload:nil];
    
    [session runAPIRequest:request completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
    
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"reloaded geonotes from API");
            
            for (NSDictionary *note in [responseDictionary objectForKey:kLQGeonoteResponseDictionaryKey]) {
                [db accessCollection:kLQGeonoteCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
                    [accessor setDictionary:note forKey:[note objectForKey:kLQGeonoteIDKey]];
                    [_geonotes insertObject:note atIndex:0];
                }];
            }
        
            geonotes = _geonotes;
        }
        
        if (completion) completion(response, responseDictionary, error);
    }];
}

- (void)reloadGeonotesFromDB
{
    geonotes = [NSMutableArray new];
    [db accessCollection:kLQGeonoteCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
        [accessor enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSDictionary *object, BOOL *stop) {
            [geonotes addObject:object];
        }];
    }];
    
    // TODO rip out LOLDatabase, this is ridiculous
    [geonotes sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        int dcts1 = (int)[obj1 objectForKey:@"date_created_ts"];
        int dcts2 = (int)[obj2 objectForKey:@"date_created_ts"];
        return dcts1 > dcts2;
    }];
}

- (void)deleteGeonote:(NSInteger)index completion:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))block
{
    NSDictionary *note = [geonotes objectAtIndex:index];
    LQSession *session = [LQSession savedSession];
    id geonoteId = [note objectForKey:kLQGeonoteIDKey];
    
    NSURLRequest *request = [session requestWithMethod:@"POST"
                                                  path:[NSString stringWithFormat:@"%@/%@", kLQGeonoteDeletePath, geonoteId]
                                               payload:nil];
    [session runAPIRequest:request completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else {
            NSLog(@"Deleted note: %@", responseDictionary);
            [db accessCollection:kLQGeonoteCollectionName withBlock:^(id<LOLDatabaseAccessor> accessor) {
                [accessor removeDictionaryForKey:geonoteId];
                [geonotes removeObjectAtIndex:index];
            }];
        }
        
        if (block) block(response, responseDictionary, error);
    }];

}

@end
