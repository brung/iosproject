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
#import "SurveyHeaderCell.h"
#import "AnswerCell.h"

NSString * const kAnswerCellName = @"AnswerCell";
NSString * const kProfileCellName = @"ProfileCell";
NSString * const kSurveyHeaderCellName = @"SurveyHeaderCell";

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *profileTableView;
@property (nonatomic, strong) NSMutableArray *surveys;
@property (nonatomic, strong) PFUser * currentProfileUser;
@property (nonatomic, strong) AnswerCell * prototypeCell;

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
    [self.profileTableView registerNib:[UINib nibWithNibName:kSurveyHeaderCellName bundle:nil] forCellReuseIdentifier:kSurveyHeaderCellName];
    self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.surveys = [[NSMutableArray alloc] init];
    [ParseClient getMySurveysComplete:NO onPage:0 withCompletion:^(NSArray *surveys, NSError *error) {
        if (!error) {
            [self.surveys addObjectsFromArray:surveys];
            NSLog(@"getting %ld surveys for current user: %@", self.surveys.count, self.currentProfileUser[@"profile"][@"name"]);
            //[self.profileTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
            [self.profileTableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to retrieve surveys. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    // - refresh table content
    //[self.profileTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"return number of sectios in tableView as: %ld", self.surveys.count);
    return self.surveys.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        //section 0 will present ProfileCell which has profile image,
        //title and other profile related info
        return 1;
    }
    Survey * s = self.surveys[section-1];
    NSInteger surveyAnswerCount = s.answers.count;
    return surveyAnswerCount;
}

- (AnswerCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.profileTableView dequeueReusableCellWithIdentifier:kAnswerCellName];
    }
    return _prototypeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return 255;
    }
    //calculate cell height for survey cells
    NSLog(@"calculating row height for a survey");
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        ProfileCell * cell = [self.profileTableView dequeueReusableCellWithIdentifier:kProfileCellName];
        [cell updateContentWithPFUser:[PFUser currentUser]];
        //ProfileCell * cell = [[ProfileCell alloc] initWithPFUser: [PFUser currentUser]];
        return cell;
    } else {
        if (indexPath.row == 0) {
            SurveyHeaderCell *cell = [self.profileTableView dequeueReusableCellWithIdentifier:kSurveyHeaderCellName];
            cell.survey = self.surveys[indexPath.section-1];
            return cell;
        } else {
            AnswerCell *cell = [self.profileTableView dequeueReusableCellWithIdentifier:kAnswerCellName];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //SurveyViewController *vc = [[SurveyViewController alloc] init];
    //[self.navigationController pushViewController:vc animated:YES];
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if(section >= 1){
//        SurveyHeaderView *view = [self.profileTableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderViewName];
//        view.survey = self.surveys[section-1];
//        return view;
//    }else{
//        UITableViewHeaderFooterView * view = [[UITableViewHeaderFooterView alloc] init];
//        return view;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if(section == 0) return 0;
//    SurveyHeaderView *view = [self.profileTableView dequeueReusableHeaderFooterViewWithIdentifier:kSurveyHeaderViewName];
//    return view.frame.size.height;
    return 0;
}

- (NSInteger)getTotalFromAnswers:(NSArray *)answers {
    NSInteger total = 0;
    
    for (Answer *ans in answers) {
        total += ans.count;
    }
    return total;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[AnswerCell class]]) {
        AnswerCell * answerCell = (AnswerCell *)cell;
        Survey *survey = self.surveys[indexPath.section-1];
        Answer *ans = survey.answers[indexPath.row];
        answerCell.index = indexPath.row;
        answerCell.total = [self getTotalFromAnswers:survey.answers];
        answerCell.answer = ans;
    }
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
