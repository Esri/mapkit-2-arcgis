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
