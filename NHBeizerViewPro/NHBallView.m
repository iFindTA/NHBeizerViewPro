//
//  NHBallView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 16/3/31.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#define NHDEFAULT_PERCENT 0.02f
#define NHTHESHOLD_VALUE  0.5f

#import "NHBallView.h"

@interface NHBallView ()

@end

@implementation NHBallView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __initSetup];
    }
    return self;
}

- (void)__initSetup {
    
    //self.percent = NHDEFAULT_PERCENT;
    self.percent = 0.7;
}

- (void)setPercent:(CGFloat)percent {
    
    if (percent < NHDEFAULT_PERCENT) {
        percent = NHDEFAULT_PERCENT;
    }else if (percent > 1){
        percent = 1;
    }
    NSLog(@"percent:%f",percent);
    _percent = percent;
    [self setNeedsDisplay];
}

- (void)updateDisplayPercent:(CGFloat)percent {
    
}

#define angle2Radius(x) (x*M_PI/180)
#define radius2Angle(x) (x*180/M_PI)

- (void)drawRect:(CGRect)rect {
    
    CGFloat radius = (MIN(rect.size.width, rect.size.height))*0.5;
    CGPoint center = CGPointMake(radius, rect.size.height*0.5);
    
    CGFloat angle;CGPoint center_shadow;CGFloat radius_shadow;
    if (self.percent < NHTHESHOLD_VALUE) {
        angle = (self.percent/NHTHESHOLD_VALUE)*90;
        double dis = tan(angle2Radius(angle))*radius;
        center_shadow = CGPointMake(center.x, center.y + dis);
        radius_shadow = sqrt(radius*radius+dis*dis);
    }else if (self.percent == NHTHESHOLD_VALUE){
        
    }else if (self.percent > NHTHESHOLD_VALUE){
        angle = ((self.percent-NHTHESHOLD_VALUE)/NHTHESHOLD_VALUE)*90;
        CGFloat tan_v = tan(angle2Radius(angle));
        double dis = radius/tan_v;
        NSLog(@"dis:%f",dis);
        center_shadow = CGPointMake(center.x, center.y - dis);
        radius_shadow = sqrt(radius*radius+dis*dis);
    }
    NSLog(@"angle:%f--center:%@--radius:%f",angle,NSStringFromCGPoint(center_shadow),radius_shadow);
    BOOL clockwise = true;
    UIBezierPath *path = [UIBezierPath bezierPath];
    //[path moveToPoint:left_control];
    [path addArcWithCenter:center radius:radius startAngle:M_PI endAngle:2*M_PI clockwise:clockwise];
    if (self.percent < NHTHESHOLD_VALUE) {
        [path addArcWithCenter:center_shadow radius:radius_shadow startAngle:(2*M_PI-angle2Radius(angle)) endAngle:(2*M_PI-angle2Radius((180-angle))) clockwise:!clockwise];
    }else if (self.percent == NHTHESHOLD_VALUE){
        [path closePath];
    }else if (self.percent > NHTHESHOLD_VALUE){
        [path addArcWithCenter:center_shadow radius:radius_shadow startAngle:(M_PI_2-angle2Radius(angle)) endAngle:(M_PI_2+angle2Radius(angle)) clockwise:clockwise];
    }
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPathRef pathRef_ = [path CGPath];
    CGContextAddPath(ctx, pathRef_);
    
    //color
//    CGFloat components[8] = {
//        0.0, 0.0, 0.0, 1.0,
//        1.0, 1.0, 1.0, 1.0 };
//    CGColorSpaceRef cg = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColorComponents(cg, components, NULL, 2);
//    CGColorSpaceRelease(cg), cg = NULL;
//    CGPoint startPoint = CGPointMake(radius, 0);
//    CGPoint endPoint = CGPointMake(radius, radius*2);
//    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
//    CGGradientRelease(gradient), gradient = NULL;
    
//    CGContextSetFillColorWithColor(ctx, [[UIColor lightGrayColor] CGColor]);
//    CGContextAddPath(ctx, path.CGPath);
//    CGContextDrawPath(ctx, kCGPathFill);
//    [[UIColor redColor] setFill];
//    CGContextDrawPath(ctx, kCGPathFill);
    
//    [path setLineWidth:1.f];
//    [[UIColor redColor] setStroke];
//    [path stroke];
    
    
    //定义填充的颜色,这里我用红色
    UIColor* fillColor = [UIColor redColor];
    
    //定义一个渐变颜色，实现上面那个填充色的渐变
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray* innerColorColors = [NSArray arrayWithObjects:
                                 (id)[UIColor clearColor].CGColor,
                                 (id)fillColor.CGColor,
                                 (id)[UIColor blackColor].CGColor,nil];
    CGFloat innerColorLocations[] = {0,0.3,1};
    CGGradientRef innerColor = CGGradientCreateWithColors(colorSpace, (CFArrayRef)innerColorColors, innerColorLocations);
    
    //线条宽度设置为0
    CGFloat bezierStrokeWidth = 0;
    
    //UIBezierPath
    
    CGContextSaveGState(ctx);//先保存当前绘制
    [path addClip];//把此路径裁剪出来，否则渐变的绘制区域是整个当前的图形上下文
    CGContextDrawLinearGradient(ctx, innerColor,CGPointMake(radius, 0),CGPointMake(radius, radius*2), 0);//绘制渐变
    CGContextRestoreGState(ctx);//恢复绘制的内容到之前的的屏幕上
    path.lineWidth = bezierStrokeWidth;
    [path stroke];//路径绘制
    
    //清理释放内存
    CGGradientRelease(innerColor);
    CGColorSpaceRelease(colorSpace);
}

@end
