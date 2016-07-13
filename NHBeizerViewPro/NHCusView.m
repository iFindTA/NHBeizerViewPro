//
//  NHCusView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/8/6.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import "NHCusView.h"

@implementation NHCusView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _pathColor = [UIColor orangeColor];
    }
    return self;
}

-(void)setPathColor:(UIColor *)pathColor{
    _pathColor = pathColor;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat t_redus = rect.size.width*0.25;
    CGRect infoRect = CGRectMake(-t_redus, -t_redus, t_redus*2, t_redus*2);
//    CGContextAddRect(ctx, infoRect);
//    [_pathColor setFill];
//    CGContextDrawPath(ctx, kCGPathFill);
    /*
    CGPathRef pathRef = CGPathCreateWithEllipseInRect(infoRect, nil);
    [[UIColor clearColor] setFill];
    CGContextAddPath(ctx, pathRef);
    CGContextDrawPath(ctx, kCGPathFill);
    //*/
    /*
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointMake(0, t_redus);
    CGPoint p3 = CGPointMake(t_redus, 0);
    CGPoint p4 = CGPointMake(t_redus, t_redus);
    UIBezierPath *t_path = [UIBezierPath bezierPath];
    [t_path moveToPoint:p1];
    [t_path addLineToPoint:p2];
    //[t_path addCurveToPoint:p3 controlPoint1:p2 controlPoint2:p3];
    [t_path addQuadCurveToPoint:p3 controlPoint:p4];
    [t_path addLineToPoint:p1];
    [t_path closePath];
    CGPathRef pathRef_ = [t_path CGPath];
    CGContextAddPath(ctx, pathRef_);
    [[UIColor clearColor] setFill];
    CGContextDrawPath(ctx, kCGPathFill);
    //*/
    
    //*
    CGFloat l_redius = 8;
    CGPoint p1 = CGPointMake(0, t_redus);
    CGPoint p2 = CGPointMake(0, rect.size.height-l_redius);
    CGPoint pctr1 = CGPointMake(0, rect.size.height);
    CGPoint p3 = CGPointMake(l_redius, rect.size.height);
    CGPoint pctr2 = CGPointMake(rect.size.width, rect.size.height);
    CGPoint p4 = CGPointMake(rect.size.width-l_redius, rect.size.height);
    CGPoint p5 = CGPointMake(rect.size.width, rect.size.height-l_redius);
    CGPoint pctr3 = CGPointMake(rect.size.width, 0);
    CGPoint p6 = CGPointMake(rect.size.width, l_redius);
    CGPoint p7 = CGPointMake(rect.size.width-l_redius, 0);
    CGPoint p8 = CGPointMake(t_redus, 0);
    CGPoint pmid = CGPointMake(t_redus+l_redius*0.5, t_redus+l_redius*0.5);
     UIBezierPath *t_path = [UIBezierPath bezierPath];
     [t_path moveToPoint:p1];
     [t_path addLineToPoint:p2];
    [t_path addQuadCurveToPoint:p3 controlPoint:pctr1];
    [t_path addLineToPoint:p4];
    [t_path addQuadCurveToPoint:p5 controlPoint:pctr2];
    [t_path addLineToPoint:p6];
    [t_path addQuadCurveToPoint:p7 controlPoint:pctr3];
    [t_path addLineToPoint:p8];
    [t_path addQuadCurveToPoint:p1 controlPoint:pmid];
     [t_path closePath];
     CGPathRef pathRef_ = [t_path CGPath];
     CGContextAddPath(ctx, pathRef_);
     [_pathColor setFill];
     CGContextDrawPath(ctx, kCGPathFill);
    [t_path setLineWidth:1.f];
    [[UIColor redColor] setStroke];
    [t_path stroke];
     //*/
}

@end
