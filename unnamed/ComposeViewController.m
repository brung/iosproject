//
//  ComposeViewController.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "ComposeAnswerCell.h"
#import "Answer.h"
#import "Survey.h"
#import "ParseClient.h"
#import "GrayBarButtonItem.h"
#import "UIColor+AppBgColor.h"

NSString * const AnswerCell = @"ComposeAnswerCell";
NSString * const AskAQuestion = @"Ask a question . . .";
NSInteger const maxCount = 160;

@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ComposeAnswerCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionText;
@property (weak, nonatomic) IBOutlet UILabel *questionTextCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) ComposeAnswerCell *prototypeCell;
@property (nonatomic, assign) BOOL isUpdating;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Create";
        self.tabBarItem.image = [UIImage imageNamed:@"Poll Topic"];
    }
    self.view.backgroundColor = [UIColor appBgColor];
    return self;
}

- (ComposeAnswerCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:AnswerCell];
    }
    return _prototypeCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUpdating = NO;
    // Button
    GrayBarButtonItem *cancelButton = [[GrayBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    GrayBarButtonItem *submitButton = [[GrayBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AnswerCell bundle:nil] forCellReuseIdentifier:AnswerCell];
    
    self.tableView.alpha = 0;
    self.answers = [NSMutableArray arrayWithObject:[[Answer alloc] init]];
    [self.answers addObject:[[Answer alloc] init]];
    
    self.questionText.delegate = self;
    
    self.instructionLabel.text = AskAQuestion;
    self.questionTextCountLabel.text = [NSString stringWithFormat:@"%ld",(long)maxCount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.answers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureCell:self.prototypeCell atIndexPath:indexPath];
    [self.prototypeCell layoutIfNeeded];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComposeAnswerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:AnswerCell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[ComposeAnswerCell class]]) {
        ComposeAnswerCell *answerCell = (ComposeAnswerCell *)cell;
        answerCell.answer = self.answers[indexPath.row];
        answerCell.answerIndex = indexPath.row;
        //answerCell.delegate = self;
        answerCell.backgroundColor = [UIColor appBgColor];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 32;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UILabel *footer = [[UILabel alloc] init];
    footer.contentMode = UIViewContentModeCenter;
    footer.textAlignment = NSTextAlignmentCenter;
    footer.textColor = [UIColor lightGrayColor];
    if (self.answers.count < 4) {
        footer.text = (self.answers.count < 4) ? @"+ Add an Answer" : @"";
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAddAnswerButton:)];
        footer.userInteractionEnabled = YES;
        [footer addGestureRecognizer:tapGesture];
        footer.backgroundColor = [UIColor whiteColor];
    }
    return footer;
}

#pragma mark - ComposeAnswerCellDelegate methods
- (void)composeAnswerCell:(ComposeAnswerCell *)cell changedAnswer:(Answer *)answer {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.answers[indexPath.row] = answer;
}

#pragma mark - QuestionText Field
- (void)textViewDidChange:(UITextView *)textView {
    NSInteger count = maxCount - [self.questionText.text length];
    // SEt the counter to count;
    if (count <= 0) {
        //Stop text entry
        self.questionText.text = [self.questionText.text substringToIndex:maxCount];
        count = 0;
    }
    self.questionTextCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    
    [self showAddAnswerButton:(count >= 0 && count < maxCount)];//Lets fold up the Answer table if No Question
}

#pragma mark - Add An Answer Button
- (void) showAddAnswerButton:(BOOL)show {
    if (show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.tableView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.alpha = 0;
        }];
    }
}

- (IBAction)onAddAnswerButton:(id)sender {
    [self.questionText endEditing:YES];
    if (self.answers.count < 4) {
        [self.answers addObject:[[Answer alloc] init]];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }

}


- (void)onSubmitButton {
    if (!self.isUpdating) {
        self.isUpdating = YES;
        
        NSMutableArray *validAnswers = [NSMutableArray array];
        for (Answer *answer in self.answers) {
            if ([answer.text length] >= 1) {
                [validAnswers addObject:answer];
            }
        }
        if ([self.questionText.text length] >= 8 && validAnswers.count >= 2) {
            //Submit question
            Question *question = [[Question alloc] initWithText:self.questionText.text];
            Survey *survey = [[Survey alloc] init];
            survey.question = question;
            survey.answers = [validAnswers copy];
            survey.user = [User currentUser];
            [ParseClient saveSurvey:survey withCompletion:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:survey forKey:@"survey"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidPostNewSurveyNotification object:nil userInfo:dict];
                    [self resetForm];
                } else {
                    [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"Unable to save at this time. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                self.isUpdating = NO;
            }];
        }
    }
}

- (void)onCancelButton {
    [self resetForm];
}

- (void)resetForm {
    self.answers = [NSMutableArray arrayWithObject:[[Answer alloc] init]];
    [self.answers addObject:[[Answer alloc] init]];
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        self.questionText.alpha = 0;
        self.tableView.alpha = 0;
    } completion:^(BOOL finished) {
        self.questionText.text = @"";
        self.questionTextCountLabel.text = [NSString stringWithFormat:@"%ld", maxCount];
        self.questionText.alpha = 1;
    }];

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
