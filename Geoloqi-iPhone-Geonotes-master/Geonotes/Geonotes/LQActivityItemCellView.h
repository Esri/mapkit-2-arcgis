//
//  LQLayerCellView.h
//  Geoloqi
//
//  Created by Amber Case and Aaron Parecki on 11/24/10.
//  Copyright 2010 Geoloqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LQActivityItemCellView : UITableViewCell {
	IBOutlet UIImageView *imgView;
}

@property IBOutlet UILabel *headerText;
@property IBOutlet UILabel *secondaryText;
@property IBOutlet UILabel *dateText;

- (void)setImageFromURL:(NSString *)url;

@end
