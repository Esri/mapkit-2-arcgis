//
//  AnnotationTemplate.m
//  MapCallouts
//
//  Created by Krishna Jagadish on 12/14/12.
//
//

#import "AnnotationTemplate.h"

@implementation AnnotationTemplate

- (UIView *)customViewForGraphic:(AGSGraphic *) graphic screenPoint:(CGPoint) screen mapPoint:(AGSPoint *) mapPoint
{
    //create a view programatically, or load from nib file
    self.anvc = [[AnnotationViewController alloc] initWithNibName:@"AnnotationViewController" bundle:nil];
    self.anvc.maintitle = self.title;
    self.anvc.subtitle = self.subtitle;
    
    if ( self.leftView)
        self.anvc.leftView = self.leftView;
    if ( self.rightView)
        self.anvc.rightView = self.rightView;
//    [self.anvc setGraphics];
    
    return self.anvc.view;
    
}




@end
