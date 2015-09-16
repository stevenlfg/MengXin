//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class    CycleScrollView;
@protocol CycleScrollViewDelegate<NSObject>
@optional
-(void)cycleScrollView:(CycleScrollView*)view isScrolled:(BOOL)isFinished;
-(void)cycleScrollView:(CycleScrollView*)view scrollPercentage:(float)percent currentPage:(NSInteger)page isUp:(BOOL)isUp;
@end
@interface CycleScrollView : UIView

@property (nonatomic , readonly) UIScrollView *scrollView;
/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , copy) NSInteger (^totalPagesCount)(void);
/**
 数据源：获取第pageIndex个位置的contentView
 **/
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);
/**
 当点击的时候，执行的block
 **/
@property (nonatomic , copy) void (^TapActionBlock)(NSInteger pageIndex);
/**
  滚动的delegate
 **/
@property (nonatomic , assign) id<CycleScrollViewDelegate>delegate;
/**
 滚动到下一页
 **/
-(void)gotoNextPage;
@end