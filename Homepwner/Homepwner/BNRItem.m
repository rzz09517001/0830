//
//  BNRItem.m
//  RandomItems
//
//  Created by macOs on 2018/8/31.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
    }
    return self;
}

+(instancetype)randomItem
{
    NSArray *randomAdjectiveList = @[@"Fluffy",@"Rusty",@"Shiny"];
    NSArray *randomnNounList = @[@"Bear",@"Spork",@"Mac"];
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomnNounList count];
    NSString *randomName = [NSString stringWithFormat:@"%@%@", [randomAdjectiveList objectAtIndex:adjectiveIndex], [randomnNounList objectAtIndex:nounIndex]];
    int randomValue = arc4random() % 100;
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    BNRItem *newItem = [[self alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
}

-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber
{
    self = [super init];
    if (self) {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        _dateCreated = [[NSDate alloc] init];
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    return self;
}

//中级练习 另一个初始化方法
-(instancetype)initWithItemName:(NSString *)name  serialNumber:(NSString *)sNumber
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}

-(instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}

-(instancetype)init
{
    return [self initWithItemName:@"Item"];
}

-(NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@(%@):Worth:%d,recorded on %@",
                                   self.itemName,
                                   self.serialNumber,
                                   self.valueInDollars,
                                   self.dateCreated];
    return descriptionString;
}

//
//-(void)setItemName:(NSString *)str
//{
//    _itemName = str;
//}
//
//-(NSString *)itemName
//{
//    return _itemName;
//}
//
//-(void)setSerialNumber:(NSString *)str
//{
//    _serialNumber = str;
//}
//
//-(NSString *)serialNumber
//{
//    return _serialNumber;
//}
//
//-(void)setValueInDollars:(int)v
//{
//    _valueInDollars = v;
//}
//
//-(int)valueInDollars
//{
//    return _valueInDollars;
//}
//
//-(NSDate *)dateCreated
//{
//    return _dateCreated;
//}
//
//
//-(BNRItem *)containedItem
//{
//    return _containedItem;
//}
//
//-(void)setContainer:(BNRItem *)item
//{
//    _container = item;
//}
//
//-(BNRItem *)container
//{
//    return _container;
//}

-(void)dealloc
{
    NSLog(@"Destroyed:%@",self);
}
@end
