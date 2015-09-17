//
//  CustomRefreshView.m
//  DJRefreshSample
//
//  Created by stevenlfg on 15/7/9.
//  Copyright (c) 2015年 ydj. All rights reserved.
//

#import "CustomRefreshView.h"

@implementation CustomRefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self) {
        
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    self.backgroundColor=[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"custom_pull_refresh"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    
    NSLayoutConstraint * centX=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * width=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:32];
    NSLayoutConstraint *bottom=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-8];
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * list=@[centX,width,bottom,height];
    
    [self addConstraints:list];
    
    [self reset];
    
}


- (void)reset
{
    [super reset];
    
    [self resetViews];
}


- (void)resetViews
{
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformIdentity;
        _imageView.image=[UIImage imageNamed:@"custom_pull_refresh"];
    }];
    
}


- (void)canEngageRefresh
{
    [super canEngageRefresh];
    
    [UIView animateWithDuration:0.25 animations:^{
        _imageView.transform=CGAffineTransformMakeRotation(M_PI);
    }];
    
}

- (void)startRefreshing
{
    [super startRefreshing];
    
    _imageView.image=[UIImage imageNamed:@"custom_pull_loading"];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatDuration=INFINITY;
    
    [_imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}
- (void)finishRefreshing
{
    [super finishRefreshing];
    
    [_imageView.layer removeAnimationForKey:@"rotationAnimation"];
    _imageView.transform=CGAffineTransformIdentity;
    _imageView.image=[UIImage imageNamed:@"custom_pull_refresh"];
    
}

@end
