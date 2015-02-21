//
//  DetailQuestionCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailQuestionCell.h"
#import "ProfileImageView.h"

@interface DetailQuestionCell()
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation DetailQuestionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews {
    self.profileImageView.user = self.user;
    self.nameLabel.text = self.user.name;
    self.questionLabel.text = self.question.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
