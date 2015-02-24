//
//  CameraViewController.h
//  unnamed
//
//  Created by Bruce Ng on 2/23/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@protocol CameraViewControllerDelegate <NSObject>

- (void)cameraViewController:(CameraViewController *)vc didSelectPhoto:(UIImage *)photo;

@end

@interface CameraViewController : UIViewController
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic,strong) id<CameraViewControllerDelegate> delegate;
@end
