//
//  ComposeAnswerCell.h
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@class ComposeAnswerCell;
@protocol ComposeAnswerCellDelegate <NSObject>

-(void)composeAnswerCell:(ComposeAnswerCell *)cell changedAnswer:(Answer *)answer;

@end

@interface ComposeAnswerCell : UITableViewCell
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger answerIndex;
@property (nonatomic, strong) id<ComposeAnswerCellDelegate> delegate;
@end
