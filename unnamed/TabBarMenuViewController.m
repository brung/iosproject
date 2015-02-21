//
//  TabBarMenuViewController.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "TabBarMenuViewController.h"
#import "UIColor+AppTintColor.h"

@interface TabBarMenuViewController ()

@end

@implementation TabBarMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tabBar setTintColor:[UIColor appTintColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
