//
//  AnnotationTemplate.h
//  MapCallouts
//
//  Created by Krishna Jagadish on 12/14/12.
//
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "AnnotationViewController.h"

@interface AnnotationTemplate : NSObject <AGSInfoTemplateDelegate>

// Title and subtitle for use by selection UI.
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property ( nonatomic, strong) UIView* leftView;
@property ( nonatomic, strong) UIView* rightView;

@property ( nonatomic, strong) AnnotationViewController* anvc;

- (UIView *)customViewForGraphic:(AGSGraphic *) graphic screenPoint:(CGPoint) screen mapPoint:(AGSPoint *) mapPoint ;

@end
