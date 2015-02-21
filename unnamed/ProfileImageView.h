//
//  ProfileImageView.h
//  unnamed
//
//  Created by Bruce Ng on 2/20/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@class ProfileImageView;
@protocol ProfileImageViewDelegate <NSObject>

- (void)profileImageView:(ProfileImageView *)view tappedUser:(User *)user;

@end

@interface ProfileImageView : UIImageView
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) id<ProfileImageViewDelegate> delegate;
@property (nonatomic, assign) BOOL isEnabled;

@end
