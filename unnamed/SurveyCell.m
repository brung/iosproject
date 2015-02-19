//
//  SurveyCell.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyCell.h"

@interface SurveyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *percentALabel;
@property (weak, nonatomic) IBOutlet UILabel *answerALabel;
@property (weak, nonatomic) IBOutlet UILabel *percentBLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerBLabel;
@property (weak, nonatomic) IBOutlet UIView *percentCLabel;
@property (weak, nonatomic) IBOutlet UIView *answerCLabel;
@property (weak, nonatomic) IBOutlet UIView *percentDLabel;
@property (weak, nonatomic) IBOutlet UIView *answerDLabel;

@end

@implementation SurveyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
