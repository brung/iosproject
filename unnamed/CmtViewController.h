//
//  CmtViewController.h
//  unnamed
//
//  Created by Xiangyu Zhang on 2/25/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
@class CmtViewController;

@protocol CmtViewControllerDelegate <NSObject>
- (void)didPostComment:(CmtViewController *)vc;
@end

@interface CmtViewController : UIViewController
@property (nonatomic, strong) Survey *survey;
@property (nonatomic, weak) id<CmtViewControllerDelegate> delegate;

@end
