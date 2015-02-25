//
//  PhotoAnswerCollectionView.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotoAnswerCollectionView.h"
#import "Answer.h"

@interface PhotoAnswerCollectionView()
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, assign) NSInteger totalVotes;
@end

@implementation PhotoAnswerCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setAnswers:(NSArray *)answers andTotalVotes:(NSInteger)total {
    _answers = answers;
    _totalVotes = total;
    
    
    
    
}


@end
