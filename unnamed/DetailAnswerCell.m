//
//  DetailAnswerCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailAnswerCell.h"

@interface DetailAnswerCell()
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@end

@implementation DetailAnswerCell

- (void)awakeFromNib {
    // Initialization code
    [self.selectionImage setImage:[UIImage imageNamed:@"answer_unselected"]];
}

- (void)layoutSubviews {
    
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)self.index, self.answer.text];
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", (long)self.index, self.answer.text];
}

- (void)setIsCurrentVote:(BOOL)isCurrentVote {
    _isCurrentVote = isCurrentVote;
    [self displayVoteIcon];
}

- (void) displayVoteIcon {
    if (self.isCurrentVote) {
        [self.selectionImage setImage:[UIImage imageNamed:@"answer_selected"]];
    } else {
        [self.selectionImage setImage:[UIImage imageNamed:@"answer_unselected"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
