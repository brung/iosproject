//
//  SurveyHeaderCell.m
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyHeaderCell.h"
#import "UIImageView+AFNetworking.h"

@interface SurveyHeaderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation SurveyHeaderCell

- (void)awakeFromNib {
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.questionLabel.preferredMaxLayoutWidth = self.questionLabel.frame.size.width;
    
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    
    [self.profileImageView setImageWithURL:[NSURL URLWithString:survey.user.profileImageUrl]];
    self.nameLabel.text = survey.user.name;
    self.questionLabel.text = survey.question.text;
    
}

@end
