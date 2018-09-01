//
//  main.m
//  RandomItems
//
//  Created by macOs on 2018/8/31.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"
#import "BNRContainer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //创建1个NSMutableArray对象，并用items变量保存该对象的地址
        NSMutableArray *items = [[NSMutableArray alloc] init];
        BNRContainer *container = [[BNRContainer alloc] init];
        container.serialNumber = @"2A";
        container.valueInDollars = 25;
        
        //[items addObject:@"One"];
        //[items addObject:@"Two"];
        //[items addObject:@"Three"];
        //[items insertObject:@"Zero" atIndex:0];
        
        for (int i=0; i<10; i++) {
            BNRItem *item = [BNRItem randomItem];
            [items addObject:item];
            [container setSubItems:item];
        }
        
        //异常
        //id lastObj = [items lastObject];
        //[lastObj count];
        NSLog(@"%@", container);
        
        //for (BNRItem *item in items) {
        //    NSLog(@"%@", item);
        //}
        //初级联系：数组越界异常
        //for (int j = 0; j< 11; j++ ) {
        //    NSLog(@"%@", items[j]);
        //}
        
        //BNRItem *item = [[BNRItem alloc] init];
        //item.itemName = @"Red Sofa";
        //item.serialNumber = @"A1B2C";
        //item.valueInDollars = 100;
        //NSLog(@"%@ %@ %@ %d",item.itemName,item.serialNumber,item.dateCreated,item.valueInDollars);
        //BNRItem *item = [[BNRItem alloc] initWithItemName:@"Red Sofa" valueInDollars:100 serialNumber:@"A1B2C"];
        //NSLog(@"%@",item);
        //BNRItem *itemWithName = [[BNRItem alloc] initWithItemName:@"Red Sofa"];
        //NSLog(@"%@",itemWithName);
        //BNRItem *itemWithNoName = [[BNRItem alloc] init];
        //NSLog(@"%@",itemWithNoName);
        //释放items所指向的NSMutableArray对象
        items = nil;
    }
    return 0;
}
