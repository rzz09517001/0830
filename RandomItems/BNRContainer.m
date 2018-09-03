//
//  BNRContainer.m
//  RandomItems
//
//  Created by macOs on 2018/9/1.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRContainer.h"

@implementation BNRContainer

-(instancetype)init
{
    subItems = [[NSMutableArray alloc] init];
    return [self initWithItemName:@"Container"];
}


-(void)setSubItems:(BNRItem *)item
{
    [subItems addObject:item];
}

-(NSString *)description
{
    int sum = self.valueInDollars;
    for (int i = 0; i < [subItems count]; i++) {
        sum = sum + subItems[i].valueInDollars;
    }
    NSString *des = [[NSString alloc] initWithFormat:@"名称%@(数字%@),总价值%d,记录与%@,数组内容包括%@",
                     self.itemName,
                     self.serialNumber,
                     sum,
                     self.dateCreated,
                     subItems];
    return des;
}

@end
