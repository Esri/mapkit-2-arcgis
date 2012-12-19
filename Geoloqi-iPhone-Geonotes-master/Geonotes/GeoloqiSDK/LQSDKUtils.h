//
//  LQSDKUtils.h
//  GeoloqiSDK
//
//  Created by Andrew Pouliot on 12/17/11.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQSDKUtils : NSObject

+ (id)objectFromJSONData:(NSData *)data error:(NSError **)error;

+ (NSData *)dataWithJSONObject:(id)object error:(NSError **)error;


+ (NSOperation *)httpOperationForRequest:(NSURLRequest *)inRequest completion:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))block;


@end
