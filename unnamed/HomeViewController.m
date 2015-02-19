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
#import "SurveyHeaderView.h"
#import "ParseClient.h"

NSString * const kAnswerCell = @"AnswerCell";
NSString * const kSurveyHeaderView = @"SurveyHeaderView";

@interface HomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *tableRefreshControl;

@property (nonatomic,strong) NSMutableArray *surveys;

- (NSInteger)getTotalFromAnswers:(NSArray *)answers;

@end

@implementation HomeViewController

- (void) setupTestData {
    [self.surveys removeAllObjects];
    for (int i=0; i<5; i++) {
        Survey *survey = [[Survey alloc] init];
        survey.question = [[Question alloc] init];
        survey.question.text = [NSString stringWithFormat:@"Question %d?", i];
        survey.question.anonymous = (i%2==0)?YES:NO;
        survey.question.complete = (i%2==0)?NO:YES;
        
        survey.user = [[User alloc] init];
        survey.user.name = [NSString stringWithFormat:@"Name %d", i];
        
        NSMutableArray *answers = [[NSMutableArray alloc] init];
        for (int j=0; j < i % 4 +1; j++) {
            Answer *answer = [[Answer alloc] init];
            answer.count = i * j;
            answer.text = [NSString stringWithFormat:@"Answer %d - %d", i, j];
            [answers addObject:answer];
        }
        survey.answers = [NSArray arrayWithArray:answers];
        survey.voted = (i%2 == 0)?YES:NO;
        survey.votedIndex = i%4;
        
        [self.surveys addObject:survey];
    }
    [self.tableView reloadData];
    [self.tableRefreshControl endRefreshing];
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
    [self.tableView registerNib:[UINib nibWithNibName:kSurveyHeaderView bundle:nil] forHeaderFooterViewReuseIdentifier:kSurveyHeaderView];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self onTableRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RefreshControl
- (void)onTableRefresh {
//    [ParseClient getHomeSurveysOnPage:1 withCompletion:^(NSArray *surveys, NSError *error) {
//        if (error == nil) {
//            [self.surveys removeAllObjects];
//            [self.surveys addObjectsFromArray:surveys];
//            [self.tableView reloadData];
//        } else {
//            NSLog(@"%@", error);
//        }
//        [self.tableRefreshControl endRefreshing];
//    }];
    [self setupTestData];
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
    AnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kAnswerCell];
    Survey *survey = self.surveys[indexPath.section];
    Answer *ans = survey.answers[indexPath.row];
    NSInteger total = [self getTotalFromAnswers:survey.answers];
    cell.answerLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row, ans.text];
    NSInteger percentage = total <= 0 ? 0 : 100.0f * ans.count / total;
    cell.percentLabel.text = [NSString stringWithFormat:@"%ld%%", percentage];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SurveyHeaderView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderView];
    view.survey = self.surveys[section];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    SurveyHeaderView *view = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderView];
    return view.frame.size.height;
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
