//
//  HomeProfileAnimation.m
//  unnamed
//
//  Created by Bruce Ng on 2/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "HomeProfileAnimation.h"
#import "ProfileViewController.h"
@interface HomeProfileAnimation()
@property UINavigationController *navController;
@end

@implementation HomeProfileAnimation 
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGPoint originalCenter = fromViewController.view.center;
    CGPoint rightCenter =CGPointMake(originalCenter.x + toViewController.view.frame.size.width, originalCenter.y);
    UINavigationBar *navBar = self.navController.navigationBar;
    float navBarHeight = navBar.frame.size.height + navBar.frame.origin.y;
    
    if (self.isPresenting) {
        NSLog(@"I'm presenting");
        
        ProfileViewController *vc = (ProfileViewController *)toViewController;
        toViewController.view.center = rightCenter;
        [containerView addSubview:toViewController.view];
        ProfileImageView *remoteProfileImageView = [vc getMainProfileImageView];
        remoteProfileImageView.hidden = YES;
        
        UIImageView *selectedProfileImage = self.selectedCell.profileImageView;

        
        CGRect profileFrameInCell = [self.selectedCell profileImageviewFrame];
        NSLog(@"y:%f %f nav:%f x:%f %f", self.selectedCell.frame.origin.y, profileFrameInCell.origin.y, navBarHeight, self.selectedCell.frame.origin.x , profileFrameInCell.origin.x);
        CGRect profileImageFrame = CGRectMake(self.selectedCell.frame.origin.x + profileFrameInCell.origin.x+2, self.selectedCell.frame.origin.y + profileFrameInCell.origin.y+navBarHeight, profileFrameInCell.size.width, profileFrameInCell.size.height);
        UIImageView *transImageView = [[ProfileImageView alloc] initWithFrame:profileImageFrame];
        transImageView.layer.cornerRadius = transImageView.frame.size.width / 2;
        transImageView.image = selectedProfileImage.image;
        transImageView.contentMode = UIViewContentModeScaleAspectFill;
        transImageView.clipsToBounds = YES;
        transImageView.transform = CGAffineTransformMakeScale(1.1,1.1);
        [containerView addSubview:transImageView];
        
        selectedProfileImage.hidden = YES;
        [UIView animateWithDuration:1 animations:^{
            CGFloat widthScale = (remoteProfileImageView.frame.size.width/selectedProfileImage.frame.size.width);
            CGFloat heightScale = (remoteProfileImageView.frame.size.height/selectedProfileImage.frame.size.height);
            transImageView.transform = CGAffineTransformScale(selectedProfileImage.transform, widthScale, heightScale);
            transImageView.center = CGPointMake(remoteProfileImageView.center.x+28, remoteProfileImageView.center.y + navBarHeight);
            toViewController.view.center = originalCenter;
            fromViewController.view.alpha = 0.5;
        } completion:^(BOOL finished) {
            [transImageView removeFromSuperview];
            [transitionContext completeTransition:YES];
            selectedProfileImage.hidden = NO;
            remoteProfileImageView.hidden = NO;
        }];
    } else {
        NSLog(@"I'm dismissing");
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        [fromViewController dismissViewControllerAnimated:YES completion:nil];
        [UIView animateWithDuration:1 animations:^{
            fromViewController.view.center = rightCenter;
            toViewController.view.alpha =1;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}


#pragma mark - transitionDelegate
- (id )animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id )animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    self.navController = navigationController;
    if (operation == UINavigationControllerOperationPush) {
        self.isPresenting = YES;
    } else if (operation == UINavigationControllerOperationPop) {
        self.isPresenting = NO;
    }
    return self;
}

@end
