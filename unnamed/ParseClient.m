    //
//  ParseClient.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ParseClient.h"

NSString * const UserDidPostNewSurveyNotification = @"kUserDidPostNewSurveyNotification";
NSString * const UserDidPostUpdateSurveyNotification = @"kUserDidPostUpdateSurveyNotification";
NSInteger const ResultCount = 8;

@implementation ParseClient
//+ (void)getMyAnsweredSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
//    
//    PFQuery *voteQuery = [Vote query];
//    [voteQuery orderByAscending:@"createdAt"];
//    [voteQuery whereKey:@"user" equalTo:[PFUser currentUser]];
//    [voteQuery includeKey:@"question"];
//    voteQuery.skip = page * ResultCount;
//    voteQuery.limit = ResultCount;
//    
//    PFQuery *query = [Question query];
//    [query whereKey:@"objectId" matchesKey:@"questionId" inQuery:voteQuery];
//    [query includeKey:@"user"];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            [ParseClient getAnswersForQuestions:objects withResults:[NSMutableArray array] andCompletion:completion];            
//        } else {
//            completion([NSArray array], error);
//        }
//    }];
//}

+ (void)getUser:(User *)user surveysComplete:(BOOL)complete onPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    if (!user || !user.parseUser) {
        completion([NSArray array], [[NSError alloc] initWithDomain:@"No user found" code:909 userInfo:nil]);
        return;
    }
    PFQuery *query = [Question query];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:user.parseUser];
    [query includeKey:@"user"];
    [query includeKey:@"questionPhotos"];
    [query whereKey:@"complete" equalTo:@(complete)];
    query.skip = page * ResultCount;
    query.limit = ResultCount;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ParseClient getMyVotesForQuestions:objects withCompletion:completion];
        } else {
            completion([NSArray array], error);
        }
    }];
}

+ (void)getHomeSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    PFQuery *query = [Question query];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"questionPhotos"];
    query.skip = page * ResultCount;
    query.limit = ResultCount;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ParseClient getMyVotesForQuestions:objects withCompletion:completion];
        } else {
            completion([NSArray array], error);
        }
    }];
}

+ (void)getMyVotesForQuestions:(NSArray *)questions withCompletion:(void(^)(NSArray *surveys, NSError *error))completion {
    NSMutableArray *questionIds = [NSMutableArray array];
    for (Question *question in questions) {
        [questionIds addObject:question.objectId];
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
            NSMutableArray *surveys = [NSMutableArray array];
            for (Question *question in questions) {
                Survey *survey = [[Survey alloc] initWithQuestion:question];
                Vote *vote = votesDict[survey.question.objectId];
                if (vote) {
                    survey.voted = YES;
                    survey.vote = vote;
                } else {
                    survey.voted =NO;
                }
                [surveys addObject:survey];
            }
            completion(surveys, nil);
            
        } else {
            completion([NSArray array], error);
        }
    }];
}


+ (void)saveTextSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion{
    NSMutableArray *validAnswers = [NSMutableArray array];
    for (Answer *answer in survey.answers) {
        if ([answer.text length] >= 1) {
            [validAnswers addObject:answer.text];
        }
    }
    if ([survey.question.text length] >= 8 && validAnswers.count >= 2) {
        //Submit question
        survey.question.anonymous = NO;
        survey.question.complete = NO;
        survey.question.numAnswers = validAnswers.count;
        survey.answers = validAnswers;
        NSMutableArray *counts = [NSMutableArray array];
        for (int i = 0; i < validAnswers.count; i++) {
            [counts addObject:@(0)];
        }
        survey.question.answerVoteCounts = counts;
        survey.question.answerTexts = [NSArray arrayWithArray:validAnswers];
        [survey.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                completion(YES, nil);
            } else {
                NSLog(@"unable to save question");
                completion(NO, error);
            }
        }];
    }
}

+ (void)savePhotoSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion{
    NSMutableArray *validAnswers = [NSMutableArray array];
    for (Answer *answer in survey.answers) {
        if (answer.photo) {
            [validAnswers addObject:answer.photo];
        }
    }
    if ([survey.question.text length] >= 8 && validAnswers.count >= 2) {
        //Submit question
        survey.question.anonymous = NO;
        survey.question.complete = NO;
        survey.question.numAnswers = validAnswers.count;
        survey.answers = validAnswers;
        NSMutableArray *counts = [NSMutableArray array];
        for (int i = 0; i < validAnswers.count; i++) {
            [counts addObject:@(0)];
        }
        survey.question.answerVoteCounts = counts;
        QuestionPhotos *questionPhotos = [[QuestionPhotos alloc] init];
        for (int i = 0; i < validAnswers.count && i < 4; i++) {
            NSData *imageData = UIImagePNGRepresentation(validAnswers[i]);
            switch (i) {
                case 0:
                {
                    PFFile *imageFile = [PFFile fileWithName:@"answer1.png" data:imageData];
                    questionPhotos.answerPhoto1 = imageFile;
                    break;
                }
                case 1:
                {
                    PFFile *imageFile = [PFFile fileWithName:@"answer2.png" data:imageData];
                    questionPhotos.answerPhoto2 = imageFile;
                    break;
                }
                case 2:
                {
                    PFFile *imageFile = [PFFile fileWithName:@"answer3.png" data:imageData];
                    questionPhotos.answerPhoto3 = imageFile;
                    break;
                }
                case 3:
                {
                    PFFile *imageFile = [PFFile fileWithName:@"answer4.png" data:imageData];
                    questionPhotos.answerPhoto4 = imageFile;
                    break;
                }
                default:
                    break;
            }
        }
        [questionPhotos saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                survey.question.questionPhotos = questionPhotos;
                [survey.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        completion(YES, nil);
                    } else {
                        NSLog(@"unable to save question");
                        completion(NO, error);
                    }
                }];
            } else {
                completion(NO, error);
            }
        }];
    } else {
        completion([NSArray array], [[NSError alloc] initWithDomain:@"Not enough valid answers for question" code:500 userInfo:nil]);
        return;
    }
}

+ (void)saveVoteOnSurvey:(Survey *)survey withAnswer:(Answer *)answer withCompletion:(void(^)(Survey *survey, NSError *error))completion {
    Vote *vote =[[Vote alloc] init];
    NSInteger oldAnswerIndex = -1;
    if (survey.vote) {
        vote = survey.vote;
        oldAnswerIndex = vote.answerIndex;
    }
    vote.answerIndex = answer.index;
    vote.user = [PFUser currentUser];
    vote.questionId = survey.question.objectId;
    [vote saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [ParseClient updateVoteCountOnSurvey:survey oldAnswerIndex:oldAnswerIndex newVote:vote withCompletion:completion];
        } else {
            completion(nil, error);
        }
    }];
}

+ (void)updateVoteCountOnSurvey:(Survey *)survey oldAnswerIndex:(NSInteger)oldIndex newVote:(Vote *)vote withCompletion:(void(^)(Survey *survey, NSError *error))completion{
    NSMutableArray *newCounts = [NSMutableArray arrayWithArray:survey.question.answerVoteCounts];
    
    NSInteger count = [newCounts[vote.answerIndex] integerValue];
    count++;
    newCounts[vote.answerIndex] = @(count);
    Answer* newAnswer = survey.answers[vote.answerIndex];
    newAnswer.count = count;
    survey.totalVotes++;

    if (oldIndex >= 0) {
        count = [newCounts[oldIndex] integerValue] - 1;
        if (count < 0) count = 0;
        newCounts[oldIndex] = @(count);
        Answer* oldAnswer = survey.answers[oldIndex];
        oldAnswer.count = count;
        survey.totalVotes--;
    }
    
    survey.question.answerVoteCounts = newCounts;
    survey.totalVotes = [survey.question getTotalVotes];//Update Total Vote Count
    [survey.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            survey.voted = YES;
            survey.vote = vote;
            completion(survey, nil);
        } else {
            // NEed to delete saved vote;
        }
    }];
}

@end
