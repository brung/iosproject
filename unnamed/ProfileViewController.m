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
#import "PhotoAnswerCell.h"
#import "UIColor+AppColor.h"
#import "GrayBarButtonItem.h"

NSString * const kProfileCellName = @"ProfileCell";
NSString * const kSurveyViewCellName = @"SurveyViewCell";
NSString * const kPhotoViewCellName = @"PhotoAnswerCell";

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, strong) ProfileCell * prototypeProfileCell;
@property (nonatomic, strong) SurveyViewCell * prototypeSurveyCell;
@property (nonatomic, strong) PhotoAnswerCell *prototypePhotoCell;
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
        self.isInsertingNewPost = NO;
        self.surveys = [NSMutableArray array];
        self.pageIndex = 0;
        self.view.backgroundColor = [UIColor appBgColor];
        
        // Setup
        if (!self.user) {
            self.user = [User currentUser];
        }
        self.logOutButton = [[GrayBarButtonItem alloc] initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogOutButton)];
                
        // - tableview related:        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor appBgColor];
        [self.tableView registerNib:[UINib nibWithNibName:kProfileCellName bundle:nil] forCellReuseIdentifier:kProfileCellName];
        [self.tableView registerNib:[UINib nibWithNibName:kSurveyViewCellName bundle:nil] forCellReuseIdentifier:kSurveyViewCellName];
        [self.tableView registerNib:[UINib nibWithNibName:kPhotoViewCellName bundle:nil] forCellReuseIdentifier:kPhotoViewCellName];
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewPost:) name:UserDidPostNewSurveyNotification object:nil];

    // Do any additional setup after loading the view from its nib.
    
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
    [self fetchSurveys];
    
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

- (PhotoAnswerCell *)prototypePhotoCell {
    if (!_prototypePhotoCell) {
        _prototypePhotoCell = [self.tableView dequeueReusableCellWithIdentifier:kPhotoViewCellName];
    }
    return _prototypePhotoCell;
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
    
    Survey *survey = self.surveys[indexPath.row];
    if (survey.question.isTextSurvey) {
        [self configureCell:self.prototypeSurveyCell forRowAtIndexPath:indexPath];
        [self.prototypeSurveyCell layoutIfNeeded];
        CGSize size = [self.prototypeSurveyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //    NSLog(@"Row %ld has height %f", indexPath.row, size.height);
        return size.height;
    } else {
        [self configureCell:self.prototypePhotoCell forRowAtIndexPath:indexPath];
        [self.prototypePhotoCell layoutIfNeeded];
        CGSize size = [self.prototypePhotoCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //    NSLog(@"Row %ld has height %f", indexPath.row, size.height);
        return size.height;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        ProfileCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kProfileCellName];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    } else {
        if (indexPath.row == self.surveys.count && !self.isUpdating) {
            if (self.surveys.count == (self.pageIndex * ResultCount)) {
                [self fetchSurveys];
            }
        }

        Survey *survey = self.surveys[indexPath.row];
        if (survey.question.isTextSurvey) {
            SurveyViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSurveyViewCellName];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        } else {
            PhotoAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kPhotoViewCellName];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)configureCell:(UITableViewCell *)pCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([pCell isKindOfClass:[SurveyViewCell class]]) {
        SurveyViewCell *cell = (SurveyViewCell *)pCell;
        cell.survey = self.surveys[indexPath.row];
    } else if ([pCell isKindOfClass:[ProfileCell class]]) {
        ProfileCell *cell = (ProfileCell *)pCell;
        cell.user = self.user;
    } else if ([pCell isKindOfClass:[PhotoAnswerCell class]]) {
        PhotoAnswerCell *cell = (PhotoAnswerCell *)pCell;
        cell.survey = self.surveys[indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SurveyViewController *vc = [[SurveyViewController alloc] init];
    vc.survey = self.surveys[indexPath.row];
    vc.view.frame = self.view.frame;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Animation 
- (ProfileImageView *)getMainProfileImageView {
    ProfileCell *cell = (ProfileCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.profileImageView;
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
