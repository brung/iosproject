//
//  Comment.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/25/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Comment.h"

@implementation Comment
@dynamic objectId;
@dynamic user;
@dynamic questionId;
@dynamic text;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Comment";
}

@end
