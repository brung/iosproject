//
//  SurveyViewController.m
//  unnamed
//
//  Created by Casing Chu on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "SurveyViewController.h"
#import "Question.h"
#import "User.h"
#import "Answer.h"
#import "DetailQuestionCell.h"
#import "DetailAnswerCell.h"
#import "DetailPhotoAnswerCell.h"
#import "ParseClient.h"
#import "GrayBarButtonItem.h"
#import "UIColor+AppColor.h"
#import "CmtViewController.h"
#import "DetailCommentCell.h"



NSString * const AnswerCellNib = @"DetailAnswerCell";
NSString * const QuestionCellNib = @"DetailQuestionCell";
NSString * const PhotoAnswerCellNib = @"DetailPhotoAnswerCell";
NSString * const CommentCellNib = @"DetailCommentCell";

@interface SurveyViewController () <UITableViewDataSource, UITableViewDelegate, CmtViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyContents;
@property (nonatomic, assign) NSInteger voteTotal;
@property (nonatomic, strong) DetailQuestionCell *prototypeQuestionCell;
@property (nonatomic, strong) DetailAnswerCell *prototypeAnswerCell;
@property (nonatomic, strong) DetailCommentCell *prototypeCommentCell;
@property (nonatomic, strong) NSMutableArray * comments;
@property (nonatomic, strong) DetailPhotoAnswerCell *prototypePhotoAnswerCell;
@property (nonatomic, strong) CmtViewController * cmtVC;

@end

@implementation SurveyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appBgColor];
    
    //comment button
    GrayBarButtonItem *commentButton = [[GrayBarButtonItem alloc] initWithTitle:@"Comment" style:UIBarButtonItemStylePlain target:self action:@selector(onCommentButton)];
    self.navigationItem.rightBarButtonItem = commentButton;
        
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AnswerCellNib bundle:nil] forCellReuseIdentifier:AnswerCellNib];
    [self.tableView registerNib:[UINib nibWithNibName:QuestionCellNib bundle:nil] forCellReuseIdentifier:QuestionCellNib];
    [self.tableView registerNib:[UINib nibWithNibName:PhotoAnswerCellNib bundle:nil] forCellReuseIdentifier:PhotoAnswerCellNib];
    [self.tableView registerNib:[UINib nibWithNibName:CommentCellNib bundle:nil] forCellReuseIdentifier:CommentCellNib];
    [self.tableView reloadData];
    [self pullComments];
}

- (void)didPostComment:(CmtViewController *)vc{
    NSLog(@"SurveyViewController: CmtViewController just posted a comment!");
    [self pullComments];
}

- (void)pullComments{
    [ParseClient getCommentsOnSurvey:_survey withCompletion:^(NSArray *comments, NSError *error) {
        NSLog(@"pull comments from parse.");
        if(comments!=nil){
            self.comments = [NSMutableArray array];
            [self.comments removeAllObjects];
            [self.comments addObjectsFromArray:comments];
            //NSLog(@"Comments retrieval succeed! Get back %ld comments for current survey!", self.comments.count);
            [self.tableView reloadData];
        }
        else{
            NSLog(@"Comments retrieval failed! Error is %@", [error localizedDescription]);
        }
    }];
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    NSMutableArray *contents = [NSMutableArray array];
    [contents addObject:survey.question];
    [contents addObjectsFromArray:survey.answers];
    self.surveyContents = [contents copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView methods
- (DetailQuestionCell *)prototypeQuestionCell {
    if (!_prototypeQuestionCell) {
        _prototypeQuestionCell = [self.tableView dequeueReusableCellWithIdentifier:QuestionCellNib];
    }
    return _prototypeQuestionCell;
}

- (DetailAnswerCell *)prototypeAnswerCell {
    if (!_prototypeAnswerCell) {
        _prototypeAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:AnswerCellNib];
    }
    return _prototypeAnswerCell;
}

- (DetailPhotoAnswerCell *)prototypePhotoAnswerCell {
    if (!_prototypePhotoAnswerCell) {
        _prototypePhotoAnswerCell = [self.tableView dequeueReusableCellWithIdentifier:PhotoAnswerCellNib];
    }
    return _prototypePhotoAnswerCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return self.surveyContents.count;
    else{
        //NSLog(@"section = 1 now!");
        return self.comments.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.comments.count!=0){
        //NSLog(@"table has 2 sections now");
        return 2;
    }
    //NSLog(@"table has 1 section now");
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        [self configureCell:self.prototypeCommentCell forRowAtIndexPath:indexPath];
        [self.prototypeCommentCell layoutIfNeeded];
        CGSize size = [self.prototypeCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        //NSLog(@"for comment, cell height is %f", size.height);
        return 60;
        //return size.height+1;
    }
    if ([self.surveyContents[indexPath.row] isKindOfClass:[Question class]]) {
        [self configureCell:self.prototypeQuestionCell forRowAtIndexPath:indexPath];
        [self.prototypeQuestionCell layoutIfNeeded];
        CGSize size = [self.prototypeQuestionCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    } else {
        if (self.survey.question.isTextSurvey) {
            [self configureCell:self.prototypeAnswerCell forRowAtIndexPath:indexPath];
            [self.prototypeAnswerCell layoutIfNeeded];
            CGSize size = [self.prototypeAnswerCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
        } else {
            [self configureCell:self.prototypePhotoAnswerCell forRowAtIndexPath:indexPath];
            [self.prototypePhotoAnswerCell layoutIfNeeded];
            CGSize size = [self.prototypePhotoAnswerCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
            return size.height+1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1){
        DetailCommentCell * cell = [self.tableView dequeueReusableCellWithIdentifier:CommentCellNib];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
    if ([self.surveyContents[indexPath.row] isKindOfClass:[Question class]]) {
        DetailQuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:QuestionCellNib];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    } else {
        if (self.survey.question.isTextSurvey) {
            DetailAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AnswerCellNib];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        } else {
            DetailPhotoAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PhotoAnswerCellNib];
            [self configureCell:cell forRowAtIndexPath:indexPath];
            return cell;
        }
    }
}

- (void)configureCell:(UITableViewCell *)pCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([pCell isKindOfClass:[DetailQuestionCell class]]) {
        DetailQuestionCell *cell = (DetailQuestionCell *)pCell;
        [cell initWithQuestion:self.survey.question user:self.survey.user totalCount:self.survey.totalVotes];
    } else if ([pCell isKindOfClass:[DetailAnswerCell class]]) {
        DetailAnswerCell *cell = (DetailAnswerCell *)pCell;
        Answer *answer = (Answer *)self.surveyContents[indexPath.row];
        [cell initWithAnswer:answer totalVotes:self.survey.totalVotes];
        cell.isCurrentVote = [self.survey isCurrentVoteAnswer:answer];
    } else if ([pCell isKindOfClass:[DetailPhotoAnswerCell class]]) {
        DetailPhotoAnswerCell *cell = (DetailPhotoAnswerCell *)pCell;
        Answer *answer = (Answer *)self.surveyContents[indexPath.row];
        [cell initWithAnswer:answer totalVotes:self.survey.totalVotes];
        cell.isCurrentVote = [self.survey isCurrentVoteAnswer:answer];
    } else if ([pCell isKindOfClass:[DetailCommentCell class]]) {
        DetailCommentCell *cell = (DetailCommentCell *)pCell;
        Comment * comment =self.comments[indexPath.row];
        [cell initWithComment:comment];
    }
    pCell.backgroundColor = [UIColor appBgColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 1) return;
    
    Answer *newAnswer = self.surveyContents[indexPath.row];
    if (!self.survey.voted || self.survey.vote.answerIndex != newAnswer.index) {
    [ParseClient saveVoteOnSurvey:self.survey withAnswer:self.surveyContents[indexPath.row] withCompletion:^(Survey *survey, NSError *error) {
        if (!error) {
            self.survey = survey;
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserDidPostUpdateSurveyNotification object:nil];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to vote. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    }
}

- (UIImageView *)getMainProfileImageView {
    DetailQuestionCell *cell = (DetailQuestionCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    return cell.profileImageView;
}

- (void) onCommentButton{
    self.cmtVC = [[CmtViewController alloc] init];
    self.cmtVC.delegate =self;
    self.cmtVC.view.frame = self.view.frame;
    self.cmtVC.survey = _survey;
    [self.navigationController pushViewController:self.cmtVC animated:YES];
}
@end
