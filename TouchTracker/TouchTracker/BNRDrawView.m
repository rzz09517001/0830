//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by macOs on 2018/9/4.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()

//@property (nonatomic, strong) BNRLine *currentLine;
@property(nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLines;

@end

@implementation BNRDrawView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLines = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        //接受多跟手指触摸
        self.multipleTouchEnabled = YES;
    }
    return self;
}

#pragma mark drawLine
-(void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

#pragma mark drawRect
- (void)drawRect:(CGRect)rect {
    //用黑色绘制已经完成的线条
    [[UIColor blackColor] set];
    for (BNRLine *line in self.finishedLines) {
        [self strokeLine:line];
    }
    [[UIColor redColor] set];
    for (NSValue *key in self.linesInProgress) {
        [self strokeLine:self.linesInProgress[key]];
    }
//    if (self.currentLine) {
//        //用红色绘制正在画的线条
//        [[UIColor redColor] set];
//        [self strokeLine:self.currentLine];
//    }
}

#pragma mark - toucheEvent
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //向控制台输出信息，查看触摸事件发生的顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        CGPoint location = [t locationInView:self];
        BNRLine *line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
//    UITouch *t = [touches anyObject];
//    //根据触摸位置创建BNRLine对象
//    CGPoint location = [t locationInView:self];
//    self.currentLine = [[BNRLine alloc] init];
//    self.currentLine.begin = location;
//    self.currentLine.end = location;
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //向控制台输出信息，查看触摸事件发生的顺序
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
//    UITouch *t = [touches anyObject];
//    CGPoint location = [t locationInView:self];
//    self.currentLine.end = location;
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        BNRLine *line = self.linesInProgress[key];
        [self.finishedLines addObject:line];
        [self.linesInProgress removeObjectForKey:key];
    }
//    [self.finishedLines addObject:self.currentLine];
//    self.currentLine = nil;
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    [self setNeedsDisplay];
}

@end
