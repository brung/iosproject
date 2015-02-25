//
//  ProfileCell.h
//  unnamed
//
//  Created by Xiangyu Zhang on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ProfileImageView.h"

@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (nonatomic, strong) User * user;
@end
