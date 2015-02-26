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
#import "NSDate+MinimalTimeAgo.h"
#import "UIImageView+AFNetworking.h"

@interface DetailCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commenterImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;

@property (nonatomic, strong) NSString * commenterImageUrl;
@property (nonatomic, strong) NSString * commentCreateTime;

@end

@implementation DetailCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithComment:(Comment *)comment{
    User *user = [[User alloc] initWithPFUser:comment.user];
    self.nameLabel.text = user.name;
    //self.commenterImageUrl = user.profileImageUrl;
    //self.commentCreateTime = [comment.createdAt timeAgo];
    //NSLog(@" user iamge url is %@, comment created at %@", self.commenterImageUrl, self.commentCreateTime );
    self.commentTimeLabel.text = [comment.createdAt timeAgo];
    [self.commenterImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.commentLabel.text = comment.text;
}

@end
