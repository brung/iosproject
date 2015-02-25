//
//  Answer.h
//  unnamed
//
//  Created by Bruce Ng on 2/17/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>
#import <Parse/Parse.h>

@interface Answer : NSObject
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) PFFile *photoFile;
@property (nonatomic, assign) NSInteger count;
@end
