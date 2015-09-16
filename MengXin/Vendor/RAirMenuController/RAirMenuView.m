//
//  RAirMenuView.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RAirMenuView.h"
#import "RMenuItem.h"
#import "UIViewAdditions.h"
#import "UIView+AnchorPoint.h"
#import "MXPersonCenterViewController.h"
#import "CycleScrollView.h"
#import "MXAppDelegate.h"
@interface RAirMenuView()<CycleScrollViewDelegate>
{
    NSMutableArray *_viewArray;
    UIButton *_instructions;
    UIImageView *_userBackgroundImageView;
    UILabel *_integralLabel;
    UIButton *_skinBtn;
    
    BOOL isSelectTag;
}
@end

@implementation RAirMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:@"changeSkin" object:nil];
        //ChangeUserInfo 用户信息更改
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUser:) name:@"ChangeUserInfo" object:nil];
        [self _initialize];
        _viewArray=[[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)changeUser:(NSNotification*)notification
{
//    _userImageView.imageURL=[NSURL URLWithString:[MXUserInfo sharedInstance].avatar];
    _userImageView.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[MXUserInfo sharedInstance].avatar]]];
    _userName.text = [MXUserInfo sharedInstance].nickname;
}
-(void)changeSkin:(NSNotification*)notification
{
    _userBackgroundImageView.image=[MXUtils getImageWithName:side_pull_default_avatar_shadows];
}
- (void)scrollToNextView
{
//    _instructions.userInteractionEnabled=NO;
//    [_contentView gotoNextPage];
//    [_instructions performSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES] afterDelay:1.5];
}
- (void)_initialize {
    _menuItemSize = CGSizeMake(320,80);
    _menuItemGap = 17.5;
    
    _menuTextColor = [UIColor greenColor];
    _selectedMenuTextColor = [UIColor yellowColor];
    
    _userBackgroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(65,64,91,91)];
    _userBackgroundImageView.layer.cornerRadius=45;
    _userBackgroundImageView.layer.masksToBounds=YES;
    _userBackgroundImageView.userInteractionEnabled = YES;
    _userBackgroundImageView.image=[MXUtils getImageWithName:side_pull_default_avatar_shadows];
    
    _userImageView=[[EGOImageView alloc] initWithFrame:CGRectMake(0.5,0,90,90)];
    _userImageView.layer.cornerRadius=45;
    _userImageView.layer.masksToBounds=YES;
    _userImageView.userInteractionEnabled = YES;
    _userImageView.placeholderImage=[UIImage imageNamed:@"user"];
    _userImageView.imageURL=[NSURL URLWithString:[MXUserInfo sharedInstance].avatar];
    _userImageView.backgroundColor=[UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_userImageView addGestureRecognizer:tapGesture];
    _userImageView.userInteractionEnabled = YES;

    
    UITapGestureRecognizer *personCenterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoPersonCenter)];
    [_userImageView addGestureRecognizer:personCenterTap];
    
    _userName=[[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_userBackgroundImageView.frame)+15,220,20)];
    _userName.backgroundColor=[UIColor clearColor];
    _userName.textColor=[UIColor blackColor];
    _userName.font=[UIFont boldSystemFontOfSize:18];
    _userName.textAlignment=NSTextAlignmentCenter;
    _userName.text=[MXUserInfo sharedInstance].nickname?[MXUserInfo sharedInstance].nickname:@"小苏苏";
    _contentView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0,175,self.frame.size.width,SCREEN_HEIGHT-175)];
    _contentView.delegate=self;
    if (SCREEN_HEIGHT<500) {
        _userBackgroundImageView.frame=CGRectMake(65,33,91,91);
        _userName.frame=CGRectMake(0, CGRectGetMaxY(_userBackgroundImageView.frame)+15,220,15);
        _contentView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0,145,self.frame.size.width,SCREEN_HEIGHT-145)];
        _contentView.delegate=self;
    }
    _contentView.backgroundColor=[UIColor clearColor];
    [_userBackgroundImageView addSubview:_userImageView];
    [self addSubview:_contentView];
    [self addSubview:_userBackgroundImageView];
    [self addSubview:_userName];
    
    UIButton *instructions=[[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame)-14)/2.0,CGRectGetHeight(self.frame)-54,40,40)];
    [instructions  setImageEdgeInsets:UIEdgeInsetsMake(13,13,13,13)];
    [instructions setImage:[MXUtils getImageWithName:side_pull_instructions] forState:UIControlStateNormal];
    [instructions addTarget:self action:@selector(scrollToNextView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:instructions];
    _instructions=instructions;
    
    //积分背景
    UIImageView *integralBackground=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-18-73, 48, 73, 35)];
    integralBackground.image=[MXUtils getImageWithName:side_pull_points];
    [self addSubview:integralBackground];
    //积分
    _integralLabel=[[UILabel alloc] initWithFrame:CGRectMake(27,3,44,27)];
    _integralLabel.backgroundColor=[UIColor clearColor];
    _integralLabel.textAlignment=NSTextAlignmentCenter;
    _integralLabel.textColor=[UIColor colorWithHex:0x888888];
    _integralLabel.font=[UIFont boldSystemFontOfSize:12];
    _integralLabel.text=@"10000";
    [integralBackground addSubview:_integralLabel];
    integralBackground.hidden=YES;
    
    //换肤
    UIButton *skinBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,-2,60, 58)];
    skinBtn.backgroundColor = [UIColor clearColor];
    [skinBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15,15, 15)];
    [skinBtn setImage:[MXUtils getImageWithName:side_pull_skin] forState:UIControlStateNormal];
    [skinBtn setImage:[MXUtils getImageWithName:side_pull_skin_highlight] forState:UIControlStateHighlighted];
    [skinBtn addTarget:self action:@selector(gotoSkinCenter) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:skinBtn];
    _skinBtn=skinBtn;
}

- (void)handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
}
- (void)tapAction
{
    [self tabSelected:[_items objectAtIndex:0]];
}
- (void)setItems:(NSArray *)items {
    if(_items != items) {
        [self clearItems];
        _items = [NSMutableArray arrayWithArray:items];
        [self reloadItems];
    }
}

- (void)clearItems {
    for(RMenuItem *item in _items) {
        [item removeFromSuperview];
    }
}

- (void)setSelectedItem:(RMenuItem *)selectedItem {
    NSLog(@"--------------");
    _selectedItem = selectedItem;
    for(int i = 0; i < [_items count]; i++) {
        RMenuItem *item = [_items objectAtIndex:i];
        if (_selectedItem == item) {
            [item setSelected:YES];

            
        } else {
            [item setSelected:NO];
        }
    }
}

- (void)cancelPoint{
    RMenuItem *tempItem = _selectedItem;
    for(int i = 0; i < [_items count]; i++) {
        RMenuItem *item = [_items objectAtIndex:i];
        if (_selectedItem == item) {
            MXAppDelegate *myAppDelegate = (MXAppDelegate*)[[UIApplication sharedApplication] delegate];
            if (!myAppDelegate.isAddTag) {
                item.tipImage.image = nil;
            }else{
                item.tipImage.image = [MXUtils getImageWithName:public_new_message];
            }
            if (!myAppDelegate.isChatMsg) {
                item.tipImage.image = nil;
            }else{
                item.tipImage.image = [MXUtils getImageWithName:public_new_message];
            }
        }
    }
}

- (void)reloadItems {
    if ([self.items count] == 0) {
        return;
    }
    
    int count=0;
    CGFloat cellTop = count*_menuItemSize.height;
    [_viewArray removeAllObjects];
    UIView *contentView;
    
    for (int i=0;i<_items.count;i++) {
        if (i%4==0) {
            count=0;
            contentView=[[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,_contentView.frame.size.height)];
            [_viewArray addObject:contentView];
        }
        if (SCREEN_HEIGHT<500) {
         cellTop =235-179+60*count;
        }else{
         cellTop =235-179+70*count;
        }
        RMenuItem *cell=[_items objectAtIndex:i];
        cell.userInteractionEnabled = YES;
        count++;
        cell.top = cellTop;
        cell.width = _menuItemSize.width;
        cell.left=0;
//        cellTop += _menuItemGap + _menuItemSize.height;
        [cell setAnchorPoint:CGPointMake(-0.5, 0.5)];
        [cell addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cell];
    }
    __weak NSArray *array=_viewArray;
    self.contentView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        return array[pageIndex];
    };
    self.contentView.totalPagesCount = ^NSInteger(void){
        return array.count;
    };
    self.contentView.TapActionBlock = ^(NSInteger pageIndex){
        NSLog(@"点击了第%d个",pageIndex);
    };
    
//    for(RMenuItem *cell in _items) {
//        if ([_items indexOfObject:cell] != 0) {
//            cell.userInteractionEnabled = YES;
//            count++;
//            cell.top = cellTop;
//            cell.width = _menuItemSize.width;
//            cell.left=5;
//            cellTop += _menuItemGap + _menuItemSize.height;
//            [cell setAnchorPoint:CGPointMake(-0.5, 0.5)];
//            [cell addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
//            [_contentView addSubview:cell];
//        }else{
//            cell.userInteractionEnabled = YES;
//            count++;
//            cell.top = cellTop;
//            cell.width = _menuItemSize.width;
//            cell.left=5;
//            cellTop += _menuItemGap + _menuItemSize.height;
//            [cell setAnchorPoint:CGPointMake(-0.5, 0.5)];
//            [cell addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchUpInside];
//            [_contentView addSubview:cell];
//        }
//    }
}

- (void)setTranslationX:(CGFloat)_translationX animation:(BOOL)animation{
    float factor = 1;
    int count=0;
    float proprtion=0;
    if (fabsf( - _translationX) /(SCREEN_WIDTH-40)>1.0) {
        proprtion=1;
    }else{
        proprtion=fabsf( - _translationX) /(SCREEN_WIDTH-40);
    }
    float persentage = 1.0 - proprtion;
    float angle = (persentage) * M_PI * 0.9;
//    NSLog(@"persentage = %f angle = %f",persentage, angle);
    if (animation) {
        [UIView beginAnimations:@"CellAnimation" context:NULL];
        [UIView setAnimationDuration:0.3];
    }
    CGFloat offsetWidth = 20;
    CGFloat offset = offsetWidth * self.items.count;
        if (count%4==0) {
            factor=1;
        }
//    for(RMenuItem *cell in self.items) {
//        count++;
//        angle *= factor;
//        CATransform3D tranform = CATransform3DIdentity;
//        tranform.m34 = 1.f / 900.f;
//        tranform =  CATransform3DRotate(tranform ,angle, 0, 1, 0);
//        cell.layer.transform = tranform;
//        factor *= 0.9;
//        offset -= offsetWidth;
//    }
    
    
    float angleOne = (persentage) * M_PI * 0.9;;
    CATransform3D tranform = CATransform3DIdentity;
    tranform.m34 = 1.f / 900.f;
    tranform =  CATransform3DRotate(tranform ,angleOne, 0, 1, 0);
    _userBackgroundImageView.layer.transform = tranform;
    _userName.layer.transform = tranform;
    if (animation) {
        [UIView commitAnimations];
    }
}

- (void)tabSelected:(id)sender {
	[self.delegate menuView:self didSelectItemAtIndex:[self.items indexOfObject:sender]];
}

- (void)gotoPersonCenter{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(menuViewToPersonCenter)]) {
         [self.delegate menuViewToPersonCenter];
    }
}
-(void)gotoSkinCenter
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(menuViewToSkinCenter)]) {
        [self.delegate menuViewToSkinCenter];
    }
}
-(void)cycleScrollView:(CycleScrollView *)view isScrolled:(BOOL)isFinished
{
//    if (isFinished) {
//        _instructions.alpha=1;
//        _instructions.userInteractionEnabled=YES;
//    }else{
//        _instructions.userInteractionEnabled=NO;
//        _instructions.alpha=0.3;
//    }
}
-(void)cycleScrollView:(CycleScrollView *)view scrollPercentage:(float)percent currentPage:(NSInteger)page isUp:(BOOL)isUp
{
    NSLog(@"%f",percent);
    for(RMenuItem *item in _items) {
        CGRect rect=[view convertRect:[item.superview convertRect:item.frame toView:view] toView:self];
        if (rect.origin.y<view.frame.origin.y+50) {
            if (isUp) {
              item.hidden=YES;
            }else{
               item.hidden=NO;
            }
//            item.alpha=(view.frame.origin.y+50-rect.origin.y)/50.0;
        }else
        {
//            item.alpha=1;
            item.hidden=NO;
        }
    }
    if (percent==1) {
        _instructions.alpha=1.0;
    }else{
        _instructions.alpha=0.3;
    }
    if ([self.delegate respondsToSelector:@selector(menuView:scrollPercentage:currentPage:isUp:)]) {
        [self.delegate menuView:self scrollPercentage:percent currentPage:page isUp:isUp];
    }
}
@end
