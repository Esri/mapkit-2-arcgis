//
// DemoTableFooterView.m
//
// @author Shiki
//

#import "LQTableFooterView.h"

@implementation LQTableFooterView

@synthesize activityIndicator;
@synthesize infoLabel;

- (void) awakeFromNib
{
  self.backgroundColor = [UIColor clearColor];
  [super awakeFromNib];
}

@end
