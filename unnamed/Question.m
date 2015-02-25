//
//  Question.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "Question.h"
#import <Parse/Parse.h>
#import "Answer.h"

NSInteger const resultCount = 20;

@implementation Question
@dynamic objectId;
@dynamic user;
@dynamic text;
@dynamic numAnswers;
@dynamic answerTexts;
@dynamic answerVoteCounts;
@dynamic anonymous;
@dynamic complete;
@dynamic createdAt;
@dynamic isTextSurvey;
@dynamic questionPhotos;

- (id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
        self.user = [PFUser currentUser];
        self.anonymous = NO;
        self.complete = NO;
    }
    return self;
}


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Question";
}

- (NSArray *)createAnswersFromQuestion {
    if (self.isTextSurvey) {
        return [self createTextAnswersFromQuestion];
    } else {
        return [self createPhotoAnswersFromQuestion];
    }
    
}

- (NSArray *)createTextAnswersFromQuestion {
    NSMutableArray *answers = [NSMutableArray array];
    for (int i = 0; i < self.numAnswers; i++) {
        Answer *answer = [[Answer alloc] init];
        answer.index = i;
        answer.count = [self.answerVoteCounts[i] integerValue];
        answer.text = self.answerTexts[i];
        [answers addObject:answer];
    }
    return answers;
}

- (NSArray *)createPhotoAnswersFromQuestion {
    NSMutableArray *answers = [NSMutableArray array];
    for (int i = 0; i < self.numAnswers; i++) {
        Answer *answer = [[Answer alloc] init];
        answer.index = i;
        answer.count = [self.answerVoteCounts[i] integerValue];
        switch (i) {
            case 0:
            {
                answer.photoFile = self.questionPhotos.answerPhoto1;
                break;
            }
            case 1:
            {
                answer.photoFile = self.questionPhotos.answerPhoto2;
                break;
            }
            case 2:
            {
                answer.photoFile = self.questionPhotos.answerPhoto1;
                break;
            }
            case 3:
            {
                answer.photoFile = self.questionPhotos.answerPhoto1;
                break;
            }
        }
        [answer.photoFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                answer.photo = [UIImage imageWithData:imageData];
            }
        }];

        
        [answers addObject:answer];
    }
    return answers;
}

- (NSInteger)getTotalVotes {
    NSInteger totalVotes = 0;
    for (int i = 0; i < self.numAnswers; i++) {
        totalVotes += [self.answerVoteCounts[i] integerValue];
    }
    return totalVotes;
}

@end
