/*
 Copyright 2013 Esri
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

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

    
    return self.anvc.view;
    
}




@end
