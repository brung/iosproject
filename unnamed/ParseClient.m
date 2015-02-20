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
+ (void)getMyAnsweredSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    
    PFQuery *voteQuery = [Vote query];
    [voteQuery orderByDescending:@"createdAt"];
    [voteQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [voteQuery includeKey:@"question"];
    voteQuery.skip = page * ResultCount;
    voteQuery.limit = ResultCount;
    
    PFQuery *query = [Question query];
    [query whereKey:@"objectId" matchesKey:@"questionId" inQuery:voteQuery];
    [query includeKey:@"user"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ParseClient getAnswersForQuestions:objects withResults:[NSMutableArray array] andCompletion:completion];            
        } else {
            completion([NSArray array], error);
        }
    }];
}

+ (void)getMySurveysComplete:(BOOL)complete onPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    PFQuery *query = [Question query];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"user"];
    [query whereKey:@"complete" equalTo:complete ? @"true" : @"false"];
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

+ (void)getHomeSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
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
        [ParseClient getVotesForSurveys:surveys withCompletion:completion];
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
            Survey *survey = [[Survey alloc] initWithQuestion:question andPFUser:question.user];
            survey.answers = objects;
            [surveys addObject:survey];
            [ParseClient getAnswersForQuestions:mutableQuestions withResults:surveys andCompletion:completion];
        } else {
            completion(surveys, error);
        }
    }];    
}

+ (void)getVotesForSurveys:(NSArray *)surveys withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    NSMutableArray *questionIds = [NSMutableArray array];
    for (Survey *survey in surveys) {
        [questionIds addObject:survey.question.objectId];
    }
    PFQuery *query = [Vote query];
    [query whereKey:@"questionId" containedIn:questionIds];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"answer"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableDictionary *votesDict = [NSMutableDictionary dictionary];
            for (Vote *vote in objects) {
                [votesDict setObject:vote forKey:vote.questionId];
            }
            for (Survey *survey in surveys) {
                Vote *vote = votesDict[survey.question.objectId];
                if (vote) {
                    survey.voted = YES;
                    survey.votedAnswerId = vote.answer.objectId;
                } else {
                    survey.voted =NO;
                }
            }
            completion(surveys, nil);
            
        } else {
            completion(surveys, error);
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

+ (void)saveVoteOnSurvey:(Survey *)survey withAnswer:(Answer *)answer withCompletion:(void(^)(BOOL succeeded, NSError *error))completion {
    Vote *vote = [[Vote alloc] init];
    vote.answer = answer;
    vote.user = [PFUser currentUser];
    vote.questionId = survey.question.objectId;
    [vote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            survey.voted = YES;
            survey.votedAnswerId = answer.objectId;
            completion(YES, nil);
        } else {
            completion(NO, error);
        }
    }];
}

@end
