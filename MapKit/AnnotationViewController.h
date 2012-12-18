//
//  AnnotationViewController.h
//  MapCallouts
//
//  Created by Krishna Jagadish on 12/14/12.
//
//

#import <UIKit/UIKit.h>

@interface AnnotationViewController : UIViewController


@property ( nonatomic, strong) NSString* maintitle;
@property ( nonatomic, strong) NSString* subtitle;
@property ( nonatomic, strong) UIView* leftView;
@property ( nonatomic, strong) UIView* rightView;

@property ( nonatomic, strong) IBOutlet UIView* leftAccessoryView;
@property ( nonatomic, strong) IBOutlet UIView* rightAccessoryView;
@property ( nonatomic, strong) IBOutlet UILabel* titleString;
@property ( nonatomic, strong) IBOutlet UILabel* subtitleString;

@end
