//
//  ProfileViewController.h
//  unnamed
//
//  Created by Xiangyu Zhang on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileImageView.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) User *user;

- (ProfileImageView *)getMainProfileImageView;
@end
