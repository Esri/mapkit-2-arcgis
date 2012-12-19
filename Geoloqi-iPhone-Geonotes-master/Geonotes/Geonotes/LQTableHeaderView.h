//
// DemoTableHeaderView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface LQTableHeaderView : UIView {
    
  UILabel *title;
  UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
