//
//  ComposeViewController.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ComposeViewController.h"
#import "CameraViewController.h"
#import "ComposeAnswerCell.h"
#import "ComposePhotoCell.h"
#import "Answer.h"
#import "Survey.h"
#import "ParseClient.h"
#import "GrayBarButtonItem.h"
#import "UIColor+AppColor.h"

NSString * const AnswerCell = @"ComposeAnswerCell";
NSString * const PhotoCell = @"ComposePhotoCell";
NSString * const AskAQuestion = @"Ask a question . . .";
NSInteger const maxCount = 160;

@interface ComposeViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, ComposeAnswerCellDelegate, CameraViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionText;
@property (weak, nonatomic) IBOutlet UILabel *questionTextCountLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *answerSegControl;
@property (nonatomic, strong) NSMutableArray *answers;
@property (nonatomic, strong) ComposeAnswerCell *prototypeCell;
@property (nonatomic, assign) BOOL isUpdating;
@property (nonatomic, assign) BOOL isShowingTextAnswers;
@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Create";
        GrayBarButtonItem *submitButton = [[GrayBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitButton)];
        self.navigationItem.rightBarButtonItem = submitButton;
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
    // Setup Question Text Field
    self.questionText.layer.cornerRadius = 10;
    self.questionText.layer.masksToBounds = YES;
    
    // Button
//    GrayBarButtonItem *cancelButton = [[GrayBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
//    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.answerSegControl.alpha = 0;
    
    //TableView
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AnswerCell bundle:nil] forCellReuseIdentifier:AnswerCell];
    self.tableView.alpha = 0;
    self.isShowingTextAnswers = YES;
    
    //CollectionVIew
    self.photoCollectionView.dataSource = self;
    self.photoCollectionView.delegate = self;
    [self.photoCollectionView registerNib:[UINib nibWithNibName:PhotoCell bundle:nil] forCellWithReuseIdentifier:PhotoCell];
    self.photoCollectionView.backgroundColor = [UIColor appBgColor];
    self.photoCollectionView.alpha = 0;
    
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
    footer.layer.cornerRadius = 10;
    footer.layer.masksToBounds = YES;
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
            if (self.isShowingTextAnswers)
                self.tableView.alpha = 1;
            else
                self.photoCollectionView.alpha = 1;
            
            self.answerSegControl.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.alpha = 0;
            self.photoCollectionView.alpha = 0;
            self.answerSegControl.alpha = 0;
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
            if ((self.isShowingTextAnswers && [answer.text length] >= 1) ||
                (!self.isShowingTextAnswers && answer.photo)) {
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
            survey.question.isTextSurvey = self.isShowingTextAnswers;
            
            if (self.isShowingTextAnswers) {
                survey.question.isTextSurvey = YES;
                survey.question.createdAt = [NSDate date] ;
                [ParseClient saveTextSurvey:survey withCompletion:^(BOOL succeeded, NSError *error) {
                    [self onPostSurvey:survey completionStatus:succeeded error:error];
                }];
            } else {
                survey.question.isTextSurvey = NO;
                [ParseClient savePhotoSurvey:survey withCompletion:^(BOOL succeeded, NSError *error) {
                    [self onPostSurvey:survey completionStatus:succeeded error:error];
                }];
                
            }
        } else {
            self.isUpdating = NO;
        }
    }
}

- (void)onPostSurvey:(Survey *)survey completionStatus:(BOOL) succeeded error:(NSError *)error {
    if (succeeded) {
        [self onSuccessfulPostSurvey:survey];
    } else {
        [self onErrorPost];
    }
    self.isUpdating = NO;
}

- (void)onSuccessfulPostSurvey:(Survey *)survey {
    NSDictionary *dict = [NSDictionary dictionaryWithObject:survey forKey:@"survey"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidPostNewSurveyNotification object:nil userInfo:dict];
    [self resetForm];
}

- (void)onErrorPost {
    [[[UIAlertView alloc] initWithTitle:@"Save Failed" message:@"Unable to save at this time. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

//- (void)onCancelButton {
//    [self resetForm];
//    [self dismissViewControllerAnimated:YES completion:nil];
////    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}

- (void)resetForm {
    self.answers = [NSMutableArray arrayWithObject:[[Answer alloc] init]];
    [self.answers addObject:[[Answer alloc] init]];
    [UIView animateWithDuration:0.25 animations:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [self.photoCollectionView reloadData];
        self.questionText.alpha = 0;
        self.tableView.alpha = 0;
        self.photoCollectionView.alpha = 0;
        self.answerSegControl.alpha = 0;
    } completion:^(BOOL finished) {
        self.questionText.text = @"";
        self.questionTextCountLabel.text = [NSString stringWithFormat:@"%ld", (long)maxCount];
        self.questionText.alpha = 1;
        [self.navigationController popViewControllerAnimated:YES];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}

- (IBAction)onToggleAnswerType:(UISegmentedControl *)sender {
    UIView *current;
    UIView *new;
    if (self.isShowingTextAnswers) {
        self.isShowingTextAnswers = NO;
        
        [self.view endEditing:YES];
        current = self.tableView;
        new = self.photoCollectionView;
    } else {
        self.isShowingTextAnswers = YES;
        current = self.photoCollectionView;
        new = self.tableView;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        current.transform = CGAffineTransformMakeScale(0.5, 0.5);
        current.alpha = 0;
        new.transform = CGAffineTransformMakeScale(1.0, 1.0);
        new.alpha = 1;
    }];
    
}

#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.answers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ComposePhotoCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:PhotoCell forIndexPath:indexPath];
    cell.answer = self.answers[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CameraViewController *vc = [[CameraViewController alloc] init];
    vc.indexPath = indexPath;
    vc.delegate = self;
    vc.view.frame = self.view.frame;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -CameraViewControllerDelegate methods
- (void)cameraViewController:(CameraViewController *)vc didSelectPhoto:(UIImage *)photo {
    Answer *answer = self.answers[vc.indexPath.row];
    answer.photo = photo;
    [self.photoCollectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:vc.indexPath]];
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
