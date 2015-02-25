//
//  ParseImage.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "UIImageView+Parse.h"
#import <Parse/Parse.h>
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (Parse)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageWithParseFile:(PFFile *)pffImage {

    [pffImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            self.image = image;
        }
    }];
}



@end
