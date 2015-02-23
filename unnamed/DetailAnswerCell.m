//
//  DetailAnswerCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailAnswerCell.h"
#import "GRKBarGraphView.h"
#import "UIColor+AppColor.h"

@interface DetailAnswerCell()
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger totalVotes;

@property (weak, nonatomic) IBOutlet UILabel *answerIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet GRKBarGraphView *barGraph;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;

@end

@implementation DetailAnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.barGraph.barStyle = GRKBarStyleFromRight;
    self.barGraph.barColor = [UIColor appTintColor];
    self.barGraph.tintColor = [UIColor appTintColor];
    self.barGraph.contentMode = UIViewContentModeCenter;
    self.barGraph.animationDuration = 1;

    [self.selectionImage setImage:[UIImage imageNamed:@"answer_unselected"]];
}

- (void)layoutSubviews {
    self.answerIndexLabel.text = [NSString stringWithFormat:@"%ld.", (long)self.answer.index +1];
    self.answerLabel.text = self.answer.text;
    float percent = (float)self.answer.count / (float)self.totalVotes;
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percent * 100];
    self.barGraph.percent = percent;
}

- (void) initWithAnswer:(Answer *)answer totalVotes:(NSInteger)count {
    _answer = answer;
    _totalVotes = count;
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
