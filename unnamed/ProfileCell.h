//
//  ProfileCell.h
//  unnamed
//
//  Created by Xiangyu Zhang on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileCell : UITableViewCell

- (void)updateContentWithPFUser:(PFUser *)user;

@end
