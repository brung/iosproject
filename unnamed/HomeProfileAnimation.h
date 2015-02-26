//
//  HomeProfileAnimation.h
//  unnamed
//
//  Created by Bruce Ng on 2/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeProfileAnimation : NSObject  <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic, assign) BOOL isPresenting;
@end
