//
//  NHDashBoardView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/10/21.
//  Copyright © 2015年 hu jiaju. All rights reserved.
//

#import "NHDashBoardView.h"
#import "UICountingLabel.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define CELLMARKNUM    2
#define CELLNUM        10

@interface NHDashBoardView ()

@end

@implementation NHDashBoardView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gaugeValue = 0.f;
    }
    return self;
}

/*
 * parseToX 角度转弧度
 * @angel CGFloat 角度
 */
-(CGFloat)transToRadian:(CGFloat)angel
{
    return angel*M_PI/180;
}

/*
 * parseToX 根据角度，半径计算X坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*cos(tempRadian);
}

/*
 * parseToY 根据角度，半径计算Y坐标
 * @radius CGFloat 半径
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*sin(tempRadian);
}

- (void)rotateContext:(CGContextRef)context fromCenter:(CGPoint)center_ withAngle:(CGFloat)angle {
    CGContextTranslateCTM(context, center_.x, center_.y);
    CGContextRotateCTM(context, angle);
    CGContextTranslateCTM(context, -center_.x, -center_.y);
}

- (void)drawRect:(CGRect)rect {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [[UIColor orangeColor] setFill];
    [RGB(212, 68, 46) setFill];
    CGContextFillRect(ctx, rect);
    CGFloat offset = 20;
    rect = CGRectInset(rect, offset, offset);
    
    NSInteger totalNums = CELLNUM;
    CGFloat maxAngle = 360+offset;
    CGFloat minAngle = 180-offset;
    CGFloat angelDis = (maxAngle - minAngle)/totalNums;
    CGFloat radius = rect.size.width*0.5;
    CGFloat currentAngle;
    CGPoint centerPoint = CGPointMake(offset+radius, offset+radius);
    CGFloat circleWidth = 15;
    CGFloat lineWidth = 1;
    BOOL clockwise = true;
//    [self rotateContext:ctx fromCenter:centerPoint withAngle:[self transToRadian:180]];
    
    NSArray *marksArr = [NSArray arrayWithObjects:
                         @"0",
                         @"菜鸟",
                         @"1000",
                         @"新手",
                         @"5000",
                         @"达人",
                         @"10000",
                         @"大咖",
                         @"50000",
                         @"神",
                         @"", nil];
    
    UIColor *bgColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:minAngle*M_PI/180.0 endAngle:maxAngle*M_PI/180.0 clockwise:clockwise];
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [bgColor CGColor]);
    CGContextStrokePath(ctx);
    
    radius -= offset;
    path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:minAngle*M_PI/180.0 endAngle:maxAngle*M_PI/180.0 clockwise:clockwise];
    CGContextSetLineWidth(ctx, circleWidth);
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetStrokeColorWithColor(ctx, [bgColor CGColor]);
    CGContextStrokePath(ctx);
    
    ///10段分割线 偶数画出
    for (int i = 0; i <= totalNums; i ++) {
        
        currentAngle = minAngle + i * angelDis ;
//        NSLog(@"angle:%f",currentAngle);
        CGContextSetStrokeColorWithColor(ctx, [bgColor CGColor]);
        if( i%CELLMARKNUM == 0 && i != 0 && i != totalNums) {
            CGContextSetLineWidth(ctx, lineWidth);
            CGContextSetLineCap(ctx, kCGLineCapSquare);
            CGContextStrokePath(ctx);
            CGContextMoveToPoint(ctx,centerPoint.x+[self parseToX:(radius+circleWidth/2-1) Angle:currentAngle], centerPoint.y+[self parseToY:(radius+circleWidth/2-1) Angle:currentAngle]);
            CGContextAddLineToPoint(ctx,centerPoint.x+[self parseToX:(radius-circleWidth/2+1) Angle:currentAngle], centerPoint.y+[self parseToY:(radius-circleWidth/2+1) Angle:currentAngle]);
            CGContextStrokePath(ctx);
        }
    }
    
    currentAngle = 0;
    CGFloat markFont = 11;
    CGFloat textRadius = radius-circleWidth/2-offset*0.25;
    for (int i = 0; i <= totalNums; i ++) {
        currentAngle = minAngle + i * angelDis ;
        /// draw text
        NSString *markInfo = [marksArr objectAtIndex:i];
        UIFont* font = [UIFont fontWithName:@"Helvetica" size:markFont];
        NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : bgColor };
        CGSize textSize = [markInfo sizeWithAttributes:stringAttrs];
        
        CGPoint text_center = CGPointMake(centerPoint.x+[self parseToX:textRadius Angle:currentAngle], centerPoint.y+[self parseToY:textRadius Angle:currentAngle]);
        
//        NSLog(@"angle:%f---mark info:%@---point:%@",currentAngle,markInfo,NSStringFromCGPoint(text_center));
        CGFloat rotateAngle = minAngle+i*angelDis+90;
        
        ///修正到中心
        text_center.x -= textSize.width*0.5*cos([self transToRadian:rotateAngle]);
        text_center.y -= textSize.width*0.5*sin([self transToRadian:rotateAngle]);
        
        CGContextSaveGState(ctx);
        [self rotateContext:ctx fromCenter:text_center withAngle:[self transToRadian:rotateAngle]];
        [markInfo drawAtPoint:text_center withAttributes:stringAttrs];
        CGContextRestoreGState(ctx);
    }
    
    ///已获收益
    NSString *markInfo = @"已获收益（元）";
    UIFont *tmpFont = [UIFont systemFontOfSize:markFont*1.5];
    NSDictionary *stringAttrs = @{ NSFontAttributeName : tmpFont, NSForegroundColorAttributeName : bgColor };
    CGSize infoSize = [markInfo sizeWithAttributes:stringAttrs];
    CGPoint infoPt = CGPointMake(centerPoint.x-infoSize.width*0.5, centerPoint.y-offset*3);
    [markInfo drawAtPoint:infoPt withAttributes:stringAttrs];
    
    ///收益
    UIColor *tmpColor = [UIColor whiteColor];
    markInfo = [NSString stringWithFormat:@"%.2f",_gaugeValue];
    tmpFont = [UIFont boldSystemFontOfSize:markFont*3];
    stringAttrs = @{ NSFontAttributeName : tmpFont, NSForegroundColorAttributeName : tmpColor };
    infoSize = [markInfo sizeWithAttributes:stringAttrs];
    infoPt = CGPointMake(centerPoint.x-infoSize.width*0.5, centerPoint.y-offset*1.2);
//    [markInfo drawAtPoint:infoPt withAttributes:stringAttrs];
    CGRect infoRect ;
    infoRect.origin = CGPointMake(0, infoPt.y);
    infoRect.size = CGSizeMake(self.bounds.size.width, infoSize.height);
    UICountingLabel *label = [[UICountingLabel alloc] initWithFrame:infoRect];
    label.backgroundColor = [UIColor clearColor];
    label.font = tmpFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = tmpColor;
    label.text = markInfo;
    label.format = @"%.2f";
    [self addSubview:label];
    
    ///菜鸟、达人、大咖
    radius += offset;
//    CGPoint startPoint = CGPointMake(centerPoint.x+radius*cos([self transToRadian:minAngle]), centerPoint.y+radius*sin([self transToRadian:minAngle]));
    CGFloat dstAngle = minAngle;CGFloat duration = 2;
    if (_gaugeValue < 1000) {
        ///菜鸟
        markInfo = @"人脉菜鸟";
        dstAngle += angelDis*2*_gaugeValue/1000.f+0.1;
    }else if (_gaugeValue >= 1000 && _gaugeValue < 5000){
        ///新手
        markInfo = @"人脉新手";
        dstAngle += angelDis*2;
        dstAngle += angelDis*2*((_gaugeValue-1000)/(5000.f-1000));
        duration += 1*1.5;
    }else if (_gaugeValue >= 5000 && _gaugeValue < 10000){
        ///达人
        markInfo = @"人脉达人";
        dstAngle += angelDis*4;
        dstAngle += angelDis*2*((_gaugeValue-5000)/(10000.f-5000));
        duration += 1*2;
    }else if (_gaugeValue >= 10000 && _gaugeValue < 50000){
        ///大咖
        markInfo = @"人脉大咖";
        dstAngle += angelDis*6;
        dstAngle += angelDis*2*((_gaugeValue-10000)/(50000.f-10000));
        duration += 1*2.5;
    }else if (_gaugeValue >= 50000 ){
        ///神
        markInfo = @"人脉神人也";
        dstAngle += angelDis*8;
        dstAngle += angelDis*2*(MIN(1, ((_gaugeValue-50000)/(100000.f-50000))));
        duration += 1*3;
    }
    tmpFont = [UIFont systemFontOfSize:markFont*2];
    stringAttrs = @{ NSFontAttributeName : tmpFont, NSForegroundColorAttributeName : bgColor };
    infoSize = [markInfo sizeWithAttributes:stringAttrs];
    infoPt = CGPointMake(centerPoint.x-infoSize.width*0.5, centerPoint.y+offset);
    [markInfo drawAtPoint:infoPt withAttributes:stringAttrs];
    
    ///球球
    CGPoint endPoint = CGPointMake(centerPoint.x+radius*cos([self transToRadian:dstAngle]), centerPoint.y+radius*sin([self transToRadian:dstAngle]));
//    NSLog(@"dstAngle:%f",dstAngle);
    infoRect.origin = CGPointZero;
    infoRect.size = CGSizeMake(lineWidth*5, lineWidth*5);
    path = [UIBezierPath bezierPath];
    [path addArcWithCenter:centerPoint radius:radius startAngle:minAngle*M_PI/180.0 endAngle:dstAngle*M_PI/180.0 clockwise:clockwise];
//    CGContextSetLineWidth(ctx, lineWidth);
//    CGContextAddPath(ctx, path.CGPath);
//    CGContextSetStrokeColorWithColor(ctx, [[UIColor blueColor] CGColor]);
//    CGContextStrokePath(ctx);
    
    CAShapeLayer *ball = [CAShapeLayer layer];
    ball.bounds = infoRect;
    ball.cornerRadius = infoRect.size.width*0.5;
    ball.masksToBounds = true;
    ball.backgroundColor = tmpColor.CGColor;
    ball.position = endPoint;
    ball.path = [path CGPath];
    [self.layer addSublayer:ball];
    
    /* 差分计算
    NSMutableArray *keyFrames = [NSMutableArray array];
    int i = minAngle;
    while (i <= dstAngle) {
        
        CGPoint tmpPt = CGPointMake(centerPoint.x+radius*cos([self transToRadian:i]), centerPoint.y+radius*sin([self transToRadian:i]));
        [keyFrames addObject:[NSValue valueWithCGPoint:tmpPt]];
        i += 2;
    }
    NSLog(@"key frames count:%zd",[keyFrames count]);
    //*/
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    animation.duration = duration;
    animation.calculationMode = kCAAnimationLinear;
    animation.repeatCount = 1;
    animation.removedOnCompletion = false;
    animation.autoreverses = false;
//    animation.values = keyFrames;
    animation.path = [path CGPath];
    [ball addAnimation:animation forKey:@"animation"];
    
    
    ///渐变
    
    ///滚动显示
    [label countFromCurrentValueTo:_gaugeValue withDuration:duration];
}

- (void) drawStringAtContext:(CGContextRef) context string:(NSString*)text withCenter:(CGPoint)center_ radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle
{
    CGContextSaveGState(context);
    
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:0.05];
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor] };
    CGSize textSize = [text sizeWithAttributes:stringAttrs];
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = textSize.width / perimeter * 2 * M_PI ;
    float offset = ((endAngle - startAngle) - textAngle) / 2.0;
    
    float letterPosition = 0;
    NSString *lastLetter = @"";
    
    [self rotateContext:context fromCenter:center_ withAngle:startAngle + offset];
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:letter attributes:stringAttrs];
        CGSize charSize = [letter sizeWithAttributes:stringAttrs];
        
        float totalWidth = [[NSString stringWithFormat:@"%@%@", lastLetter, letter] sizeWithAttributes:stringAttrs].width;
        float currentLetterWidth = [letter sizeWithAttributes:stringAttrs].width;
        float lastLetterWidth = [lastLetter sizeWithAttributes:stringAttrs].width;
        float kerning = (lastLetterWidth) ? 0 : ((currentLetterWidth + lastLetterWidth) - totalWidth);
        
        letterPosition += (charSize.width / 2) - kerning;
        float angle = (letterPosition / perimeter * 2 * M_PI) ;
        CGPoint letterPoint = CGPointMake((radius - charSize.height / 2.0) * cos(angle) + center_.x, (radius - charSize.height / 2.0) * sin(angle) + center_.y);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, letterPoint.x, letterPoint.y);
        CGAffineTransform rotationTransform = CGAffineTransformMakeRotation(angle + M_PI_2);
        CGContextConcatCTM(context, rotationTransform);
        CGContextTranslateCTM(context, -letterPoint.x, -letterPoint.y);
        
        [attrStr drawAtPoint:CGPointMake(letterPoint.x - charSize.width/2 , letterPoint.y - charSize.height)];
        
        CGContextRestoreGState(context);
        
        letterPosition += charSize.width / 2;
        lastLetter = letter;
    }
    CGContextRestoreGState(context);
}

- (void)setGaugeValue:(CGFloat)gaugeValue {
    if (_gaugeValue != gaugeValue) {
        _gaugeValue = MAX(0, gaugeValue);
        
        [self setNeedsDisplay];
    }
}

@end
