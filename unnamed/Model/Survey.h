//
//  Survey.h
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"
#import "User.h"
#import "Answer.h"
#import "Vote.h"

@interface Survey : NSObject
@property (nonatomic, strong) Question *question;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, assign) BOOL voted;
@property (nonatomic, strong) NSString *votedAnswerId;

- (id)initWithQuestion:(Question *)question;
- (id)initWithQuestion:(Question *)question andUser:(User *)user;
- (id)initWithQuestion:(Question *)question andPFUser:(PFUser *)user;

@end
