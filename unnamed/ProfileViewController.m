//
//  ProfileViewController.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SurveyCell.h"

NSString * const kSurveyCellName = @"SurveyCell";

@interface ProfileViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString* profileImageUrlString;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
//############################################################
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *answeredCountLabel;
//############################################################
//orderSegmentedControl decides the order questions of a user is shown in the
//questionTableView
//[0]Recent - based on time the question is created
//[1]Open - still time order but only questions that hasn't been closed yet
//[2]Popular - based on the number of participants of a question
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderSegmentedControl;
//############################################################
@property (weak, nonatomic) IBOutlet UITableView *questionTableView;
@property (nonatomic, assign) CGFloat tableHeight;
//############################################################
@property (nonatomic, strong) UITableViewCell *prototypeCell;


@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Profile";
        self.tabBarItem.image = [UIImage imageNamed:@"User Male"];
        self.tableHeight = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // - set profile image
    [self.profileImageView setImage:[UIImage imageNamed:@"tongue" ]];
    
    // - tableview related:
    self.questionTableView.dataSource = self;
    self.questionTableView.delegate = self;
    [self.questionTableView registerNib:[UINib nibWithNibName:kSurveyCellName bundle:nil] forCellReuseIdentifier:kSurveyCellName];
    //self.questionTableView.rowHeight = UITableViewAutomaticDimension;
    //NSLog(@"before reload, rowHeight set to %lf", self.questionTableView.rowHeight);
    
    // - refresh table content
    [self.questionTableView reloadData];
    
    // - set table height just equal to content height so that
    // - table view wont scroll, we use scrollview 's scroll only.
    //CGRect tableFrame = [self.questionTableView frame];
    //tableFrame.size.height = self.tableHeight;
    //[self.questionTableView setFrame:tableFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.prototypeCell)
    {
        self.prototypeCell = [self.questionTableView dequeueReusableCellWithIdentifier:kSurveyCellName];
    }
    //configure cell content here
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 5;
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SurveyCell *cell = [self.questionTableView dequeueReusableCellWithIdentifier:kSurveyCellName];
    //configure cell content here
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"when create a cell, cell height is %lf", size.height);
    self.tableHeight = self.tableHeight+size.height;
    NSLog(@"so far tableHeight is %lf", self.tableHeight);

    return cell;
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
