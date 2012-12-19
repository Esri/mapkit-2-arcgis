//
//  LQJSONRequestOperation.h
//  GeoloqiSDK
//
//  Created by Andrew Pouliot on 12/17/11.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LQJSONRequestOperation : NSOperation

- (id)initWithRequest:(NSURLRequest *)request;

@property (nonatomic, copy, readonly) NSURLRequest *request;

@property (nonatomic, strong) NSError *error;

//JSON decode
@property (nonatomic, copy, readonly) id responseJSON;

@property (nonatomic, strong, readonly) NSHTTPURLResponse *response;


@end
