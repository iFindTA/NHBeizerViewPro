//
//  NHMaskView.h
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/9/14.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NHMaskItem : NSObject

@property (nonatomic, assign) CGPoint focusPoint;
@property (nonatomic, assign) CGSize focusSize;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *info;

@end

@protocol NHMaskDelegate;

@interface NHMaskView : UIView

@property (nonatomic, strong)NHMaskItem *item;

@property (nonatomic, assign) id<NHMaskDelegate> delegate;

@end

@protocol NHMaskDelegate <NSObject>
@optional
- (void)didTouchMaskView:(NHMaskView *)mask;

@end
