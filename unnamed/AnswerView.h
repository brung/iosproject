//
//  AnswerView.h
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface AnswerView : UIView

@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger index;

@end
