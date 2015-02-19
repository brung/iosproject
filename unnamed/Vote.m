//
//  Vote.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Vote.h"

@implementation Vote
@dynamic objectId;
@dynamic userId;
@dynamic questionId;
@dynamic answerId;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Vote";
}

@end
