//
//  DetailCommentCell.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/26/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailCommentCell.h"
#import "ParseClient.h"
#import "User.h"
#import "ProfileImageView.h"
#import "NSDate+MinimalTimeAgo.h"

@interface DetailCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation DetailCommentCell

- (void)awakeFromNib {
    // Initialization code
    self.commentLabel.preferredMaxLayoutWidth = self.commentLabel.frame.size.width;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

- (void)layoutSubviews {
    User *user = [[User alloc] initWithPFUser:self.comment.user];
    self.nameLabel.text = user.name;
    self.commentLabel.text = self.comment.text;
    self.dateLabel.text = [self.comment.createdAt timeAgo];
    self.profileImageView.user = user;
}
@end
