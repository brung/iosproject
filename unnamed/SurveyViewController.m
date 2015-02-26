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
#import "UIColor+AppColor.h"

NSString * const AnswerCellNib = @"DetailAnswerCell";
NSString * const QuestionCellNib = @"DetailQuestionCell";
NSString * const PhotoAnswerCellNib = @"DetailPhotoAnswerCell";

@interface SurveyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyContents;
@property (nonatomic, assign) NSInteger voteTotal;
@property (nonatomic, strong) DetailQuestionCell *prototypeQuestionCell;
@property (nonatomic, strong) DetailAnswerCell *prototypeAnswerCell;
@property (nonatomic, strong) DetailPhotoAnswerCell *prototypePhotoAnswerCell;

@end

@implementation SurveyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor appBgColor];
        
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AnswerCellNib bundle:nil] forCellReuseIdentifier:AnswerCellNib];
    [self.tableView registerNib:[UINib nibWithNibName:QuestionCellNib bundle:nil] forCellReuseIdentifier:QuestionCellNib];
    [self.tableView registerNib:[UINib nibWithNibName:PhotoAnswerCellNib bundle:nil] forCellReuseIdentifier:PhotoAnswerCellNib];
    
    [self.tableView reloadData];
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
    return self.surveyContents.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    pCell.backgroundColor = [UIColor appBgColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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


@end
