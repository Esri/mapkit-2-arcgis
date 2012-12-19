//
//  LQLayerItemCellView.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "LQLayerItemCellView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LQLayerItemCellView

@synthesize subscriptionSwitch, titleText, descriptionText, layerID;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setImageFromURL:(NSString *)url placeholderImage:(UIImage *)image {
    [imgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:image];
}

@end
