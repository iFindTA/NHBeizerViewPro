//
//  ViewController.m
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/8/6.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import "ViewController.h"
#import "NHCusView.h"
#import "NHSectorView.h"
#import "NHPieChartView.h"
#import "NHMaskView.h"
#import "NHDashBoardView.h"
#import "NHBallView.h"
#import "NHCountingHUD.h"

@interface ViewController ()<NHPieChartDataSource>

@property (nonatomic, strong) NHBallView *ball;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect infoRect = CGRectMake(100, 0, 100, 100);
    /*
    NHCusView *view = [[NHCusView alloc] initWithFrame:infoRect];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    infoRect.origin.y += 110;
    infoRect.size = CGSizeMake(200, 200);
    NHSectorView *sectorView = [[NHSectorView alloc] initWithFrame:infoRect];
    [self.view addSubview:sectorView];
    
    infoRect.origin.y += 210;
    infoRect.origin.x = 0;
    infoRect.size = self.view.bounds.size;
    NHPieChartView *pieView = [[NHPieChartView alloc] initWithFrame:infoRect];
    pieView.backgroundColor = [UIColor whiteColor];
    pieView.dataSource = self;
    [self.view addSubview:pieView];
    
    infoRect = self.view.bounds;
    NHMaskItem *item = [[NHMaskItem alloc] init];
    item.focusSize = CGSizeMake(100, 50);
    item.focusPoint = CGPointMake(self.view.bounds.size.width*0.7, 400);
    item.info = @"请点击\"立即投资\"";
    item.image = [UIImage imageNamed:@"finger.png"];
    NHMaskView *maskView = [[NHMaskView alloc] initWithFrame:infoRect];
    maskView.backgroundColor = [UIColor clearColor];
    [maskView setItem:item];
    [self.view addSubview:maskView];
    
    infoRect.origin.y += 210;
    infoRect.origin.x = 0;
    infoRect.size = CGSizeMake(350, 350);
    NHDashBoardView *dashBoard = [[NHDashBoardView alloc] initWithFrame:infoRect];
    dashBoard.gaugeValue = 19063.6;
    [self.view addSubview:dashBoard];
     
    
    infoRect.origin.y += 210;
    infoRect.size = CGSizeMake(20,20);
    CGFloat percent = 0.f;
    NHBallView *ball = [[NHBallView alloc] initWithFrame:infoRect];
    ball.backgroundColor = [UIColor whiteColor];
    ball.percent = percent;
    [self.view addSubview:ball];
    self.ball = ball;
    infoRect.origin.y += 210;
    infoRect.size = CGSizeMake(200,30);
    UISlider *slider = [[UISlider alloc] initWithFrame:infoRect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    slider.value =percent;
    [self.view addSubview:slider];
    [slider addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
     //*/
    
    NHColorBox box = {
        .bgColor = 0x1B191D,
        .bdColor = 0xD41617,
        .duration = 3.f,
        .info = [@"跳过" UTF8String]
    };
    NHCountingHUD *countHUD = [[NHCountingHUD alloc] initWithFrame:(CGRect){.origin = CGPointMake(200, 150),.size = {50,50}} withColorBox:box];
    [countHUD handleCountingEvent:^{
        NSLog(@"touch event!");
    }];
    countHUD.backgroundColor = [UIColor clearColor];
    [self.view addSubview:countHUD];
}

-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(UIColor *)randomColor{
    static BOOL seeded = NO;
    if (!seeded) {
        seeded = YES;
        srandom(time(NULL));
    }
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

- (NSInteger)numberInPieChart:(NHPieChartView *)view{
    
    return 5;
}

- (CGFloat)pieChart:(NHPieChartView *)view valueForIndex:(NSInteger)index {
    //return [self getRandomNumber:10 to:100];
    CGFloat value;
    if (index == 0) {
        value = 20;
    }else if (index == 1){
        value = 70;
    }else if (index == 2){
        value = 100;
    }else if (index == 3){
        value = 31;
    }else if (index == 4){
        value = 50;
    }
    return value;
}

- (UIColor *)pieChart:(NHPieChartView *)view colorForIndex:(NSInteger)index {
    //return [self randomColor];
    UIColor *color;
    if (index == 0) {
        color = [UIColor redColor];
    }else if (index == 1){
        color = [UIColor greenColor];
    }else if (index == 2){
        color = [UIColor cyanColor];
    }else if (index == 3){
        color = [UIColor blueColor];
    }else if (index == 4){
        color = [UIColor yellowColor];
    }
    return color;
}

- (NSString *)pieChart:(NHPieChartView *)view titleForIndex:(NSInteger)index{
    return @"10000.0";
}

- (void)slideValueChanged:(UISlider * _Nonnull)slider {
    
    self.ball.percent = slider.value;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
