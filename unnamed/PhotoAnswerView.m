//
//  PhotoAnswerView.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "PhotoAnswerView.h"
#import "GRKBarGraphView.h"
#import "UIColor+AppColor.h"
#import "ParseClient.h"

@interface PhotoAnswerView()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet GRKBarGraphView *barView;
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger totalVotes;

@end


@implementation PhotoAnswerView

- (void)setup {
    UINib *nib = [UINib nibWithNibName:@"PhotoAnswerView" bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:self options:nil];
    //    NSLog(@"Nib Objects Count: %ld", objects.count);
    //    NSLog(@"Height: %f, Width: %f", self.containerView.frame.size.height, self.containerView.frame.size.width);
    
    // Setup GKBarGraphView
    self.barView.barStyle = GRKBarStyleFromRight;
    self.barView.barColor = [UIColor appTintColor];
    self.barView.tintColor = [UIColor appTintColor];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setAnswer:(Answer *)answer andTotalVotes:(NSInteger)total {
    _answer = answer;
    _totalVotes = total;
    [ParseClient setImageView:self.photoView fromAnswer:self.answer];
    float percent = total > 0 ? (float)answer.count / (float)total : 0;
    self.barView.percent = percent;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
