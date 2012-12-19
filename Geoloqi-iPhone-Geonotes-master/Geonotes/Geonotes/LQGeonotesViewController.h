//
//  LQSecondViewController.h
//  Geonotes
//
//  Created by Aaron Parecki on 7/7/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQSTableViewController.h"
#import "LQGeonoteItemCellView.h"

@interface LQGeonotesViewController : LQSTableViewController {
    IBOutlet LQGeonoteItemCellView *tableCellView;
    UIImage *placeholderImage;
}

@end
