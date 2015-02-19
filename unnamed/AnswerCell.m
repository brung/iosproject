//
//  AnswerCell.m
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AnswerCell.h"

@interface AnswerCell ()

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation AnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.answerLabel.preferredMaxLayoutWidth = self.answerLabel.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", self.index, answer.text];
    NSInteger percentage = self.total <= 0 ? 0 : 100.0f * answer.count / self.total;
    self.percentLabel.text = [NSString stringWithFormat:@"%ld%%", percentage];
}

@end
