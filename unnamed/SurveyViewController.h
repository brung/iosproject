//
//  SurveyViewController.h
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"

@interface SurveyViewController : UIViewController
@property (nonatomic, strong) Survey *survey;
- (UIImageView *)getMainProfileImageView;
@end
