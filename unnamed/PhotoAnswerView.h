//
//  PhotoAnswerView.h
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Answer.h"

@interface PhotoAnswerView : UIView
- (void)setAnswer:(Answer *)answer andTotalVotes:(NSInteger)total;
@end
