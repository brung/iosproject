//
//  DetailQuestionCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailQuestionCell.h"
#import "ProfileImageView.h"
#import "NSDate+MinimalTimeAgo.h"


@interface DetailQuestionCell()
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) User *user;
@property (nonatomic, assign) NSInteger totalVoteCount;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;

@end

@implementation DetailQuestionCell

- (void)awakeFromNib {
    // In here to fix TableCell layout issue when using UITableViewAutomaticDimension
    // But was this fix in the latest version?
    self.questionLabel.preferredMaxLayoutWidth = self.questionLabel.frame.size.width;
}

- (void) layoutSubviews {
    self.profileImageView.user = self.user;
    self.nameLabel.text = self.user.name;
    self.questionLabel.text = self.question.text;
    self.timeLabel.text = [self.question.createdAt timeAgo];
    self.voteCountLabel.text = [NSString stringWithFormat:@"%ld", (long)self.totalVoteCount];
}

- (void) initWithQuestion:(Question *)question user:(User *)user totalCount:(NSInteger)count {
    _question = question;
    _user = user;
    _totalVoteCount = count;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
