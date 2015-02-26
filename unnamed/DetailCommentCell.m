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

@interface DetailCommentCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

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
    self.commentLabel.text = comment.text;
}

@end
