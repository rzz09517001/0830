//
//  BNRItem.h
//  RandomItems
//
//  Created by macOs on 2018/8/31.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated;
}

+(instancetype)randomItem;
//BNRItem类的指定初始化方法
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
-(instancetype)initWithItemName:(NSString *)name serialNumber:(NSString *)sNumber;
-(instancetype)initWithItemName:(NSString *)name;

-(void)setItemName:(NSString *)str;
-(NSString *)itemName;
-(void)setSerialNumber:(NSString *)str;
-(NSString *)serialNumber;
-(void)setValueInDollars:(int)v;
-(int)valueInDollars;
-(NSDate *)dateCreated;

@end