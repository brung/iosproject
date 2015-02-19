//
//  AnswerCell.h
//  unnamed
//
//  Created by Casing Chu on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerCell : UITableViewCell

@property (nonatomic, strong) Answer* answer;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;

@end
