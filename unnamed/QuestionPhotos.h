//
//  QuestionPhotos.h
//  unnamed
//
//  Created by Bruce Ng on 2/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/Parse.h>

@interface QuestionPhotos : PFObject <PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFFile *answerPhoto1;
@property (nonatomic, strong) PFFile *answerPhoto2;
@property (nonatomic, strong) PFFile *answerPhoto3;
@property (nonatomic, strong) PFFile *answerPhoto4;
@end
