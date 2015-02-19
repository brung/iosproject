//
//  Answer.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/PFObject+Subclass.h>

@interface Answer : PFObject<PFSubclassing>
+ (NSString *)parseClassName;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSString *questionId;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSInteger count;
@end
