//
//  BNRLine.h
//  TouchTracker
//
//  Created by macOs on 2018/9/4.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRLine : NSObject

@property(nonatomic) CGPoint begin;
@property(nonatomic) CGPoint end;
//测试强引用
//@property(nonatomic,weak) NSMutableArray *containingArray;

@end
