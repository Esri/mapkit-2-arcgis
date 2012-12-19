//
//  LQLayersViewController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQSTableViewController.h"
#import "LQLayerItemCellView.h"

@interface LQLayersViewController : LQSTableViewController {
    IBOutlet LQLayerItemCellView *tableCellView;
    UIImage *placeholderImage;
}

@end
