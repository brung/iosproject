//
//  SurveyHeaderView.m
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyHeaderView.h"
#import "UIImageView+AFNetworking.h"

@interface SurveyHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation SurveyHeaderView


- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:survey.user.profileImageUrl]];
    self.nameLabel.text = survey.user.name;
    self.questionLabel.text = survey.question.text;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
