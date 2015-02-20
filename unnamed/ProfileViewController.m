//
//  ProfileViewController.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SurveyCell.h"
#import "ParseClient.h"
#import "ProfileCell.h"
#import "SurveyHeaderView.h"
#import "AnswerCell.h"

NSString * const kAnswerCellName = @"AnswerCell";
NSString * const kProfileCellName = @"ProfileCell";
NSString * const kSurveyHeaderViewName = @"SurveyHeaderView";

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, strong) PFUser * currentProfileUser;

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"User Male"];
        self.currentProfileUser = [PFUser currentUser];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // - tableview related:
    self.profileTableView.dataSource = self;
    self.profileTableView.delegate = self;
    [self.profileTableView registerNib:[UINib nibWithNibName:kProfileCellName bundle:nil] forCellReuseIdentifier:kProfileCellName];
    [self.profileTableView registerNib:[UINib nibWithNibName:kAnswerCellName bundle:nil] forCellReuseIdentifier:kAnswerCellName];
    [self.profileTableView registerNib:[UINib nibWithNibName:kSurveyHeaderViewName bundle:nil] forHeaderFooterViewReuseIdentifier:kSurveyHeaderViewName];
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    [ParseClient getMySurveysComplete:NO onPage:0 withCompletion:^(NSArray *surveys, NSError *error) {
        if (!error) {
            [self.surveys addObjectsFromArray:surveys];
            NSLog(@"getting %ld surveys for current user: %@", surveys.count, self.currentProfileUser[@"profile"][@"name"]);
            //[self.profileTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to retrieve surveys. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    // - refresh table content
    [self.profileTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        //section 0 will present ProfileCell which has profile image,
        //title and other profile related info
        return 1;
    }
    //section # >= 1 will present surveys of current user
    //NSInteger actualSurveyCount = self.surveys.count;
    NSInteger fakeAnswerCount = 3;
    return fakeAnswerCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 255;
    }
    //calculate cell height for survey cells
    return 18;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        ProfileCell * cell = [self.profileTableView dequeueReusableCellWithIdentifier:kProfileCellName];
        [cell updateContentWithPFUser:[PFUser currentUser]];
        //ProfileCell * cell = [[ProfileCell alloc] initWithPFUser: [PFUser currentUser]];
        return cell;
    }
    AnswerCell * cell = [self.profileTableView dequeueReusableCellWithIdentifier:kAnswerCellName];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= 1){
        SurveyHeaderView *view = [self.profileTableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderViewName];
        //view.survey = self.surveys[section];
        return view;
    }else{
        UITableViewHeaderFooterView * view = [[UITableViewHeaderFooterView alloc] init];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) return 0;
    SurveyHeaderView *view = [self.profileTableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderViewName];
    return view.frame.size.height;
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
