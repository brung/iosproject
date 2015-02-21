//
//  ProfileCell.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/19/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ProfileCell.h"
#import "ProfileImageView.h"

@interface ProfileCell()

//############################################################
@property (weak, nonatomic) IBOutlet ProfileImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileTitleLabel;

//############################################################
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answeredCountLabel;

//############################################################
//surveyOrderControl decides the order questions of a user is shown in the
//questionTableView
//[0]Recent - based on time the question is created
//[1]Open - still time order but only questions that hasn't been closed yet
//[2]Popular - based on the number of participants of a question
@property (weak, nonatomic) IBOutlet UISegmentedControl *surveyOrderControl;

@end


@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateContentWithPFUser:(PFUser *)user{
    self.profileUser = [[User alloc] initWithPFUser: user];
    self.profileImageView.user = self.profileUser;
    self.profileTitleLabel.text = self.profileUser.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
