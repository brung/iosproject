    //
//  ParseClient.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ParseClient.h"

static ParseClient *_instance;

@implementation ParseClient
+ (ParseClient *)sharedInstance {
    if (!_instance) {
        _instance = [[ParseClient alloc] init];
    }
    return _instance;
}

+ (void)saveSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion{
    NSMutableArray *validAnswers = [NSMutableArray array];
    for (Answer *answer in survey.answers) {
        if ([answer.text length] >= 1) {
            [validAnswers addObject:answer];
        }
    }
    if ([survey.question.text length] >= 8 && validAnswers.count >= 2) {
        //Submit question
        survey.question.anonymous = NO;
        survey.question.complete = NO;
        [survey.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                for (Answer *answer in validAnswers) {
                    answer.questionId = survey.question.objectId;
                }
                [ParseClient saveAnswerFromNSMutableArray:validAnswers withCompletion:completion];
            } else {
                NSLog(@"unable to save question");
                completion(NO, error);
            }
        }];
    }
}

+ (void)saveAnswerFromNSMutableArray:(NSMutableArray *)answers withCompletion:(void(^)(BOOL succeeded, NSError *error))completion {
    if (answers.count < 1) {
        completion(YES, nil);
        return;
    }
    
    Answer *answer = [answers lastObject];
    [answers removeLastObject];
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [ParseClient saveAnswerFromNSMutableArray:answers withCompletion:(completion)];
        } else {
            completion(NO, error);
        }
    }];
    
}

@end
