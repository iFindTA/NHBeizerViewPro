//
//  NHPieChartView.h
//  NHBeizerViewPro
//
//  Created by hu jiaju on 15/9/7.
//  Copyright (c) 2015年 hu jiaju. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NHBlock)(NSInteger index,NSString *tittle);

@protocol NHPieChartDelegate;
@protocol NHPieChartDataSource;

@interface NHPieChartView : UIView

@property (nonatomic, assign)id<NHPieChartDataSource> dataSource;

@property (nonatomic, assign)id<NHPieChartDelegate> delegate;

- (void)reloadData;

@end

@protocol NHPieChartDataSource <NSObject>

@required

/**
 *	@brief	number info
 *
 *	@param 	view 	pie chart view
 *
 *	@return	numbers in pie chart view
 */
- (NSInteger)numberInPieChart:(NHPieChartView *)view;


/**
 *	@brief	data info
 *
 *	@param 	view 	pie chart view
 *	@param 	index 	item index
 *
 *	@return	pie item value > 0
 */
- (CGFloat)pieChart:(NHPieChartView *)view valueForIndex:(NSInteger)index;

/**
 *	@brief	color info
 *
 *	@param 	view 	pie chart view
 *	@param 	index 	item index
 *
 *	@return	uicolor
 */
- (UIColor *)pieChart:(NHPieChartView *)view colorForIndex:(NSInteger)index;

@optional

/**
 *	@brief	title info
 *
 *	@param 	view 	pie chart view
 *	@param 	index 	item index
 *
 *	@return	title
 */
- (NSString *)pieChart:(NHPieChartView *)view titleForIndex:(NSInteger)index;

@end

@protocol NHPieChartDelegate <NSObject>

@optional

/**
 *	@brief	pie chart delegate
 *
 *	@param 	view 	pie chart view
 *	@param 	index 	item index
 */
- (void)pieChart:(NHPieChartView *)view didSelectIndex:(NSInteger)index;


@end

extern CGFloat const NHPieChartMargin;