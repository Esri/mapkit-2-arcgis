//
//  NSString+URLEncoding.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/8/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
    -(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
