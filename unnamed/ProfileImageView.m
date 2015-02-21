//
//  ProfileImageView.m
//  unnamed
//
//  Created by Bruce Ng on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ProfileImageView.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@implementation ProfileImageView
- (void) setup {
    self.isEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTap:)];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:tapGesture];
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.clipsToBounds = YES;
}

- (void)setUser:(User *)user {
    _user = user;
    [self setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onImageTap:(UITapGestureRecognizer *)sender {
    if (self.isEnabled) {
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
        [self.delegate profileImageView:self tappedUser:self.user];
    }
}

@end
