    //
//  ParseClient.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ParseClient.h"

NSInteger const ResultCount = 20;

@implementation ParseClient
+ (void)getHomeSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion{
    PFQuery *query = [Question query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.skip = page * ResultCount;
    query.limit = ResultCount;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ParseClient getAnswersForQuestions:objects withResults:[NSMutableArray array] andCompletion:completion];
        } else {
            completion([NSArray array], error);
        }
    }];
}

+ (void)getAnswersForQuestions:(NSArray *)questions withResults:(NSMutableArray *)surveys andCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    if (questions.count < 1) {
        completion(surveys, nil);
        return;
    }
    NSMutableArray *mutableQuestions = [NSMutableArray arrayWithArray:questions];
    Question *question = [mutableQuestions lastObject];
    [mutableQuestions removeLastObject];
    PFQuery *query = [Answer query];
    [query whereKey:@"questionId" equalTo:question.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            Survey *survey = [[Survey alloc] init];
            survey.question = question;
            survey.user = [[User alloc] initWithPFUser:question.user];
            survey.answers = objects;
            [surveys addObject:survey];
            [ParseClient getAnswersForQuestions:mutableQuestions withResults:surveys andCompletion:completion];
        } else {
            completion([NSArray array], error);
        }
    }];    
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
