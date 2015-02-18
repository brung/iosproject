//
//  Vote.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFObject+Subclass.h>

@interface Vote : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *surveyId;
@property (nonatomic, strong) NSString *answerId;

@end
