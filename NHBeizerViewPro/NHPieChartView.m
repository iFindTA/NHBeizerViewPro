//
//  NHPieChartView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/9/7.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import "NHPieChartView.h"
#import <AdSupport/ASIdentifierManager.h>
CGFloat const NHPieChartMargin = 50;

@interface NHPieitem : NSObject

@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, assign) int pieIdx;
@property (nonatomic, assign) CGFloat value,start_ang,end_ang;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, copy) NSString *title;

@end

@implementation NHPieitem

@end

@interface NHPieChartView ()

@property (nonatomic, assign)CGFloat totalVal;
@property (nonatomic, strong)UIFont *titleFont;
@property (nonatomic, strong)UIColor *titleColor;
@property (nonatomic, strong)NSMutableArray *dataInfos;

@end

@implementation NHPieChartView

- (id)initWithFrame:(CGRect)frame {
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

- (void)_initSetup {
    self.titleFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    self.titleColor = [UIColor lightGrayColor];
}

- (void)setDataSource:(id<NHPieChartDataSource>)dataSource {
    
    NSAssert(dataSource != nil, @"PieChart DataSource Cannot be nil !");
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        [self setNeedsDisplay];
    }
    
}

- (void)reloadData {
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    //NSLog(@"touch point:%@",NSStringFromCGPoint(point));
    CGSize size = self.bounds.size;
    CGFloat R = MIN(size.width, size.height);
    CGFloat center_x = R*0.5;
    CGFloat center_y = R*0.5;
    R = R-NHPieChartMargin*2;
    CGFloat r = R*0.5;
    int abs_x = abs((int)(point.x-center_x));
    int abs_y = abs((int)(point.y-center_y));
    CGFloat dis = sqrt(abs_x*abs_x+abs_y*abs_y);
    if (dis >= r) {
        NSLog(@"not in the circle");
        return;///不在圆内
    }
    
    CGFloat x1 = point.x-center_x;
    CGFloat y1 = center_y-point.y;
    CGFloat theta;
    theta = atan2(y1, x1)*180/M_PI;
    if (theta < 0) {
        theta = -theta;
    }else{
        theta = 360 - theta;
    }
    
    @synchronized(_dataInfos){
        NSInteger count = [_dataInfos count];
        CGFloat start_ang = 0;
        CGFloat end_ang = 0;
        //BOOL clockwise = false;//顺时针
        for (int i = 0; i < count; i++) {
            NHPieitem *item = [_dataInfos objectAtIndex:i];
            CGFloat percent = item.value/_totalVal;
            CGFloat angle = percent*360;
            end_ang = start_ang + angle;
            
            if (theta > start_ang && theta < end_ang) {
                //NSLog(@"touch sector:%d :%f--%f---%f",i,start_ang,end_ang,theta);
                if (_delegate && [_delegate respondsToSelector:@selector(pieChart:didSelectIndex:)]) {
                    [_delegate pieChart:self didSelectIndex:i];
                }
                break;
            }
            
//            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:r startAngle:start_ang*M_PI/180.0 endAngle:end_ang*M_PI/180.0 clockwise:clockwise];
//            [path addLineToPoint:center];
//            [path closePath];
//            if ([path containsPoint:point]) {
//                NSLog(@"touch sector:%@ index:%d--%d",item.index,i,item.pieIdx);
//                break;
//            }
            
            start_ang = end_ang;
        }
    }
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}




// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (_dataSource == nil) {
        return;
    }
    
    if (![_dataSource respondsToSelector:@selector(numberInPieChart:)]) {
        NSLog(@"numberInPieChart: Method must be implemented !");
        return;
    }
    
    NSInteger numall = [_dataSource numberInPieChart:self];
    if (numall < 1) {
        NSLog(@"pieChart's number must more than one part !");
        return;
    }
    
    CGSize size = self.bounds.size;
    CGFloat R = MIN(size.width, size.height);
    if (R < NHPieChartMargin*4) {
        NSLog(@"pieChart Super View Bounds size must more than %f !",NHPieChartMargin*4);
        return;
    }
    
    CGFloat center_x = R*0.5;
    CGFloat center_y = R*0.5;
    R = R-NHPieChartMargin*2;
    CGFloat r = R*0.5;
    if (_dataInfos || [_dataInfos count]) {
        [_dataInfos removeAllObjects];
        _dataInfos = nil;
    }
    _dataInfos = [[NSMutableArray alloc] initWithCapacity:0];
    NHPieitem *item;_totalVal = 0;
    for (int i = 0; i < numall; i ++) {
        item = [[NHPieitem alloc] init];
        
        item.pieIdx = i;
        [item setIndex:[NSNumber numberWithInt:i]];
        
        CGFloat value = [_dataSource pieChart:self valueForIndex:i];
        item.value = value;_totalVal += value;
        
        UIColor *color = [_dataSource pieChart:self colorForIndex:i];
        item.color = color;
        
        if ([_dataSource respondsToSelector:@selector(pieChart:titleForIndex:)]) {
            NSString *title = [_dataSource pieChart:self titleForIndex:i];
            item.title = title;
        }
        [_dataInfos addObject:item];
    }
    
    //start drawing
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(ctx);
    CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);  // white color
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), NHPieChartMargin);
    CGContextFillEllipseInRect(ctx, CGRectMake(NHPieChartMargin, NHPieChartMargin, R, R));  // a white filled circle with a diameter of 100 pixels, centered in (60, 60)
    UIGraphicsPopContext();
    CGContextSetShadow(ctx, CGSizeMake(0.0f, 0.0f), 0);
    
    CGFloat start_ang = 0;
    CGFloat end_ang = 0;
    CGFloat pie_gap = 1;
    BOOL clockwise = false;//顺时针
    CGFloat offset_angle = 60*M_PI/180;
    for (int i = 0; i < numall; i++) {
        NHPieitem *item = [_dataInfos objectAtIndex:i];
        CGFloat percent = item.value/_totalVal;
        CGFloat angle = percent*360;
        end_ang = start_ang + angle;
        item.start_ang = start_ang;
        item.end_ang = end_ang;
        
        ///draw sector
        CGContextSetFillColorWithColor(ctx, [item.color CGColor]);
        CGContextMoveToPoint(ctx, center_x, center_y);
        CGContextAddArc(ctx, center_x, center_y, r, start_ang*M_PI/180.0, end_ang*M_PI/180.0, clockwise);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(center_x, center_y) radius:r startAngle:start_ang*M_PI/180.0 endAngle:end_ang*M_PI/180.0 clockwise:clockwise];
        [path addLineToPoint:CGPointMake(center_x, center_y)];
        [path closePath];
        //CGContextAddPath(ctx, path.CGPath);
        //[[UIColor blackColor] setFill];
        //CGContextDrawPath(ctx, kCGPathFill);
        
        /// draw white line
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
        CGContextSetLineWidth(ctx, pie_gap);
        CGContextMoveToPoint(ctx, center_x, center_y);
        CGContextAddArc(ctx, center_x, center_y, r, start_ang*M_PI/180.0, end_ang*M_PI/180.0, clockwise);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        
        //sector center
        CGFloat dst_angle = (angle*0.5 + start_ang)*M_PI/180;
        CGFloat center_sector_x = r*0.75*cos(dst_angle) + center_x;
        CGFloat center_sector_y = r*0.75*sin(dst_angle) + center_y;
        
        [[UIColor lightGrayColor] setStroke];
        CGContextSetLineWidth(ctx, 1);
        CGContextMoveToPoint(ctx, center_sector_x, center_sector_y);
        //CGContextAddArc(ctx, center_sector_x, center_sector_y, 5, 0, M_PI*2, 0);
        
        ///draw text
        NSString *info = item.title;
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.titleFont,NSFontAttributeName,
                                    self.titleColor,NSForegroundColorAttributeName, nil];
        CGSize textSize = [info sizeWithAttributes:attributes];
        CGRect infoRect = CGRectMake(0, 0, textSize.width, textSize.height);
        CGFloat abs_offset_len = r*0.4;
        CGFloat abs_x_offset = abs_offset_len*cos(offset_angle);
        CGFloat abs_y_offset = abs_offset_len*sin(offset_angle);
        CGFloat mid_sector_x;CGFloat mid_sector_y;
        CGFloat end_sector_x;CGFloat end_sector_y;
        CGFloat text_len = r*0.45;
        CGFloat info_offset_x = textSize.width;
        CGFloat info_offset_y = textSize.height;
        //Quadrant
        if (dst_angle > 0 && dst_angle <= M_PI_2) {
            ///第四象限
            mid_sector_x = center_sector_x + abs_x_offset;
            mid_sector_y = center_sector_y + abs_y_offset;
            end_sector_x = mid_sector_x + text_len;
            end_sector_y = mid_sector_y;
            infoRect.origin = CGPointMake(mid_sector_x, mid_sector_y-info_offset_y);
        }else if (dst_angle > M_PI_2 && dst_angle <= M_PI){
            ///第三象限
            mid_sector_x = center_sector_x - abs_x_offset;
            mid_sector_y = center_sector_y + abs_y_offset;
            end_sector_x = mid_sector_x - text_len;
            end_sector_y = mid_sector_y;
            infoRect.origin = CGPointMake(mid_sector_x-info_offset_x, mid_sector_y-info_offset_y);
        }else if (dst_angle > M_PI && dst_angle <= M_PI*1.5){
            ///第二象限
            mid_sector_x = center_sector_x - abs_x_offset;
            mid_sector_y = center_sector_y - abs_y_offset;
            end_sector_x = mid_sector_x - text_len;
            end_sector_y = mid_sector_y;
            infoRect.origin = CGPointMake(mid_sector_x-info_offset_x, mid_sector_y-info_offset_y);
        }else if (dst_angle > M_PI*1.5 && dst_angle <= M_PI*2){
            ///第一象限
            mid_sector_x = center_sector_x + abs_x_offset;
            mid_sector_y = center_sector_y - abs_y_offset;
            end_sector_x = mid_sector_x + text_len;
            end_sector_y = mid_sector_y;
            infoRect.origin = CGPointMake(mid_sector_x, mid_sector_y-info_offset_y);
        }
        CGContextAddLineToPoint(ctx, mid_sector_x, mid_sector_y);
        CGContextAddLineToPoint(ctx, end_sector_x, end_sector_y);
        //CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
        
        [info drawInRect:infoRect withAttributes:attributes];
        
        
        start_ang = end_ang;
    }
}

@end
