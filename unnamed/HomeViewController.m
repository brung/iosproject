//
//  HomeViewController.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "HomeViewController.h"
#import "SurveyCell.h"
#import "SurveyViewController.h"
#import "ParseClient.h"

NSString * const kSurveyCell = @"SurveyCell";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;

@property (nonatomic,strong) NSMutableArray *surveys;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.tabBarItem.image = [UIImage imageNamed:@"Home"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup Objects
    self.surveys = [[NSMutableArray alloc] init];
    [ParseClient getHomeSurveysOnPage:0 withCompletion:^(NSArray *surveys, NSError *error) {
        if (!error) {
            [self.surveys addObjectsFromArray:surveys];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to retrieve surveys. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    // Table Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kSurveyCell bundle:nil] forCellReuseIdentifier:kSurveyCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
    NSLog(@"onTableRefresh");
    [self.tableRefreshControl endRefreshing];
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SurveyCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSurveyCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyViewController *vc = [[SurveyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
