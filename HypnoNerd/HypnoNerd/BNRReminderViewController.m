//
//  BNRReminderViewController.m
//  HypnoNerd
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRReminderViewController.h"

@interface BNRReminderViewController ()

@property (nonatomic,weak) IBOutlet UIDatePicker* datePicker;

@end

@implementation BNRReminderViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"rvc loaded its view");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"Time";
        UIImage *i = [UIImage imageNamed:@"Time.png"];
        self.tabBarItem.image = i;
    }
    return self;
}


-(IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"Setting a reminder for %@", date);
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypontize me!";
    note.fireDate = date;
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

@end
