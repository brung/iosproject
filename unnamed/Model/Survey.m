//
//  Survey.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Survey.h"

@implementation Survey
- (BOOL)isCurrentVoteAnswer:(Answer *)answer {
    return [self.vote.answer.objectId isEqualToString:answer.objectId];
}

- (id)initWithQuestion:(Question *)question {
    self = [super init];
    if (self) {
        self.question = question;
    }
    return self;
}

- (id)initWithQuestion:(Question *)question andPFUser:(PFUser *)user {
    self = [super init];
    if (self) {
        self.question = question;
        self.user = [[User alloc] initWithPFUser:user];
    }
    return self;
}


- (id)initWithQuestion:(Question *)question andUser:(User *)user {
    self = [super init];
    if (self) {
        self.question = question;
        self.user = user;
    }
    return self;
}
@end
