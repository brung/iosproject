//
//  AppDelegate.m
//  unnamed
//
//  Created by Bruce Ng on 2/16/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "User.h"
#import "TabBarMenuViewController.h"
#import "ComposeViewController.h"
#import "ProfileViewController.h"
#import "AppNavigationController.h"
#import "UIColor+AppColor.h"

NSString * const kParseApplicationId = @"j4MqR9ASYk601tn3xX3vR8nLUyqcoRqjE0UzCqr7";
NSString * const kParseClientId = @"msAxad6wCjR01uuvzVWYtoMOpbakjgRlwQDTKeD8";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (TabBarMenuViewController *)tabBarMenuViewController {
    static TabBarMenuViewController *instance = nil;
    
    instance = [[TabBarMenuViewController alloc] init];
    
    AppNavigationController * vc1 = [[AppNavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    AppNavigationController * vc2 = [[AppNavigationController alloc] initWithRootViewController:[[ComposeViewController alloc] init]];
    ProfileViewController *pvc = [[ProfileViewController alloc] init];
    pvc.user = [User currentUser];
    AppNavigationController * vc3 = [[AppNavigationController alloc] initWithRootViewController:pvc];
    
    
    //adding sub view controllers
    NSArray* controllers = [NSArray arrayWithObjects:vc1, vc2, vc3, nil];
    instance.viewControllers = controllers;
    //instance.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    return instance;
}

- (void) showFBSessionState{
    //Debugging purpose to see whether
    //check this url for details: https://developers.facebook.com/docs/facebook-login/ios/sessions
    BOOL effectivelyLoggedIn;
    switch (FBSession.activeSession.state) {
        case FBSessionStateOpen:
            NSLog(@"Facebook session state: FBSessionStateOpen");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateCreatedTokenLoaded:
            NSLog(@"Facebook session state: FBSessionStateCreatedTokenLoaded");
            effectivelyLoggedIn = YES;
            break;
        case FBSessionStateOpenTokenExtended:
            NSLog(@"Facebook session state: FBSessionStateOpenTokenExtended");
            effectivelyLoggedIn = YES;
            break;
        default:
            NSLog(@"Facebook session state: not of one of the open or openable types.");
            effectivelyLoggedIn = NO;
            break;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:UserDidLogoutNotification object:nil];
    
    [Parse setApplicationId:kParseApplicationId clientKey:kParseClientId];
    
    [PFFacebookUtils initializeFacebook];
    
    [[UINavigationBar appearance] setTintColor:[UIColor appTintColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor appTintColor],
                                                          NSForegroundColorAttributeName,
                                                          nil]];
    
    BOOL shouldOpenLoginView = NO;
    
    User *user = [User currentUser];
    if (user) {
        
        NSLog(@"User name %@", user.name);
        NSLog(@"User image %@", user.profileImageUrl);
        NSLog(@"User id %@", user.objectId);
        
        [self showFBSessionState];
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"read_stream", @"user_photos"]
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              // Handler for session state changes
                                              // This method will be called EACH time the session state changes,
                                              // also for intermediate states and NOT just when the session open
                                          }];
        } else if(FBSession.activeSession.state == FBSessionStateOpen && [[FBSession activeSession] accessTokenData]){
            NSLog(@"FBSession already opened. And with cached FBAccessTokenData ready to use!");
        } else {
            shouldOpenLoginView = YES;
        }
    } else {
        shouldOpenLoginView = YES;
    }
    
    if(shouldOpenLoginView){
        self.window.rootViewController = [[LoginViewController alloc] init];
        self.window.backgroundColor = [UIColor whiteColor];
    }else{
        self.window.rootViewController = [AppDelegate tabBarMenuViewController];
    }
    
    [self.window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PFFacebookUtils session] close];
}

- (void)userDidLogout {
    self.window.rootViewController = [[LoginViewController alloc] init];
}

@end
