//
//  DetailGraphCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "DetailGraphCell.h"
#import "GRKBarGraphView.h"
#import "UIColor+AppColor.h"

@interface DetailGraphCell()
@property (weak, nonatomic) IBOutlet GRKBarGraphView *barGraph;
@property (weak, nonatomic) IBOutlet UILabel *graphLabel;
@property (nonatomic, strong) NSString *answerLabel;
@property (nonatomic, assign) float percent;

@end

@implementation DetailGraphCell

- (void)awakeFromNib {
    // Initialization code
    self.barGraph.barStyle = GRKBarStyleFromLeft;
    self.barGraph.barColor = [UIColor appTintColor];
    self.barGraph.tintColor = [UIColor appTintColor];
    self.barGraph.contentMode = UIViewContentModeCenter;
    self.barGraph.animationDuration = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}


- (void)setGraphData:(GraphData *)graphData {
    _graphData = graphData;
    self.graphLabel.text = [NSString stringWithFormat:@"%ld", graphData.answer.index+1];
    self.percent = (float)graphData.answer.count / (float)graphData.totalVotes;
    
    
    self.barGraph.percent = self.percent;
    
}


@end
