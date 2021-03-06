//
//  User.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

extern NSString * const UserDidLogoutNotification;

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) PFUser *parseUser;

- (id)initWithPFUser:(PFUser *)user;
- (BOOL)isEqualUser:(User *)user;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;
+ (void)logout;
@end
