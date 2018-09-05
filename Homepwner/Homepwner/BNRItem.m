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
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
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
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
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
//创建缩略图
-(void)setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize = image.size;
    //缩略图的大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    //确定缩放倍数并保持宽高比不变
    float ratio = MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    //根据当前设备的屏幕scaling factor创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //创建表示圆角矩形的UIBezierPath对象
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    //根据UIBezierPath对象裁剪图形上下文
    [path addClip];
    //让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width)/2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height)/2.0;
    //在上下文中绘制图片
    [image drawInRect:projectRect];
    //通过图形上下文得到UIImage对象，并将其赋值给thumbnail属性
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    //清理图形上下文
    UIGraphicsEndImageContext();
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
