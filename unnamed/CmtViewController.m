//
//  CmtViewController.m
//  unnamed
//
//  Created by Xiangyu Zhang on 2/25/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "CmtViewController.h"
#import "UIColor+AppColor.h"
#import "GrayBarButtonItem.h"
#import "Comment.h"
#import "ParseClient.h"

NSInteger const maxCommentCount = 160;
NSString * const WriteAComment = @"Leave a comment here . . .";

@interface CmtViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (nonatomic, assign) BOOL isUpdating;

@end

@implementation CmtViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Comment";
    }
    self.view.backgroundColor = [UIColor appBgColor];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Setup Comment Text Field
    self.commentTextView.layer.cornerRadius = 10;
    self.commentTextView.layer.masksToBounds = YES;
    // Button
    GrayBarButtonItem *submitButton = [[GrayBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(onSubmitButton)];
    self.navigationItem.rightBarButtonItem = submitButton;
    
    // Instruction
    self.instructionLabel.text = WriteAComment;
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",(long)maxCommentCount];
    
    // textview delegate
    self.commentTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSurvey:(Survey *)survey {
    _survey = survey;
}

- (void) textViewDidChange:(UITextView *)textView{
    NSInteger count = maxCommentCount - [self.commentTextView.text length];
    // SEt the counter to count;
    if (count <= 0) {
        //Stop text entry
        self.commentTextView.text = [self.commentTextView.text substringToIndex:maxCommentCount];
        count = 0;
    }
    self.commentCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
}
/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)onSubmitButton {
    if (!self.isUpdating) {
        self.isUpdating = YES;
        if ([self.commentTextView.text length] >= 8 ) {
            //Submit comment
            //NSLog(@"task: save comment to Parse");
            //construct a comment here...
            Comment * comment = [[Comment alloc] init];
            comment.text = self.commentTextView.text;
            comment.user = [PFUser currentUser];
            comment.questionId = _survey.question.objectId;
            NSLog(@"in CmtViewController: Comment.questionId is %@, comment user name is %@", comment.questionId, comment.user[@"profile"][@"name"]);
            [ParseClient saveComment: comment withCompletion:^(NSError *error) {
                if(error==nil){
                     NSLog(@"CmtViewController: comment saved successfully!");
                    [self.delegate didPostComment:self];
                     NSLog(@"CmtViewController: just posted a comment!");
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    NSLog(@"CmtViewController: comment saving failed - %@", [error localizedDescription]);
                    [[[UIAlertView alloc] initWithTitle:@"Comment Post Failed" message:@"Unable to post comment at this time. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }];
        }else{
            self.isUpdating = NO;
        }
    }
}

@end