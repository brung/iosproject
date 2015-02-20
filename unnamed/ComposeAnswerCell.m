//
//  ComposeAnswerCell.m
//  unnamed
//
//  Created by Bruce Ng on 2/18/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "ComposeAnswerCell.h"

@interface ComposeAnswerCell()
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (nonatomic, strong) NSArray *valueLabels;
@end

@implementation ComposeAnswerCell

- (void)awakeFromNib {
    // Initialization code
    self.valueLabels = @[@"A", @"B", @"C", @"D", @"E", @"F"];
    self.answerLabel.alpha = 0;
    self.answerText.alpha = 1;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    tapGesture.delegate = self;
    [self.answerLabel addGestureRecognizer:tapGesture];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

- (void)setAnswer:(Answer *)answer {
    _answer = answer;
    if ([answer.text length] > 0) {
        self.answerLabel.text = answer.text;
        self.answerLabel.alpha = 1;
        self.answerText.alpha = 0;
    }
}

- (void)setAnswerIndex:(NSInteger)answerIndex {
    _answerIndex = answerIndex;
    self.valueLabel.text = self.valueLabels[answerIndex];
}

- (void)submitText {
    if ([self.answerText.text length] > 0) {
        [self showTextField:NO];
    } else {
        [self showTextField:YES];
    }
    [self.delegate composeAnswerCell:self changedAnswer:self.answer];
}

#pragma mark - Gesture Recognizers
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self showTextField:YES];
    
}

- (IBAction)onEditingEnd:(id)sender {
    [self submitText];
}

- (IBAction)onEditingChanged:(id)sender {
    self.answerLabel.text = self.answerText.text;
    self.answer.text = self.answerText.text;
    [self.delegate composeAnswerCell:self changedAnswer:self.answer];
}

#pragma mark - Private methods
- (void)showTextField:(BOOL)show {
    [UIView animateWithDuration:0.2 animations:^{
        if (show) {
            self.answerLabel.alpha = 0;
            self.answerText.alpha = 1;
        } else {
            self.answerLabel.alpha = 1;
            self.answerText.alpha = 0;
        }
    }];
}

@end
