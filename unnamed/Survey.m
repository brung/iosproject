//
//  Survey.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Survey.h"
@interface Survey ()<PFSubclassing>

@end

@implementation Survey
@dynamic objectId;
@dynamic user;
@dynamic text;
@dynamic answers;
@dynamic anonymous;
@dynamic createdAt;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Survey";
}

@end
