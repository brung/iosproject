//
//  GraphData.h
//  unnamed
//
//  Created by Bruce Ng on 2/22/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Answer.h"

@interface GraphData : NSObject
@property (nonatomic, strong) Answer *answer;
@property (nonatomic, assign) NSInteger totalVotes;

@end
