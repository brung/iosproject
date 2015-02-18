//
//  Answer.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>
#import "Survey.h"

@interface Answer : PFObject
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *surveyId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger count;
@end
