//
//  LQGeonote.m
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/30/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQGeonote.h"

@interface LQGeonote ()

- (NSDictionary *)dictionary;

@end

@implementation LQGeonote

- (id)initWithDelegate:(id<LQGeonoteDelegate>)delegate
{
    if (self = [super init]) {
        maxTextLength = 0;
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - setters

- (void)setLocation:(CLLocation *)location
{
    _location = location;
    [self.delegate geonote:self locationDidChange:self.location];
//    NSLog(@"location: %@", [self description]);
}

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    if ([self.delegate respondsToSelector:@selector(geonote:radiusDidChange:)])
        [self.delegate geonote:self radiusDidChange:self.radius];
//    NSLog(@"radius: %@", [self description]);
}

- (void)setText:(NSString *)text
{
    _text = text;
    if ([self.delegate respondsToSelector:@selector(geonote:textDidChange:)])
        [self.delegate geonote:self textDidChange:self.text];
//    NSLog(@"text: %@", [self description]);
}

#pragma mark - other

- (BOOL)isSaveable:(NSInteger)_maxTextLength
{
    if (maxTextLength != _maxTextLength)
        maxTextLength = _maxTextLength;
    return ((_location != nil) && (_text != nil) && (_text.length > 0) && (_text.length <= maxTextLength));
}

- (BOOL)isSaveable
{
    BOOL r = NO;
    if (maxTextLength > 0) {
        r = [self isSaveable:maxTextLength];
    }
    return r;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Geonote at %f, %f with radius %f, text: \"%@\"",
            self.location.coordinate.latitude,
            self.location.coordinate.longitude,
            self.radius,
            self.text];
}

- (void)save:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))complete
{
    if ([self isSaveable]) {
        LQSession *session = [LQSession savedSession];
        NSURLRequest *request = [session requestWithMethod:@"POST" path:@"/geonote/create" payload:[self dictionary]];
        [session runAPIRequest:request completion:complete];
    }
}

- (NSDictionary *)dictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.text, @"text",
            [NSString stringWithFormat:@"%f", self.location.coordinate.latitude],  @"latitude",
            [NSString stringWithFormat:@"%f", self.location.coordinate.longitude], @"longitude",
            [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:self.radius] intValue]], @"radius",
            nil];
}

@end