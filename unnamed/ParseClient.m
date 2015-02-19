//
//  ParseClient.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ParseClient.h"
#import "Question.h"
#import "Answer.h"
#import "Vote.h"
#import "Survey.h"

static ParseClient *_instance;

@implementation ParseClient
+ (ParseClient *)sharedInstance {
    if (!_instance) {
        _instance = [[ParseClient alloc] init];
    }
    return _instance;
}

+ (void)saveSurvey:(Survey *)survey withCompletion:(void(^)(BOOL succeeded, NSError *error))completion{
//    NSMutableArray *validAnswers = [NSMutableArray array];
//    for (Answer *answer in self.answers) {
//        if ([answer.text length] >= 1) {
//            [validAnswers addObject:answer];
//        }
//    }
//    if ([self.questionText.text length] >= 8 && validAnswers.count >= 2) {
//        //Submit question
//        Survey *survey = [[Survey alloc] init];
//        survey.text = self.questionText.text;
//        survey.anonymous = NO;
//        survey.complete = NO;
//
//    [survey.question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//            NSString *questionId = survey.question.objectId;
//            for (int count = 0; count < validAnswers.count; count++) {
//                Answer *answer = validAnswers[count];
//                answer.surveyId = surveyId;
//                [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (!error) {
//                        // NEed to do something
//                        if(count == validAnswers.count-1) {
//                            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                        }
//                    } else {
//                        NSLog(@"unable to save answer");
//                        [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:[NSString stringWithFormat:@"Unable to save this survey at this time. Please try again. (%d)", count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//                    }
//                }];
//            }
//        } else {
//            NSLog(@"unable to save question");
//            [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"Unable to save at this time. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//        }
//    }];
}

@end
