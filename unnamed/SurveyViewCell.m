//
//  SurveyViewCell.m
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyViewCell.h"
#import "ProfileImageView.h"
#import "AnswerCollectionView.h"

@interface SurveyViewCell ()

@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet AnswerCollectionView *answerCollectionView;

@end

@implementation SurveyViewCell

- (void)awakeFromNib {
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.questionLabel.preferredMaxLayoutWidth = self.questionLabel.frame.size.width;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    
    self.profileImageView.user = survey.user;
    self.nameLabel.text = survey.user.name;
    self.questionLabel.text = survey.question.text;
    self.answerCollectionView.answers = survey.answers;
}

@end
