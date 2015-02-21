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

@class SurveyViewCell;
@protocol SurveyViewCellDelegate <NSObject>
-(void)surveyViewCell:(SurveyViewCell *)cell didClickOnUser:(User *)user;
@end

@interface SurveyViewCell : UITableViewCell
@property (nonatomic, strong) Survey *survey;
@property (nonatomic, strong) id<SurveyViewCellDelegate> delegate;
@end
