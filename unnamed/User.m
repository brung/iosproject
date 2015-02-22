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

//+ (User *)getUserById:(NSString *)userId {
//    PFQuery *query = [PFQuery queryWithClassName:PFObjectName];
//    [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
//        if (!error) {
//            NSDictionary *dict = object[@"profile"];
//            User *user = [[User alloc] initWithDictionary:dict];
//            return user;
//        } else {
//            NSLog(@"Unable to retrieve user %@", userId)
//        }
//    }];
//    return nil;
//}

- (id)initWithPFUser:(PFUser *)user {
    self = [super init];
    if (self) {
        self.objectId = user.objectId;
        NSDictionary *profile = user[@"profile"];
        self.name = profile[@"name"];
        self.profileImageUrl = profile[@"pictureURL"];
    }
    return self;
}

@end
