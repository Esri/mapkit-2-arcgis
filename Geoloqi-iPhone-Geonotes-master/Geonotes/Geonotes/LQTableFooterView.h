//
// DemoTableFooterView.h
//
// @author Shiki
//

#import <UIKit/UIKit.h>


@interface LQTableFooterView : UIView {
    
  UIActivityIndicatorView *activityIndicator;
  UILabel *infoLabel;
}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;

@end
