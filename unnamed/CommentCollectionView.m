//
//  CommentCollectionView.m
//  unnamed
//
//  Created by Casing Chu on 2/23/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "CommentCollectionView.h"
#import "CommentView.h"

@interface CommentCollectionView ()

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *commentViews;
@property (nonatomic, assign) CGFloat commentHeight;

@end

@implementation CommentCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setup {
    self.commentViews = [[NSMutableArray alloc] init];
    self.commentHeight = 20.0;
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

- (void)setComments:(NSArray *)comments {
    _comments = comments;
    
    for (CommentView *view in self.commentViews) {
        [view removeFromSuperview];
    }
    [self.commentViews removeAllObjects];

    int count = 1;
    for (int i=0;i<comments.count;i++) {
        CommentView *view = [[CommentView alloc] init];
        count++;
        [self.commentViews addObject:view];
        [self addSubview:view];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int verticalOffset = 16;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,
                            self.commentHeight * self.commentViews.count +
                            (self.commentViews.count > 0 ? verticalOffset * 2 : 0));
    for (int i=0;i<self.commentViews.count;i++) {
        CommentView *view = self.commentViews[i];
//        NSLog(@"Height: %f, Width: %f", view.frame.size.height, view.frame.size.width);
//        NSLog(@"Height: %f, Width: %f", self.frame.size.height, self.frame.size.width);
        CGFloat y = self.commentHeight * i + verticalOffset;
//        NSLog(@"y pos: %f", y);
        CGRect imageFrame = CGRectMake(0, y, self.frame.size.width, self.commentHeight);
        view.frame = imageFrame;
    }
    
}


@end
