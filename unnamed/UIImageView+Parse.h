//
//  ParseImage.h
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UIImageView (Parse)
- (void)setImageWithParseFile:(PFFile *)pffImage;
@end
