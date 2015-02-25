//
//  ViewController.m
//  FacebookDemo
//
//  Created by Timothy Lee on 10/22/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppDelegate.h"
#import "AppNavigationController.h"
#import "HomeViewController.h"

@interface LoginViewController () <FBLoginViewDelegate>

- (void)presentLoggedInViewController;

@end

@implementation LoginViewController

#pragma mark Init

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Facebook Profile";
    }
    return self;
}

#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.readPermissions = @[@"public_profile",@"read_stream",@"user_photos"];
//    loginView.delegate = self;
//    loginView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//    loginView.center = self.view.center;
//    [self.view addSubview:loginView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginViewDelegate methods
//
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    [self presentLoggedInViewController];
//}
//
//- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
//                            user:(id<FBGraphUser>)user {
//    
//}
//
//- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    
//}
//
//- (void)loginView:(FBLoginView *)loginView
//      handleError:(NSError *)error {
//    
//}

#pragma mark - Private methods

- (void)presentLoggedInViewController {
    [self presentViewController:[[AppNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]] animated:YES completion:nil];
}

- (IBAction)onLoginButton:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location", @"user_friends", @"email", @"public_profile"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            [self presentLoggedInViewController];
        }
    }];

//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished

}



@end
