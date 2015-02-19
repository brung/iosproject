//
//  ParseClient.h
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <Parse/Parse.h>

@interface ParseClient : Parse
+ (ParseClient *)sharedInstance;
@end
