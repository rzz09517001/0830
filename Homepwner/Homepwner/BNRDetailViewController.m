//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *serial;
@property (weak, nonatomic) IBOutlet UITextField *value;
@property (weak, nonatomic) IBOutlet UILabel *date;


@end

@implementation BNRDetailViewController

-(void)setItem:(BNRItem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BNRItem *item = self.item;
    self.name.text = item.itemName;
    self.serial.text = item.serialNumber;
    self.value.text = [NSString stringWithFormat:@"%d",item.valueInDollars];
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    self.date.text = [dateFormatter stringFromDate:item.dateCreated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消当前的第一响应
    [self.view endEditing:YES];
    BNRItem *item = self.item;
    item.itemName = self.name.text;
    item.serialNumber = self.serial.text;
    item.valueInDollars = [self.value.text intValue];
}

-(IBAction)backgroundTap:(id)sender
{
    [self.name resignFirstResponder];
    [self.serial resignFirstResponder];
    [self.value resignFirstResponder];
}

@end
