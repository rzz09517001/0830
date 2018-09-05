//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by macOs on 2018/9/4.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()<UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
//@property (nonatomic, strong) BNRLine *currentLine;
@property(nonatomic, strong) NSMutableDictionary *linesInProgress;
@property(nonatomic, strong) NSMutableArray *finishedLines;
@property(nonatomic,weak) BNRLine *selectedLine;

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
        //创建手势
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        //在识别出手势之前不向begin发送消息
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        //避免将双击事件拆分成2个单击事件
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        //创建长按手势
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
    }
    return self;
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)doubleTap:(UIGestureRecognizer *)gz
{
    NSLog(@"Recognized Double Tap");
    [self.linesInProgress removeAllObjects];
    
    [self.finishedLines removeAllObjects];
    //self.finishedLines = [[NSMutableArray alloc] init];
    [self setNeedsDisplay];
}

-(void)tap:(UIGestureRecognizer *)gz
{
    NSLog(@"Recognized tap");
    CGPoint point = [gz locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    if (self.selectedLine) {
        //使视图称谓UIMenuItem动作消息的目标
        [self becomeFirstResponder];
        //获取UIMenuController对象
        UIMenuController *menu = [UIMenuController sharedMenuController];
        //创建一个删除的UIMenuItem对象
        UIMenuItem *deletItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteLine:)];
        menu.menuItems = @[deletItem];
        //先为UIMenuController对象设置显示区域。然后将其设置为可见
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    } else {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    [self setNeedsDisplay];
}

-(void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        self.selectedLine = nil;
    }
    [self setNeedsDisplay];
}

-(void)moveLine:(UIPanGestureRecognizer *)gr
{
    if (!self.selectedLine) {
        return;
    }
    if (gr.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gr translationInView:self];
        CGPoint begin = self.selectedLine.begin;
        CGPoint end = self.selectedLine.end;
        begin.x += translation.x;
        begin.y += translation.y;
        end.x += translation.x;
        end.y += translation.y;
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        [self setNeedsDisplay];
        //将手指的当前位置设置为拖动移动的起始位置
        [gr setTranslation:CGPointZero inView:self];
    }
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
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
    //测试应用运行时占用CPU性能
//    float f = 0.0;
//    for (int i=0; i<1000000; i++) {
//        f = f + sin(sin(sin(time(NULL)+ i)));
//    }
//    NSLog(@"f=%f",f);
    
}

-(BNRLine *)lineAtPoint:(CGPoint)p
{
    //找出离p最近的BNRLine对象
    for (BNRLine *l in self.finishedLines) {
        CGPoint start = l.begin;
        CGPoint end = l.end;
        for (float t=0; t<=1.0; t+=0.05) {
            float x = start.x + t*(end.x - start.x);
            float y = start.y + t*(end.y - start.y);
            if (hypot(x - p.x, y - p.y) <20.0) {
                return l;
            }
        }
    }
    return nil;
}

-(void)deleteLine:(id)sender
{
    [self.finishedLines removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

/**
 静态分析测试
 */
//-(int)numberOfLines
//{
//    int count = 0;
//    //计数前先查看相应的指针是否为nil
//    if (self.linesInProgress && self.finishedLines)
//    count = [self.linesInProgress count] + [self.finishedLines count];
//    return count;
//}

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
        //测试强引用
        //line.containingArray = self.finishedLines;
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

@end
