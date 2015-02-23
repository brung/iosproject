//
//  DetailAnswerCell.h
//  unnamed
//
//  Created by Bruce Ng on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface DetailAnswerCell : UITableViewCell
@property (nonatomic, assign) BOOL isCurrentVote;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
- (void) initWithAnswer:(Answer *)answer totalVotes:(NSInteger)count;
@end
