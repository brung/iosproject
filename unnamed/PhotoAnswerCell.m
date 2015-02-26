//
//  PhotoAnswerCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotoAnswerCell.h"
#import "PhotoAnswerView.h"
#import "UIColor+AppColor.h"
#import "NSDate+MinimalTimeAgo.h"

@interface PhotoAnswerCell() <ProfileImageViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet PhotoAnswerView *photo1View;
@property (weak, nonatomic) IBOutlet PhotoAnswerView *photo2View;

@end

@implementation PhotoAnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor appBgColor];
    self.innerView.layer.cornerRadius = 10;
    self.innerView.layer.masksToBounds = YES;
    self.profileImageView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    self.profileImageView.user = self.survey.user;
    self.nameLabel.text = self.survey.user.name;
    self.questionLabel.text = self.survey.question.text;
    self.timeLabel.text = [self.survey.question.createdAt timeAgo];
    
    [self.photo1View setAnswer:self.survey.answers[0] andTotalVotes:self.survey.totalVotes];
    [self.photo2View setAnswer:self.survey.answers[1] andTotalVotes:self.survey.totalVotes];
}

- (void)profileImageView:(ProfileImageView *)view tappedUser:(User *)user {
    [self.delegate photoAnswerCell:self didClickOnUser:user];
}

@end
