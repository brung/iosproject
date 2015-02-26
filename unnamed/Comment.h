//
//  Comment.h
//  unnamed
//
//  Created by Xiangyu Zhang on 2/25/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "Question.h"


@interface Comment : PFObject<PFSubclassing>

+ (NSString *)parseClassName;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *text;

@end