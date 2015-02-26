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
#import "Vote.h"
#import "Answer.h"
#import "User.h"
#import "Comment.h"

extern NSString * const UserDidPostNewSurveyNotification;
extern NSString * const UserDidPostUpdateSurveyNotification;
extern NSInteger const ResultCount;

@interface ParseClient : Parse
+ (void)getHomeSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
+ (void)getUser:(User *)user surveysComplete:(BOOL)complete onPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
//+ (void)getMyAnsweredSurveysOnPage:(NSInteger)page withCompletion:(void(^)(NSArray *surveys, NSError *error))completion;
+ (void)saveTextSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion;
+ (void)savePhotoSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion;
+ (void)saveVoteOnSurvey:(Survey *)survey withAnswer:(Answer *)answer withCompletion:(void(^)(Survey *survey, NSError *error))completion;
+ (void)setImageView:(UIImageView *)iView fromAnswer:(Answer *)answer;

+ (void)saveComment:(Comment *)comment withCompletion:(void(^)(NSError *error))completion;
+ (void)getCommentsOnSurvey:(Survey *)survey withCompletion:(void(^)(NSArray *comments, NSError *error))completion;
@end
