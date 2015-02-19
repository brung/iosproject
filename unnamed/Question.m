//
//  Question.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Question.h"
#import <Parse/Parse.h>

NSInteger const resultCount = 20;

@implementation Question
@dynamic objectId;
@dynamic user;
@dynamic text;
@dynamic anonymous;
@dynamic complete;
@dynamic createdAt;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Survey";
}


@end
