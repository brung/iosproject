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

NSString * const AnswerCell = @"ComposeAnswerCell";
NSString * const AskAQuestion = @"Ask a question . . .";
NSInteger const maxCount = 160;

@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, ComposeAnswerCellDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionText;
@property (weak, nonatomic) IBOutlet UILabel *questionTextCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addAnswerButton;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) ComposeAnswerCell *prototypeCell;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Create";
        self.tabBarItem.image = [UIImage imageNamed:@"Poll Topic"];
    }
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
    
    // Button
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    // Do any additional setup after loading the view from its nib.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AnswerCell bundle:nil] forCellReuseIdentifier:AnswerCell];
    
    self.addAnswerButton.alpha = 0;
    self.answers = [NSMutableArray array];
    
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
    }
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
    
    [self showAddAnswerButton:(count >= 8)];
}

#pragma mark - Add An Answer Button
- (void) showAddAnswerButton:(BOOL)show {
    self.addAnswerButton.enabled = show;
    if (show) {
        [UIView animateWithDuration:0.5 animations:^{
            self.addAnswerButton.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.addAnswerButton.alpha = 0;
        }];
    }
}

- (IBAction)onAddAnswerButton:(id)sender {
    [self.questionText endEditing:YES];
    if (self.answers.count < 4) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.answers.count inSection:0];
        [self.answers addObject:[[Answer alloc] init]];
        [UIView animateWithDuration:0.3 animations:^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
        }];
    }

}

- (void)onSubmitButton {
    NSMutableArray *validAnswers = [NSMutableArray array];
    for (Answer *answer in self.answers) {
        if ([answer.text length] >= 1) {
            [validAnswers addObject:answer];
        }
    }
    if ([self.questionText.text length] >= 8 && validAnswers.count >= 2) {
        //Submit question
        Survey *survey = [[Survey alloc] init];
        survey.text = self.questionText.text;
        survey.anonymous = NO;
        survey.complete = NO;
        [survey saveWithCompletion:^(BOOL succeeded, NSError *error) {
            if (!error) {
                NSString *surveyId = survey.objectId;
                for (int count = 0; count < validAnswers.count; count++) {
                    Answer *answer = validAnswers[count];
                    answer.surveyId = surveyId;
                    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (!error) {
                            // NEed to do something
                            if(count == validAnswers.count-1) {
                                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                            }
                        } else {
                            NSLog(@"unable to save answer");
                            [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:[NSString stringWithFormat:@"Unable to save this survey at this time. Please try again. (%d)", count] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                        }
                    }];
                }
            } else {
                NSLog(@"unable to save survey");
                [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"Unable to save at this time. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
        }];
    }
}

- (void)onCancelButton {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
