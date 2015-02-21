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
#import "ParseClient.h"
#import "UIColor+AppBgColor.h"
#import "UIColor+AppTintColor.h"

NSString * const AnswerCellNib = @"DetailAnswerCell";
NSString * const QuestionCellNib = @"DetailQuestionCell";

@interface SurveyViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *surveyContents;
@property (nonatomic, assign) NSInteger voteTotal;
@property (nonatomic, strong) DetailQuestionCell *prototypeQuestionCell;
@property (nonatomic, strong) DetailAnswerCell *prototypeAnswerCell;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;

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
    
    [self.tableView reloadData];
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
    NSMutableArray *contents = [NSMutableArray array];
    [contents addObject:survey.question];
    for (Answer *answer in survey.answers) {
        [contents addObject:answer];
        self.voteTotal += answer.count;
    }
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
        [self configureCell:self.prototypeAnswerCell forRowAtIndexPath:indexPath];
        [self.prototypeAnswerCell layoutIfNeeded];
        CGSize size = [self.prototypeAnswerCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        return size.height+1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.surveyContents[indexPath.row] isKindOfClass:[Question class]]) {
        DetailQuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:QuestionCellNib];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    } else {
        DetailAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AnswerCellNib];
        [self configureCell:cell forRowAtIndexPath:indexPath];
        return cell;
    }
}

- (void)configureCell:(UITableViewCell *)pCell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([pCell isKindOfClass:[DetailQuestionCell class]]) {
        DetailQuestionCell *cell = (DetailQuestionCell *)pCell;
        cell.question = self.survey.question;
        cell.user = self.survey.user;
    } else if ([pCell isKindOfClass:[DetailAnswerCell class]]) {
        DetailAnswerCell *cell = (DetailAnswerCell *)pCell;
        Answer *answer = (Answer *)self.surveyContents[indexPath.row];
        cell.answer = answer;
        cell.index = indexPath.row;
        if ([self.survey isCurrentVoteAnswer:answer]) {
            cell.isCurrentVote = YES;
            self.currentSelectedIndexPath = indexPath;
        } else {
            cell.isCurrentVote = NO;
        }
    }
    pCell.backgroundColor = [UIColor appBgColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [ParseClient saveVoteOnSurvey:self.survey withAnswer:self.surveyContents[indexPath.row] withCompletion:^(Vote *vote, NSError *error) {
        if (!error) {
            NSArray *array = [NSArray arrayWithObjects:indexPath,
                                    self.currentSelectedIndexPath,
                                    nil];
            self.currentSelectedIndexPath = indexPath;
            [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Unable to vote. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

@end
