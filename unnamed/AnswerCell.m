//
//  AnswerCell.m
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AnswerCell.h"
#import "BarView.h"

@interface AnswerCell ()

@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet BarView *barView;

@end

@implementation AnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.answerLabel.preferredMaxLayoutWidth = self.answerLabel.frame.size.width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", self.index, answer.text];
    CGFloat percentage = self.total <= 0 ? 0.0 : 1.0f * answer.count / self.total;
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percentage * 100.0];
    self.barView.percentage = percentage;
}

@end
