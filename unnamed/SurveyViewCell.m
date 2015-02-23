//
//  SurveyViewCell.m
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyViewCell.h"
#import "AnswerCollectionView.h"
#import "CommentCollectionView.h"
#import "UIColor+AppColor.h"
#import "NSDate+MinimalTimeAgo.h"

@interface SurveyViewCell () <ProfileImageViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *createdByLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet AnswerCollectionView *answerCollectionView;
@property (weak, nonatomic) IBOutlet CommentCollectionView *commentCollectionView;

@end

@implementation SurveyViewCell

- (void)awakeFromNib {
    // Setup containerView
    self.containerView.layer.cornerRadius = 10;
    self.containerView.layer.masksToBounds = YES;
    
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.questionLabel.preferredMaxLayoutWidth = self.questionLabel.frame.size.width;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor appBgColor];
    self.profileImageView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    
    self.profileImageView.user = survey.user;
    self.nameLabel.text = survey.user.name;
    self.createdByLabel.text = [survey.question.createdAt timeAgo];
    self.questionLabel.text = survey.question.text;
    [self.answerCollectionView setAnswers:survey.answers andTotal:survey.totalVotes];
    [self.commentCollectionView setComments:[NSArray arrayWithObjects:nil]];
}

- (void)profileImageView:(ProfileImageView *)view tappedUser:(User *)user {
    [self.delegate surveyViewCell:self didClickOnUser:user];
}

- (CGRect)profileImageviewFrame {
    float originX = self.contentView.frame.origin.x + self.containerView.frame.origin.x + self.profileImageView.frame.origin.x;
    float originY = self.contentView.frame.origin.y + self.containerView.frame.origin.y + self.profileImageView.frame.origin.y;
    return CGRectMake(originX, originY, self.profileImageView.frame.size.width, self.profileImageView.frame.size.height);
}
@end
