//
//  User.m
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "User.h"

NSString * const PFObjectName = @"User";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User ()

@end

@implementation User


static User * _currentUser = nil;

+ (User *)currentUser {
    if (_currentUser == nil) {
        PFUser *user = [PFUser currentUser];
        _currentUser = [[User alloc] initWithPFUser:user];
    }
    return _currentUser;
}

+ (void)setCurrentUser:(User *)user {
    if (user == nil) {
        [PFUser logOut];
        _currentUser = nil;
    } else {
        _currentUser = user;
    }
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (id)initWithPFUser:(PFUser *)user {
    self = [super init];
    if (self) {
        self.parseUser = user;
        NSDictionary *profile = user[@"profile"];
        self.name = profile[@"name"];
        self.profileImageUrl = profile[@"pictureURL"];
    }
    return self;
}

- (BOOL)isEqualUser:(User *)user {
    return [self.parseUser.objectId isEqualToString:user.parseUser.objectId];
}

@end
