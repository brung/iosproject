//
//  DetailQuestionCell.h
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "User.h"
#import "ProfileImageView.h"

@interface DetailQuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;

- (void) initWithQuestion:(Question *)question user:(User *)user totalCount:(NSInteger)count;
@end
