//
//  NHSectorView.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/8/19.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import "NHSectorView.h"

@interface NHShapeLayer : CAShapeLayer

@property (nonatomic, strong)UIBezierPath *bezierPath;
@property (nonatomic, assign)CGPathRef pathRef;

@end

@implementation NHShapeLayer

@end

@interface NHSectorView ()<UIApplicationDelegate>

@property (nonatomic, strong)NHShapeLayer *shapelayer;
@property (nonatomic, strong)NHShapeLayer *shapeLayer2;
@property (nonatomic, strong)NSMutableArray *layers;

@end

@implementation NHSectorView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setupInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setupInit];
    }
    
    return self;
}

- (void)_setupInit{
    
    _layers = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (!_shapelayer) {
        _shapelayer = [NHShapeLayer layer];
        _shapelayer.lineWidth = 40;
        _shapelayer.lineCap = kCALineCapButt;
        _shapelayer.strokeColor = [UIColor blueColor].CGColor;
        _shapelayer.fillColor = nil;
    }
    if (_shapelayer) {
        [_shapelayer removeAllAnimations];
    }
    
    self.clipsToBounds = true;
    [self.layer addSublayer:_shapelayer];
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathAddArc(pathRef, &CGAffineTransformIdentity, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 80, 0, M_PI*0.25, false);
    _shapelayer.path = pathRef;
    _shapelayer.pathRef = pathRef;
    _shapelayer.bezierPath = [UIBezierPath bezierPathWithCGPath:pathRef];
    [_layers addObject:_shapelayer];
    
//    //animate for shape layer
//    CABasicAnimation *pathAnimate = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimate.duration = 1.0f;
//    pathAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    pathAnimate.fromValue = [NSNumber numberWithFloat:0];
//    pathAnimate.toValue = [NSNumber numberWithFloat:1.0f];
//    pathAnimate.autoreverses = false;
//    pathAnimate.fillMode = kCAFillModeForwards;
//    pathAnimate.repeatCount = 1;
//    [_shapelayer addAnimation:pathAnimate forKey:@"strokeEndAnimation"];
//    _shapelayer.strokeEnd = 1.0f;
//    pathAnimate.delegate = self;
    
    _shapeLayer2 = [NHShapeLayer layer];
    _shapeLayer2.lineWidth = 40;
    _shapeLayer2.lineCap = kCALineCapButt;
    _shapeLayer2.strokeColor = [UIColor greenColor].CGColor;
    _shapeLayer2.fillColor = nil;
    [self.layer addSublayer:_shapeLayer2];
    
    pathRef = CGPathCreateMutable();
    CGPathAddArc(pathRef, &CGAffineTransformIdentity, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 80, M_PI*0.25, M_PI*1.6, false);
    _shapeLayer2.path = pathRef;
    _shapeLayer2.strokeEnd = 1.0f;
    _shapeLayer2.pathRef = pathRef;
    _shapeLayer2.bezierPath = [UIBezierPath bezierPathWithCGPath:pathRef];
    [_layers addObject:_shapeLayer2];
    
    //mask layer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.lineWidth = 40;
    maskLayer.lineCap = kCALineCapButt;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeStart = 0;
    maskLayer.strokeEnd = 1.0f;
    pathRef = CGPathCreateMutable();
    CGPathAddArc(pathRef, &CGAffineTransformIdentity, CGRectGetWidth(self.frame)*0.5, CGRectGetHeight(self.frame)*0.5, 80, 0, M_PI*1.6, false);
    maskLayer.path = pathRef;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1.0f;
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.removedOnCompletion = true;
    [maskLayer addAnimation:animation forKey:@"maskAnimation"];
    self.layer.mask = maskLayer;
    
    UITapGestureRecognizer *tapEvent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    tapEvent.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapEvent];
}

- (void)tapEvent:(UITapGestureRecognizer *)gesture {
    CGPoint location = [gesture locationInView:gesture.view];
    for (NHShapeLayer *layer in _layers) {
//        if ([layer.bezierPath containsPoint:location]) {
//            NSLog(@"touched layer");
//            break;
//        }
        if (CGPathContainsPoint(layer.pathRef, nil, location, false)) {
            NSLog(@"touch touch touch");
            break;
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animationDidStop");
}

@end
