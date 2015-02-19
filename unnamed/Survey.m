//
//  Survey.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Survey.h"
#import <Parse/Parse.h>
@interface Survey ()

@end

@implementation Survey
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

- (void)saveWithCompletion:(void(^)(BOOL succeeded, NSError *error))completion {
    self.user = [PFUser currentUser];
    [self saveInBackgroundWithBlock:completion];
}

@end
