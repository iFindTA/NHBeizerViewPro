//
//  NHMaskView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/9/14.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import "NHMaskView.h"

@implementation NHMaskItem

@end

@interface NHMaskView ()

@property (nonatomic, strong) UIColor *maskColor;

@end

@implementation NHMaskView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initSetup];
    }
    return self;
}

- (void)_initSetup{
    _maskColor = [UIColor colorWithWhite:0 alpha:0.7];
    NHMaskItem *item = [[NHMaskItem alloc] init];
    item.focusPoint = CGPointMake(self.bounds.size.width*0.5, 200);
    item.focusSize = CGSizeMake(100, 50);
    item.info = @"请点击按钮";
    item.image = [UIImage imageNamed:@"finger.png"];
    [self setItem:item];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    CGPoint touchPt = [[touches anyObject] locationInView:self];
    CGPoint fucusPt = _item.focusPoint;
    CGFloat width = _item.focusSize.width;CGFloat height = _item.focusSize.height;
    CGPoint leftPt = CGPointMake(fucusPt.x-width*0.5, fucusPt.y);
    CGPoint midUpPt = CGPointMake(fucusPt.x, fucusPt.y-height*0.5);
    CGPoint rightPt = CGPointMake(fucusPt.x+width*0.5, fucusPt.y);
    CGPoint midDownPt = CGPointMake(fucusPt.x, fucusPt.y+height*0.5);
    CGPoint leftupCpt = CGPointMake(leftPt.x, midUpPt.y);
    CGPoint rightupCpt = CGPointMake(rightPt.x, midUpPt.y);
    CGPoint leftdownCpt = CGPointMake(leftPt.x, midDownPt.y);
    CGPoint rightdownCpt = CGPointMake(rightPt.x, midDownPt.y);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:leftPt];
    [path addQuadCurveToPoint:midUpPt controlPoint:leftupCpt];
    [path addQuadCurveToPoint:rightPt controlPoint:rightupCpt];
    [path addQuadCurveToPoint:midDownPt controlPoint:rightdownCpt];
    [path addQuadCurveToPoint:leftPt controlPoint:leftdownCpt];
    [path closePath];
    
    if ([path containsPoint:touchPt]) {
        if (_delegate && [_delegate respondsToSelector:@selector(didTouchMaskView:)]) {
            [_delegate didTouchMaskView:self];
        }else{
            [self removeFromSuperview];
        }
    }
}

- (void)setItem:(NHMaskItem *)item{
    _item = item;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    
    if (!_item) {
        return;
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGPoint fucusPt = _item.focusPoint;
    CGFloat width = _item.focusSize.width;CGFloat height = _item.focusSize.height;
    CGPoint leftPt = CGPointMake(fucusPt.x-width*0.5, fucusPt.y);
    CGPoint midUpPt = CGPointMake(fucusPt.x, fucusPt.y-height*0.5);
    CGPoint rightPt = CGPointMake(fucusPt.x+width*0.5, fucusPt.y);
    CGPoint midDownPt = CGPointMake(fucusPt.x, fucusPt.y+height*0.5);
    CGPoint leftupCpt = CGPointMake(leftPt.x, midUpPt.y);
    CGPoint rightupCpt = CGPointMake(rightPt.x, midUpPt.y);
    CGPoint leftdownCpt = CGPointMake(leftPt.x, midDownPt.y);
    CGPoint rightdownCpt = CGPointMake(rightPt.x, midDownPt.y);
    UIBezierPath *path = [UIBezierPath bezierPath];
    ///sketch the up area
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(0, fucusPt.y)];
    [path addLineToPoint:leftPt];
    [path addQuadCurveToPoint:midUpPt controlPoint:leftupCpt];
    [path addQuadCurveToPoint:rightPt controlPoint:rightupCpt];
    [path addLineToPoint:CGPointMake(rect.size.width, fucusPt.y)];
    [path addLineToPoint:CGPointMake(rect.size.width, 0)];
    [path addLineToPoint:CGPointZero];
    ///sketch the down area
    [path moveToPoint:CGPointMake(0, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, fucusPt.y)];
    [path addLineToPoint:leftPt];
    [path addQuadCurveToPoint:midDownPt controlPoint:leftdownCpt];
    [path addQuadCurveToPoint:rightPt controlPoint:rightdownCpt];
    [path addLineToPoint:CGPointMake(rect.size.width, fucusPt.y)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [path addLineToPoint:CGPointMake(0, rect.size.height)];
    [path closePath];
    CGContextSetFillColorWithColor(ctx, [_maskColor CGColor]);
    CGContextAddPath(ctx, path.CGPath);
    CGContextDrawPath(ctx, kCGPathFill);
    ///sketch the vertual line
    path = [UIBezierPath bezierPath];
    CGFloat offset = 5;
    leftPt.x -= offset;
    rightPt.x += offset;
    midUpPt.y -= offset;
    midDownPt.y += offset;
    leftupCpt = CGPointMake(leftPt.x, midUpPt.y);
    rightupCpt = CGPointMake(rightPt.x, midUpPt.y);
    leftdownCpt = CGPointMake(leftPt.x, midDownPt.y);
    rightdownCpt = CGPointMake(rightPt.x, midDownPt.y);
    [path moveToPoint:leftPt];
    [path addQuadCurveToPoint:midUpPt controlPoint:leftupCpt];
    [path addQuadCurveToPoint:rightPt controlPoint:rightupCpt];
    [path addQuadCurveToPoint:midDownPt controlPoint:rightdownCpt];
    [path addQuadCurveToPoint:leftPt controlPoint:leftdownCpt];
    [path closePath];
    CGFloat dash[] = {5, 5};
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
    CGContextSetLineDash(ctx, 0, dash, 2);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
    
    ///sketch the arrow
    path = [UIBezierPath bezierPath];
    CGPoint cutPt;
    if (fucusPt.x < rect.size.width*0.5) {
        ///left side
        CGPoint startPt = CGPointMake(rightdownCpt.x-width*0.2, rightdownCpt.y-height*0.1);
        CGPoint ctrPt = CGPointMake(rightdownCpt.x+width*0.15, rightdownCpt.y);
        CGPoint endPt = CGPointMake(rightdownCpt.x+width*0.25, rightdownCpt.y+height*0.25);
        [path moveToPoint:startPt];
        [path addQuadCurveToPoint:endPt controlPoint:ctrPt];
        //[path closePath];
        CGContextAddPath(ctx, path.CGPath);
        CGContextStrokePath(ctx);
        cutPt = CGPointMake(rightdownCpt.x+width*0.25, rightdownCpt.y+height*0.25);;
        CGFloat tmp_len = 5;
        CGFloat tmp_mid = 10;
        CGFloat tmp_ang = 30*M_PI/180;
        CGFloat tmp_res_ang = 60*M_PI/180;
        CGPoint left = CGPointMake(cutPt.x+tmp_len*cos(tmp_ang), cutPt.y-tmp_len*sin(tmp_ang));
        CGPoint end = CGPointMake(cutPt.x+tmp_mid*cos(tmp_res_ang), cutPt.y+tmp_mid*sin(tmp_res_ang));
        CGPoint right = CGPointMake(cutPt.x-tmp_len*cos(tmp_ang), cutPt.y+tmp_len*sin(tmp_ang));
        path = [UIBezierPath bezierPath];
        [path moveToPoint:cutPt];
        [path addLineToPoint:left];
        [path addLineToPoint:end];
        [path addLineToPoint:right];
        [path addLineToPoint:cutPt];
        [path closePath];
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextAddPath(ctx, path.CGPath);
        CGContextFillPath(ctx);
        
        ///draw text
        NSString *info = _item.info;
        UIFont *font = [UIFont systemFontOfSize:18];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    font,NSFontAttributeName,
                                    [UIColor whiteColor],NSForegroundColorAttributeName, nil];
        CGSize textSize = [info sizeWithAttributes:attributes];
        CGRect infoRect = CGRectMake(end.x-textSize.width*0.5, end.y+offset, textSize.width, textSize.height);
        [info drawInRect:infoRect withAttributes:attributes];
        
        ///draw image
        CGFloat scale = [UIScreen mainScreen].scale;
        UIImage *image = _item.image;
        CGSize imgSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
        infoRect.origin = CGPointMake(rightPt.x-imgSize.width, fucusPt.y-offset*4);
        infoRect.size = imgSize;
        //CGContextTranslateCTM(ctx, 0, rect.size.height);
        //CGContextScaleCTM(ctx, 1.0, -1.0);
        //CGContextDrawImage(ctx, infoRect, image.CGImage);
        UIGraphicsPushContext( ctx );
        [image drawInRect:infoRect];
        UIGraphicsPopContext();
    }else{
        ///right side
        CGPoint startPt = CGPointMake(leftdownCpt.x+width*0.2, leftdownCpt.y-height*0.1);
        CGPoint ctrPt = CGPointMake(leftdownCpt.x-width*0.15, leftdownCpt.y);
        CGPoint endPt = CGPointMake(leftdownCpt.x-width*0.25, leftdownCpt.y+height*0.25);
        [path moveToPoint:startPt];
        [path addQuadCurveToPoint:endPt controlPoint:ctrPt];
        //[path closePath];
        CGContextAddPath(ctx, path.CGPath);
        CGContextStrokePath(ctx);
        cutPt = endPt;
        CGFloat tmp_len = 5;
        CGFloat tmp_mid = 10;
        CGFloat tmp_ang = 30*M_PI/180;
        CGFloat tmp_res_ang = 60*M_PI/180;
        CGPoint left = CGPointMake(cutPt.x+tmp_len*cos(tmp_ang), cutPt.y+tmp_len*sin(tmp_ang));
        CGPoint end = CGPointMake(cutPt.x-tmp_mid*cos(tmp_res_ang), cutPt.y+tmp_mid*sin(tmp_res_ang));
        CGPoint right = CGPointMake(cutPt.x-tmp_len*cos(tmp_ang), cutPt.y-tmp_len*sin(tmp_ang));
        path = [UIBezierPath bezierPath];
        [path moveToPoint:cutPt];
        [path addLineToPoint:left];
        [path addLineToPoint:end];
        [path addLineToPoint:right];
        [path addLineToPoint:cutPt];
        [path closePath];
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextAddPath(ctx, path.CGPath);
        CGContextFillPath(ctx);
        
        ///draw text
        NSString *info = _item.info;
        UIFont *font = [UIFont systemFontOfSize:18];
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    font,NSFontAttributeName,
                                    [UIColor whiteColor],NSForegroundColorAttributeName, nil];
        CGSize textSize = [info sizeWithAttributes:attributes];
        CGRect infoRect = CGRectMake(end.x-textSize.width*0.5, end.y+offset, textSize.width, textSize.height);
        [info drawInRect:infoRect withAttributes:attributes];
        
        ///draw image
        UIImage *image = _item.image;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize imgSize = CGSizeMake(image.size.width/scale, image.size.height/scale);
        infoRect.origin = CGPointMake(rightPt.x-offset*6, fucusPt.y-offset*4);
        infoRect.size = imgSize;
        //CGContextTranslateCTM(ctx, 0, rect.size.height);
        //CGContextScaleCTM(ctx, 1.0, -1.0);
        //CGContextDrawImage(ctx, infoRect, image.CGImage);
        UIGraphicsPushContext( ctx );
        [image drawInRect:infoRect];
        UIGraphicsPopContext();
    }
}

@end
