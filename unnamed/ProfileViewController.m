//
//  ProfileViewController.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SurveyViewController.h"
#import "ParseClient.h"
#import "ProfileCell.h"
#import "SurveyViewCell.h"
#import "UIColor+AppColor.h"
#import "GrayBarButtonItem.h"

NSString * const kProfileCellName = @"ProfileCell";
NSString * const kSurveyViewCellName = @"SurveyViewCell";

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, strong) ProfileCell * prototypeProfileCell;
@property (nonatomic, strong) SurveyViewCell * prototypeSurveyCell;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) GrayBarButtonItem *logOutButton;

@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) BOOL isInsertingNewPost;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"User Male"];
        self.surveys = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isInsertingNewPost = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewPost:) name:UserDidPostNewSurveyNotification object:nil];

    // Do any additional setup after loading the view from its nib.
    self.pageIndex = 0;
    self.view.backgroundColor = [UIColor appBgColor];
    if (!self.user) {
        self.user = [User currentUser];
    }
    
    // Setup
    self.logOutButton = [[GrayBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogOutButton)];
    
    // - tableview related:
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor appBgColor];
    [self.tableView registerNib:[UINib nibWithNibName:kProfileCellName bundle:nil] forCellReuseIdentifier:kProfileCellName];
    [self.tableView registerNib:[UINib nibWithNibName:kSurveyViewCellName bundle:nil] forCellReuseIdentifier:kSurveyViewCellName];
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self fetchSurveys];
    
    // - refresh table content
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:1];
}

- (void)viewWillAppear:(BOOL)animated {
    // If the User isn't current User don't show the logoutButton
    if (self.user == [User currentUser]) {
        self.navigationItem.rightBarButtonItem = self.logOutButton;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.isInsertingNewPost) {
        self.isInsertingNewPost = NO;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [UIView animateWithDuration:1 animations:^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Table View methods
- (SurveyViewCell *)prototypeSurveyCell {
    if (!_prototypeSurveyCell) {
        _prototypeSurveyCell = [self.tableView dequeueReusableCellWithIdentifier:kSurveyViewCellName];
    }
    return _prototypeSurveyCell;
}

- (ProfileCell *)prototypeProfileCell {
    if (!_prototypeProfileCell) {
        _prototypeProfileCell = [self.tableView dequeueReusableCellWithIdentifier:kProfileCellName];
    }
    return _prototypeProfileCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        //section 0 will present ProfileCell which has profile image,
        //title and other profile related info
        return 1;
    } else {
        return self.surveys.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self configureCell:self.prototypeProfileCell forRowAtIndexPath:indexPath];
        [self.prototypeProfileCell layoutIfNeeded];
        CGSize size = [self.prototypeProfileCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height;
    }

    [self configureCell:self.prototypeSurveyCell forRowAtIndexPath:indexPath];
    [self.prototypeSurveyCell layoutIfNeeded];
    CGSize size = [self.prototypeSurveyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.surveys.count && !self.isUpdating) {
        if (self.surveys.count == (self.pageIndex * ResultCount)) {
            [self fetchSurveys];
        }
    }
    
    if(indexPath.section == 0){
        ProfileCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kProfileCellName];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    } else {
        SurveyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSurveyViewCellName];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)pCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([pCell isKindOfClass:[SurveyViewCell class]]) {
        SurveyViewCell *cell = (SurveyViewCell *)pCell;
        cell.survey = self.surveys[indexPath.row];
    } else if ([pCell isKindOfClass:[ProfileCell class]]) {
        ProfileCell *cell = (ProfileCell *)pCell;
        cell.user = self.user;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyViewController *vc = [[SurveyViewController alloc] init];
    vc.survey = self.surveys[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Private methods
- (void) onRefresh{
    self.pageIndex=0;
    [self fetchSurveys];
}

- (void)fetchSurveys{
    if (!self.isUpdating) {
        self.isUpdating = YES;
        [ParseClient getUser:self.user surveysComplete:NO onPage:0 withCompletion:^(NSArray *surveys, NSError *error) {
            if (!error) {
                if (self.pageIndex == 0) {
                    self.surveys = [NSMutableArray arrayWithArray:surveys];
                } else {
                    [self.surveys addObjectsFromArray:surveys];
                }
                [self.tableView reloadData];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to retrieve surveys. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            [self.refreshControl endRefreshing];
            self.isUpdating = NO;
        }];
    }
}

- (void)onNewPost:(NSNotification *)notification {
    Survey *survey = notification.userInfo[@"survey"];
    if (survey) {
        NSMutableArray *newSurveys = [NSMutableArray arrayWithObject:survey];
        [newSurveys addObjectsFromArray:self.surveys];
        self.surveys = newSurveys;
        self.isInsertingNewPost = YES;
    }
}

- (void)onLogOutButton {
    NSLog(@"Logging out");
    [User logout];
}

@end
