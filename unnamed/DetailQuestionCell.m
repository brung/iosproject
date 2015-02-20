//
//  DetailQuestionCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailQuestionCell.h"
#import "UIImageView+AFNetworking.h"

@interface DetailQuestionCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@end

@implementation DetailQuestionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    [self.profileImageView setImageWithURL:[NSURL URLWithString:self.user.profileImageUrl]];
    self.nameLabel.text = self.user.name;
    self.questionLabel.text = self.question.text;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
