//
//  QuestionPhotos.m
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "QuestionPhotos.h"

@implementation QuestionPhotos
@dynamic objectId;
@dynamic answerPhoto1;
@dynamic answerPhoto2;
@dynamic answerPhoto3;
@dynamic answerPhoto4;

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"QuestionPhotos";
}
@end
