//
//  AnswerCollectionView.m
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AnswerCollectionView.h"
#import "AnswerView.h"
#import "Answer.h"

@interface AnswerCollectionView ()

@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *answerViews;

- (NSInteger)getTotalFromAnswers:(NSArray *)answers;

@end

@implementation AnswerCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInit {
    self.answerViews = [[NSMutableArray alloc] init];
    self.total = 0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void)setAnswers:(NSArray *)answers {
    _answers = answers;
    _total = [self getTotalFromAnswers:answers];
    
    int count = 1;
    [self.answerViews removeAllObjects];
    for (Answer *answer in self.answers) {
        AnswerView *view = [[AnswerView alloc] init];
        view.index = count;
        view.total = self.total;
        view.answer = answer;
        count++;
        [self.answerViews addObject:view];
        [self addSubview:view];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (int i=0;i<self.answerViews.count;i++) {
        AnswerView *view = self.answerViews[i];
        CGRect imageFrame = CGRectMake(0, view.frame.size.height * i, self.frame.size.width, self.frame.size.height);
        view.frame = imageFrame;
    }
    
}

#pragma mark - Private Methods
- (NSInteger)getTotalFromAnswers:(NSArray *)answers {
    NSInteger total = 0;
    for (Answer *ans in answers) {
        total += ans.count;
    }
    return total;
}

@end
