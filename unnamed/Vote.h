//
//  Vote.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>
#import "Question.h"
#import "Answer.h"

@interface Vote : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) Answer *answer;

@end
