//
//  NHBallView.h
//  NHBeizerViewPro
//
//  Created by hu jiaju on 16/3/31.
//  Copyright © 2016年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHBallView : UIView

/**
 *  @brief value should be 0-1
 */
@property (nonatomic, assign) CGFloat percent;

/**
 *  @brief refresh ball
 *
 *  @param percent 0-1 
 */
- (void)updateDisplayPercent:(CGFloat)percent;

@end
