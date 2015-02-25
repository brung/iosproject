//
//  PhotoAnswerCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotoAnswerCell.h"
#import "PhotoAnswerView.h"
#import "ProfileImageView.h"

@interface PhotoAnswerCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet PhotoAnswerView *photo1View;
@property (weak, nonatomic) IBOutlet PhotoAnswerView *photo2View;

@end

@implementation PhotoAnswerCell

- (void)awakeFromNib {
    // Initialization code
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
    
    [self.photo1View setAnswer:self.survey.answers[0] andTotalVotes:self.survey.totalVotes];
    [self.photo2View setAnswer:self.survey.answers[1] andTotalVotes:self.survey.totalVotes];
}


@end
