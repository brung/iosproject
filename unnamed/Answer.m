//
//  Answer.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Answer.h"
@interface Answer()<PFSubclassing>
@end

@implementation Answer
@dynamic objectId;
@dynamic surveyId;
@dynamic text;
@dynamic count;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Answer";
}

@end
