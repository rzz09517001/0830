//
//  BNRQuizViewController.m
//  Quiz
//
//  Created by macOs on 2018/8/31.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()

@property (nonatomic) int currentQuestionIndex;

@property (nonatomic, copy) NSArray *questions;
@property (nonatomic, copy) NSArray *answers;

@property (nonatomic, weak)IBOutlet UILabel *questionLabel;
@property (nonatomic, weak)IBOutlet UILabel *answerLabel;

@end

@implementation BNRQuizViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.questions = @[
                           @"你来自哪里？",
                           @"7+7=",
                           @"今天天气怎么样？"];
        self.answers = @[
                         @"中国",
                         @"14",
                         @"很好"];
        self.tabBarItem.title = @"Quiz";
        
    }
    return self;
}


-(IBAction)showQuestion:(id)sender {
    self.currentQuestionIndex++;
    if (self.currentQuestionIndex == [self.questions count]) {
        self.currentQuestionIndex = 0;
    }
    self.questionLabel.text = self.questions[self.currentQuestionIndex];
    self.answerLabel.text = @"???";
}

-(IBAction)showAnswer:(id)sender {
    self.answerLabel.text = self.answers[self.currentQuestionIndex];
}

@end
