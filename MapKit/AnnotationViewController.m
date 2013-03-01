//
//  AnnotationViewController.m
//  MapCallouts
//
//  Created by Krishna Jagadish on 12/14/12.
//
//

#import "AnnotationViewController.h"

@interface AnnotationViewController ()

@end

@implementation AnnotationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.titleString.text = self.maintitle;
    self.subtitleString.text = self.subtitle;
    [self.leftAccessoryView addSubview:self.leftView];
    [self.rightAccessoryView addSubview:self.rightView];
    [super viewDidLoad];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

@end
