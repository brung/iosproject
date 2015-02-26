//
//  DetailPhotoAnswerCell.h
//  unnamed
//
//  Created by Casing Chu on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface DetailPhotoAnswerCell : UITableViewCell

@property (nonatomic, assign) BOOL isCurrentVote;
@property (weak, nonatomic) IBOutlet UIImageView *selectionImage;
- (void) initWithAnswer:(Answer *)answer totalVotes:(NSInteger)count;

@end
