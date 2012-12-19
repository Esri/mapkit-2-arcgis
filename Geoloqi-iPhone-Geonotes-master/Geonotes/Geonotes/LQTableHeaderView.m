//
// DemoTableHeaderView.m
//
// @author Shiki
//

#import "LQTableHeaderView.h"

@implementation LQTableHeaderView

@synthesize title;
@synthesize activityIndicator;

- (void) awakeFromNib
{
  self.backgroundColor = [UIColor clearColor];
  [super awakeFromNib];
}

@end
