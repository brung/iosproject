//
//  GrayBarButtonItem.m
//  unnamed
//
//  Created by Bruce Ng on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "GrayBarButtonItem.h"

@implementation GrayBarButtonItem
- (void) setup {
    [self  setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:
     [UIColor lightGrayColor],
     NSForegroundColorAttributeName,
     nil]
    forState:UIControlStateNormal];
}

- (id) initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action {
    self = [super initWithBarButtonSystemItem:systemItem target:target action:action];
    [self setup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self setup];
    return self;
}

- (id)init {
    self = [super init];
    [self setup];
    return self;
}

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    self = [super initWithTitle:title style:style target:target action:action];
    [self setup];
    return self;
}

- (id)initWithCustomView:(UIView *)customView {
    self = [super initWithCustomView:customView];
    [self setup];
    return self;
}

- (id)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    self = [super initWithImage:image style:style target:target action:action];
    [self setup];
    return self;
}

- (id)initWithImage:(UIImage *)image landscapeImagePhone:(UIImage *)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    self = [super initWithImage:image landscapeImagePhone:landscapeImagePhone style:style target:target action:action];
    [self setup];
    return self;
}

@end
