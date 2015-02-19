//
//  AppDelegate.h
//  unnamed
//
//  Created by Bruce Ng on 2/16/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarMenuViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (TabBarMenuViewController *)tabBarMenuViewController;

@end

