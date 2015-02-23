//
//  SurveyViewCell.h
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "User.h"
#import "ProfileImageView.h"

@class SurveyViewCell;
@protocol SurveyViewCellDelegate <NSObject>
-(void)surveyViewCell:(SurveyViewCell *)cell didClickOnUser:(User *)user;
@end

@interface SurveyViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (nonatomic, strong) Survey *survey;
@property (nonatomic, strong) id<SurveyViewCellDelegate> delegate;
- (CGRect)profileImageviewFrame;

@end
