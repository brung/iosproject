//
//  CommentView.m
//  unnamed
//
//  Created by Casing Chu on 2/23/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "CommentView.h"

@interface CommentView ()
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation CommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup {
    UINib *nib = [UINib nibWithNibName:@"CommentView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    //    NSLog(@"Nib Objects Count: %ld", objects.count);
    //    NSLog(@"Height: %f, Width: %f", self.containerView.frame.size.height, self.containerView.frame.size.width);
    
    // Setup ContainerView
    self.containerView.frame = self.bounds;
    [self.containerView setTranslatesAutoresizingMaskIntoConstraints:YES];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.containerView];
    [self setNeedsLayout];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self setup];
    }
    return self;
}

//- (void)setAnswer:(Answer *)answer {
//    _answer = answer;
//    self.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", self.index, answer.text];
//    CGFloat percentage = self.total <= 0 ? 0.0 : 1.0f * answer.count / self.total;
//    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percentage * 100.0];
//    self.barView.percent = percentage;
//    
//    [self setNeedsLayout];
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.containerView.frame = self.bounds;

}

@end
