//
//  PhotoAnswerCell.h
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "User.h"
#import "ProfileImageView.h"

@class PhotoAnswerCell;
@protocol PhotoAnswerCellDelegate <NSObject>

- (void) photoAnswerCell:(PhotoAnswerCell *)cell didClickOnUser:(User *)user;

@end

@interface PhotoAnswerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (nonatomic, strong) Survey *survey;
@property (nonatomic, strong) id<PhotoAnswerCellDelegate> delegate;

@end
