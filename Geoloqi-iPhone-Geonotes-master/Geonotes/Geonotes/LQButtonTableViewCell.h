//
//  LQButtonTableViewCell.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 8/6/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LQButtonTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIButton *button;

- (void)setButtonState:(BOOL)enabled;

+ (LQButtonTableViewCell *)buttonTableViewCellWithTitle:(NSString *)title owner:(id)owner enabled:(BOOL)enabled target:(id)target selector:(SEL)selector;

@end