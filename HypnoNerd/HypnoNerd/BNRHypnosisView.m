//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by macOs on 2018/9/3.
//  Copyright © 2018年 rzz. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@end

@implementation BNRHypnosisView


-(void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGRect bounds = self.bounds;
    //圆心位置
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/2.0;
    center.y = bounds.origin.y + bounds.size.height/2.0;
    //计算半径，取较小值
    //float radius = (MIN(bounds.size.width, bounds.size.height)/2.0);
    //使最外层图形成为视图的的外接圆
    float maxRadius = hypotf(bounds.size.width, bounds.size.height)/2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //[path addArcWithCenter:center radius:radius startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
    //设置线条宽度为10
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -=20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center radius:currentRadius startAngle:0.0 endAngle:M_PI*2.0 clockwise:YES];
    }
    path.lineWidth = 10;
    //设置线条颜色为浅灰色
    //[[UIColor lightGrayColor] setStroke];
    [self.circleColor setStroke];
    //绘制路径
    [path stroke];
}

/**
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@被触摸",self);
    float red = (arc4random() %100)/100;
    float green = (arc4random() %100)/100;
    float blue = (arc4random() %100)/100;
    UIColor *randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.circleColor = randomColor;
}
*/
@end
