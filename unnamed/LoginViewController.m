//
//  ViewController.m
//  FacebookDemo
//
//  Created by Timothy Lee on 10/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController () <FBLoginViewDelegate>

- (void)presentLoggedInViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.readPermissions = @[@"public_profile",@"read_stream",@"user_photos"];
    loginView.delegate = self;
    loginView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginViewDelegate methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self presentLoggedInViewController];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}

- (void)loginView:(FBLoginView *)loginView
      handleError:(NSError *)error {
    
}

#pragma mark - Private methods

- (void)presentLoggedInViewController {
    MainViewController *vc = [[MainViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
