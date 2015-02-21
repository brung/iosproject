//
//  AnswerView.m
//  unnamed
//
//  Created by Casing Chu on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AnswerView.h"
#import "BarView.h"

@interface AnswerView ()
@property (weak, nonatomic) IBOutlet BarView *barView;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;

@end

@implementation AnswerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)baseInit {
    UINib *nib = [UINib nibWithNibName:@"AnswerView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    
    self.containerView.frame = self.bounds;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.containerView];
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

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", self.index, answer.text];
    CGFloat percentage = self.total <= 0 ? 0.0 : 1.0f * answer.count / self.total;
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percentage * 100.0];
    self.barView.percentage = percentage;
    
    [self setNeedsLayout];
}

@end
