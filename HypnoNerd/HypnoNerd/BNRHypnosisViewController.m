//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRHypnosisViewController.h"
#import "BNRHypnosisView.h"

@interface BNRHypnosisViewController ()<UITextFieldDelegate>

@end

@implementation BNRHypnosisViewController

-(void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    BNRHypnosisView *backGroundView = [[BNRHypnosisView alloc] initWithFrame:frame];
    UISegmentedControl *segmentController = [[UISegmentedControl alloc] initWithItems:@[@"红色",@"绿色",@"黄色"]];
    segmentController.frame = CGRectMake(0, 0, frame.size.width, 44);
    segmentController.enabled = YES;
    [segmentController addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [backGroundView addSubview:segmentController];
    
    CGRect textFieldRect= CGRectMake(40, 70, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    [backGroundView addSubview:textField];
    self.view = backGroundView;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    //NSLog(@"%@",textField);
    [self drawHypnosisMessage:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    return YES;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"hy loaded its view");
}

-(void)valueChanged:(UISegmentedControl *)sender
{
    BNRHypnosisView *hyView = [[BNRHypnosisView alloc] init];
    NSInteger selectIndex = sender.selectedSegmentIndex;
    if (selectIndex == 0) {
        NSLog(@"%ld",selectIndex);
        hyView.circleColor = [UIColor redColor];
    } else if (selectIndex == 1) {
        NSLog(@"%ld",selectIndex);
        hyView.circleColor = [UIColor greenColor];
    } else {
        NSLog(@"%ld",selectIndex);
        hyView.circleColor = [UIColor yellowColor];
    }
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Hypnosis";
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = i;
    }
    return self;
}

-(void)drawHypnosisMessage:(NSString *)message
{
    for (int i =0; i < 20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        [messageLabel sizeToFit];
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        [self.view addSubview:messageLabel];
        //增加视差效果
        UIInterpolatingMotionEffect *motionEffect;
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
        motionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue=@(-25);
        motionEffect.maximumRelativeValue=@(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}



@end
