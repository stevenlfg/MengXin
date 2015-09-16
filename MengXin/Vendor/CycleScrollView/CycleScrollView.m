//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"

@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        [self configContentViews];
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame),3 * CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator=NO;
        self.scrollView.showsVerticalScrollIndicator=NO;
        self.scrollView.bounces=YES;
        self.scrollView.scrollsToTop=NO;
        self.scrollView.contentOffset = CGPointMake(0,CGRectGetHeight(self.scrollView.frame));
        self.scrollView.pagingEnabled = YES;
        [self addSubview:self.scrollView];
        self.currentPageIndex = 0;
    }
    return self;
}

#pragma mark -
#pragma mark - 私有函数

- (void)configContentViews
{
    if (self.contentViews.count==1) {
        return;
    }
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
//        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(0,CGRectGetHeight(self.scrollView.frame) * (counter ++));
        contentView.frame = rightRect;
        contentView.tag=counter;
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(0,CGRectGetHeight(self.scrollView.frame))];
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float contentOffsetX = scrollView.contentOffset.y;
    NSLog(@"contentOffsetX--------%f",contentOffsetX);
    if (0<contentOffsetX&&contentOffsetX<CGRectGetHeight(scrollView.frame)) {
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollPercentage:currentPage:isUp:)]) {
            
            if ((CGRectGetHeight(scrollView.frame)-contentOffsetX)/CGRectGetHeight(scrollView.frame)>0.5) {
             [self.delegate cycleScrollView:self scrollPercentage:(CGRectGetHeight(scrollView.frame)-contentOffsetX)/CGRectGetHeight(scrollView.frame)currentPage:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1] isUp:YES];
            }else{
                [self.delegate cycleScrollView:self scrollPercentage:(CGRectGetHeight(scrollView.frame)-contentOffsetX)/CGRectGetHeight(scrollView.frame)currentPage:self.currentPageIndex isUp:YES];
            }
        }
        
        if (self.totalPageCount==2) {
            if (self.currentPageIndex==0) {
                UIView *contentView=[self.scrollView viewWithTag:3];
                CGRect rightRect = contentView.frame;
                rightRect.origin = CGPointMake(0,0);
                contentView.frame = rightRect;
                contentView.alpha=(CGRectGetHeight(scrollView.frame)-contentOffsetX)/280.0;
                UIView *contentView2=[self.scrollView viewWithTag:2];
                contentView2.alpha=1-(CGRectGetHeight(scrollView.frame)-contentOffsetX)/150.0;
            }else{
                UIView *contentView=[self.scrollView viewWithTag:3];
                CGRect rightRect = contentView.frame;
                rightRect.origin = CGPointMake(0,0);
                contentView.frame = rightRect;
                contentView.alpha=(CGRectGetHeight(scrollView.frame)-contentOffsetX)/250.0;
                UIView *contentView2=[self.scrollView viewWithTag:2];
                contentView2.alpha=1-(CGRectGetHeight(scrollView.frame)-contentOffsetX)/150.0;
            }
        }
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:isScrolled:)]) {
            [self.delegate cycleScrollView:self isScrolled:NO];
        }
    }else if (contentOffsetX>CGRectGetHeight(scrollView.frame)){
        if ((contentOffsetX-CGRectGetHeight(scrollView.frame))/CGRectGetHeight(scrollView.frame)>0.5) {
            if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollPercentage:currentPage:isUp:)]) {
                [self.delegate cycleScrollView:self scrollPercentage:(contentOffsetX-CGRectGetHeight(scrollView.frame))/CGRectGetHeight(scrollView.frame) currentPage:[self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1] isUp:NO];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollPercentage:currentPage:isUp:)]) {
                [self.delegate cycleScrollView:self scrollPercentage:(contentOffsetX-CGRectGetHeight(scrollView.frame))/CGRectGetHeight(scrollView.frame) currentPage:self.currentPageIndex isUp:NO];
            }
        }
        if (self.totalPageCount==2){
        if (self.currentPageIndex==0) {
            UIView *contentView=[self.scrollView viewWithTag:3];
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(0,self.frame.size.height*2);
            contentView.frame = rightRect;
            contentView.alpha=(contentOffsetX-CGRectGetHeight(scrollView.frame))/250.0;
            UIView *contentView2=[self.scrollView viewWithTag:2];
            contentView2.alpha=1-(contentOffsetX-CGRectGetHeight(scrollView.frame))/70.0;
        }else{
            UIView *contentView=[self.scrollView viewWithTag:3];
            CGRect rightRect = contentView.frame;
            rightRect.origin = CGPointMake(0,self.frame.size.height*2);;
            contentView.frame = rightRect;
            contentView.alpha=(contentOffsetX-CGRectGetHeight(scrollView.frame))/250.0;
            UIView *contentView2=[self.scrollView viewWithTag:2];
            contentView2.alpha=1-(contentOffsetX-CGRectGetHeight(scrollView.frame))/70.0;
        }
        }
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:isScrolled:)]) {
            [self.delegate cycleScrollView:self isScrolled:NO];
        }
    }
    if(contentOffsetX >= (2 * CGRectGetHeight(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:isScrolled:)]) {
            [self.delegate cycleScrollView:self isScrolled:YES];
        }
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollPercentage:currentPage:isUp:)]) {
            [self.delegate cycleScrollView:self scrollPercentage:1 currentPage:self.currentPageIndex isUp:NO];
        }
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:isScrolled:)]) {
            [self.delegate cycleScrollView:self isScrolled:YES];
        }
        if ([self.delegate respondsToSelector:@selector(cycleScrollView:scrollPercentage:currentPage:isUp:)]) {
            [self.delegate cycleScrollView:self scrollPercentage:1 currentPage:self.currentPageIndex isUp:YES];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [scrollView setContentOffset:CGPointMake(0,CGRectGetHeight(self.scrollView.frame)) animated:YES];
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:isScrolled:)]) {
        [self.delegate cycleScrollView:self isScrolled:YES];
    }

}

#pragma mark -
-(void)gotoNextPage
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y+CGRectGetHeight(self.scrollView.frame));
    [self.scrollView setContentOffset:newOffset animated:YES];
}
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y+ CGRectGetHeight(self.scrollView.frame));
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
