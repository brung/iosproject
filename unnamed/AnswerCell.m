//
//  AnswerCell.m
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.answerLabel.preferredMaxLayoutWidth = self.answerLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
