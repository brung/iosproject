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
    return (self.voted && self.vote.answerIndex  == answer.index);
}

- (id)initWithQuestion:(Question *)question {
    self = [super init];
    if (self) {
        self.question = question;
        self.user = [[User alloc] initWithPFUser:question.user];
        self.answers = [question createAnswersFromQuestion];
        self.totalVotes = [question getTotalVotes];
    }
    return self;
}
@end
