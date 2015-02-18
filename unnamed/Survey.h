//
//  Survey.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>


@interface Survey : PFObject
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSArray *answers;
@property (nonatomic, assign) BOOL anonymous;
@property (nonatomic, readonly) NSDate *createdAt;

@end