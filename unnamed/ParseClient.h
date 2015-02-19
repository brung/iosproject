//
//  ParseClient.h
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/Parse.h>
#import "Survey.h"
#import "Question.h"
#import "Answer.h"
#import "Vote.h"


@interface ParseClient : Parse
+ (void)getHomeSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
+ (void)getMySurveysComplete:(BOOL)complete onPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
+ (void)getMyAnsweredSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
+ (void)saveSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion;
+ (void)saveAnswerFromNSMutableArray:(NSMutableArray *)answers withCompletion:(void(^)(BOOL succeeded, NSError *error))completion;
@end
