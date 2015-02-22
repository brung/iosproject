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
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray *answerViews;

@property (nonatomic, assign) CGFloat answerHeight;
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
    self.answerHeight = 18.0;
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

- (void)setAnswers:(NSArray *)answers andTotal:(NSInteger)total {
    _answers = answers;
    _total = total;
    for (AnswerView *view in self.answerViews) {
        [view removeFromSuperview];
    }
    [self.answerViews removeAllObjects];
    
    int count = 1;
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
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.answerHeight * self.answerViews.count);
    
    for (int i=0;i<self.answerViews.count;i++) {
        AnswerView *view = self.answerViews[i];
//        NSLog(@"Height: %f, Width: %f", view.frame.size.height, view.frame.size.width);
        NSLog(@"Height: %f, Width: %f", self.frame.size.height, self.frame.size.width);
        CGFloat y = self.answerHeight * i;
        NSLog(@"y pos: %f", y);
        CGRect imageFrame = CGRectMake(0, y, self.frame.size.width, self.answerHeight);
        view.frame = imageFrame;
    }
    
}

#pragma mark - Private Methods

@end
