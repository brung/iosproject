//
//  Question.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

@interface Question : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, assign) BOOL complete;
@property (nonatomic, readonly) NSDate *createdAt;
@end
