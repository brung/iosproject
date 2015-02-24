//
//  ComposePhotoCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/23/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ComposePhotoCell.h"
#import "UIColor+AppColor.h"
@interface ComposePhotoCell()
@property (weak, nonatomic) IBOutlet UILabel *addPhotoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@end

@implementation ComposePhotoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews {
    if (self.answer && self.answer.photo) {
        [self.photoView setImage:self.answer.photo];
        self.photoView.alpha = 1;
        self.addPhotoLabel.alpha = 0;
    } else {
        self.photoView.alpha = 0;
        self.addPhotoLabel.alpha = 1;
    }
}

@end
