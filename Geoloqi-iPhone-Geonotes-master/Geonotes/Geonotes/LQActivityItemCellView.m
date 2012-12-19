//
//  LQLayerCellView.m
//  Geoloqi
//
//  Created by Aaron Parecki on 11/24/10.
//  Copyright 2010 Geoloqi.com. All rights reserved.
//

#import "LQActivityItemCellView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LQActivityItemCellView

@synthesize headerText, secondaryText, dateText;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewStylePlain reuseIdentifier:reuseIdentifier]) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setImageFromURL:(NSString *)url {
    [imgView setImageWithURL:[NSURL URLWithString:url]];
}

@end
