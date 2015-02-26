//
//  DetailPhotoAnswerCell.m
//  unnamed
//
//  Created by Casing Chu on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailPhotoAnswerCell.h"
#import "UIColor+AppColor.h"
#import "GRKBarGraphView.h"

@interface DetailPhotoAnswerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoAnswerImageView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteImageView;
@property (weak, nonatomic) IBOutlet GRKBarGraphView *barGraphView;

@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger totalVotes;

- (void)displayVoteIcon;

@end

@implementation DetailPhotoAnswerCell

- (void)awakeFromNib {
    // Initialization code
    // Initialization code
    self.barGraphView.barStyle = GRKBarStyleFromBottom;
    self.barGraphView.barColor = [UIColor appTintColor];
    self.barGraphView.tintColor = [UIColor appTintColor];
    self.barGraphView.contentMode = UIViewContentModeCenter;
    self.barGraphView.animationDuration = 1;
    
    [self.selectionImage setImage:[UIImage imageNamed:@"answer_unselected"]];
}

- (void)layoutSubviews {
    float percent = self.totalVotes > 0 ? (float)self.answer.count / (float)self.totalVotes : 0;
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percent * 100];
    self.photoAnswerImageView.image = self.answer.photo;
    self.barGraphView.percent = percent;
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
