//
//  LQLayerItemCellView.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/18/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQLayerItemCellView : UITableViewCell {
	IBOutlet UIImageView *imgView;
}

@property IBOutlet UILabel *titleText;
@property IBOutlet UILabel *descriptionText;
@property IBOutlet UISwitch *subscriptionSwitch;
@property NSString *layerID;

- (void)setImageFromURL:(NSString *)url placeholderImage:(UIImage *)image;

@end
