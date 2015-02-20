//
//  HomeViewController.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "HomeViewController.h"
#import "AnswerCell.h"
#import "SurveyViewController.h"
#import "SurveyHeaderCell.h"
#import "ParseClient.h"

NSString * const kAnswerCell = @"AnswerCell";
NSString * const kSurveryHeaderCell = @"SurveyHeaderCell";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, assign) NSInteger pageIndex;

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
        survey.votedIndex = i%5;
        
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
    [self.tableView registerNib:[UINib nibWithNibName:kAnswerCell bundle:nil] forCellReuseIdentifier:kAnswerCell];
    [self.tableView registerNib:[UINib nibWithNibName:kSurveryHeaderCell bundle:nil] forCellReuseIdentifier:kSurveryHeaderCell];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self onTableRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
    [ParseClient getHomeSurveysOnPage:0 withCompletion:^(NSArray *surveys, NSError *error) {
        if (error == nil) {
            self.pageIndex = 0;
            [self.surveys removeAllObjects];
            [self.surveys addObjectsFromArray:surveys];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
        [self.tableRefreshControl endRefreshing];
    }];
//    [self.surveys removeAllObjects];
//    [self setupTestData];
//    [self.tableView reloadData];
//    [self.tableRefreshControl endRefreshing];
}

#pragma mark - TableViewDelegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.surveys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Survey *survey = self.surveys[section];
    return survey.answers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Survey *survey = self.surveys[indexPath.section];
    
    if (indexPath.section >= self.surveys.count - 1) {
        [ParseClient getHomeSurveysOnPage:self.pageIndex + 1 withCompletion:^(NSArray *surveys, NSError *error) {
            if (error == nil) {
                self.pageIndex++;
                [self.surveys addObjectsFromArray:surveys];
                [self.tableView reloadData];
            } else {
                NSLog(@"%@", error);
            }
        }];
        
//        [self setupTestData];
//        [self.tableView reloadData];
    }
    
    if (indexPath.row == 0) {
        SurveyHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSurveryHeaderCell];
        cell.survey = survey;
        return cell;
    } else {
        AnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kAnswerCell];
        Answer *ans = survey.answers[indexPath.row];
        cell.index = indexPath.row;
        cell.total = [self getTotalFromAnswers:survey.answers];
        cell.answer = ans;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyViewController *vc = [[SurveyViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
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
