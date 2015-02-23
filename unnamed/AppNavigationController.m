//
//  AppNavigationController.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AppNavigationController.h"
#import "UIColor+AppColor.h"

@interface AppNavigationController ()

@end

@implementation AppNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor appTintColor],
                                                 NSForegroundColorAttributeName,
                                                 nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
