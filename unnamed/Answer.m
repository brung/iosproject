//
//  Answer.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Answer.h"

@implementation Answer
@dynamic objectId;
@dynamic questionId;
@dynamic text;
@dynamic count;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Answer";
}

@end
