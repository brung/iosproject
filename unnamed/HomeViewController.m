//
//  HomeViewController.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "HomeViewController.h"
#import "SurveyViewController.h"
#import "SurveyViewCell.h"
#import "ParseClient.h"

NSString * const kSurveyViewCell = @"SurveyViewCell";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) BOOL isUpdating;

- (NSInteger)getTotalFromAnswers:(NSArray *)answers;

@end

@implementation HomeViewController

- (void) setupTestData {
    for (int i=0; i<20; i++) {
        Survey *survey = [[Survey alloc] init];
        survey.question = [[Question alloc] init];
        survey.question.text = [NSString stringWithFormat:@"Question %d?", i];
        survey.question.anonymous = (i%2==0)?YES:NO;
        survey.question.complete = (i%2==0)?NO:YES;
        
        survey.user = [[User alloc] init];
        survey.user.name = [NSString stringWithFormat:@"Name %d", i];
        
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        for (int j=0; j < ((i % 4) + 2); j++) {
            Answer *answer = [[Answer alloc] init];
            answer.count = i * j;
            answer.text = [NSString stringWithFormat:@"Answer %d - %d", i, j];
            [answers addObject:answer];
        }
        survey.answers = [NSArray arrayWithArray:answers];
        survey.voted = (i%2 == 0)?YES:NO;
        
        [self.surveys addObject:survey];
    }
}

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
    self.pageIndex = 0;
    self.surveys = [[NSMutableArray alloc] init];
    
    // Table Refresh control
    self.tableRefreshControl = [[UIRefreshControl alloc] init];
    [self.tableRefreshControl addTarget:self action:@selector(onTableRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.tableRefreshControl atIndex:0];
    
    // TableView Setup
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:kSurveyViewCell bundle:nil] forCellReuseIdentifier:kSurveyViewCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self onTableRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
    self.pageIndex = 0;
    [self fetchSurveys];
}

- (void)fetchSurveys {
    if (!self.isUpdating) {
        self.isUpdating = YES;
        [ParseClient getHomeSurveysOnPage:self.pageIndex withCompletion:^(NSArray *surveys, NSError *error) {
            if (error == nil) {
                if (self.pageIndex == 0) {
                    self.surveys = [NSMutableArray arrayWithArray:surveys];
                } else {
                    [self.surveys addObjectsFromArray:surveys];
                }
                [self.tableView reloadData];
                self.isUpdating = NO;
            } else {
                NSLog(@"%@", error);
                [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to retrieve surveys. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                self.isUpdating = NO;
            }
            [self.tableRefreshControl endRefreshing];
        }];
//        [self setupTestData];
//        [self.tableView reloadData];
//        [self.tableRefreshControl endRefreshing];
    }
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.surveys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.surveys.count - 1 && !self.isUpdating) {
        self.pageIndex++;
        if (self.surveys.count == (self.pageIndex * ResultCount)) {
            [self fetchSurveys];
        }
    }
    
    SurveyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSurveyViewCell];
    cell.survey = self.surveys[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyViewController *vc = [[SurveyViewController alloc] init];
    vc.survey = self.surveys[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private Methods
- (NSInteger)getTotalFromAnswers:(NSArray *)answers {
    NSInteger total = 0;
    for (Answer *ans in answers) {
        total += ans.count;
    }
    return total;
}

@end
