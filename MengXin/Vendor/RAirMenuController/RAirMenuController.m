//
//  RAirMenuController2.m
//  RAirMenuController2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RAirMenuController.h"
#import "UIView+AnchorPoint.h"
#import "UIViewAdditions.h"
#import "RMenuItem.h"
#import "UIViewController+AirMenu.h"
#import "MXPersonDetailInfoViewController.h"
#import "AppDelegate.h"
@interface RAirMenuController() <UIGestureRecognizerDelegate, RAirMenuViewDelegate,UIAlertViewDelegate>
{
    float _percent;
    BOOL isExceedHalf;
    NSInteger _pageOneSelect;
    NSInteger _pageTwoSelect;
    UINavigationController *personCenterNav;
    UINavigationController *skinCenterNav;
    BOOL isSelect;
}
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, readwrite) BOOL visible;

@end

@implementation RAirMenuController {
    CGFloat                     _menuWidth;
    UIButton                    *_rightCloseButton;
    BOOL                        _draggingHorizonal;
    BOOL                        _menuOpened;
    CGFloat                     _translationX;
    UIViewController            *_oldViewController;
    CGFloat                     _activeWidth;
    CGFloat                     _startX;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _initialize];
    }
    return self;
}


- (void)_initialize {
    _menuWidth = SCREEN_WIDTH;
    _menuRowHeight = 50;
    _activeWidth = 280;
    _pageOneSelect=0;
    _pageTwoSelect=4;
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@",self.description);
}
//-(void)changeSkin:(NSNotification*)notification
//{
//    self.menuView.layer.contents=(id)[MXUtils getImageWithName:public_all_backdrop].CGImage;
//    [self loadMenuView];
//    [self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
//    // default page
//}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin:) name:@"changeSkin" object:nil];
    //    self.view.layer.cornerRadius=5;
    //    self.view.layer.masksToBounds=YES;
    self.view.backgroundColor=[UIColor blackColor];
    CGFloat _topHeight = 44;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        _topHeight = 64;
    }
    self.menuView = [[RAirMenuView alloc] initWithFrame:self.view.bounds];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    _rightCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightCloseButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightCloseButton.frame = CGRectMake(self.view.bounds.size.width - 70, 0, 70, self.view.bounds.size.height);
    [self.view addSubview:_rightCloseButton];
    
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.clipsToBounds = NO;
#warning 下面的属性设置可影响动画的切换等
    //    self.contentView.layer.ShadowOpacity=0.5;
    //    self.contentView.layer.shadowOffset=CGSizeMake(-5,10);
    //    self.contentView.layer.shadowColor=[UIColor colorWithHex:0x888888].CGColor;
    //    self.contentView.layer.allowsEdgeAntialiasing = YES;
    [self.view addSubview:self.contentView];
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, -_topHeight, CGRectGetWidth(self.view.bounds), _topHeight)];
    //    self.topView.backgroundColor = [UIColor redColor];
    self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.topView];
    
    
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRevealGesture:)];
    _panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:_panGestureRecognizer];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.selectedViewController viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self.selectedViewController viewDidAppear:animated];
    _visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [self.selectedViewController viewDidDisappear:animated];
    _visible = NO;
}

- (void)setBackgroundView:(UIImageView *)backgroundView {
    if(_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        [self.view addSubview:_backgroundView];
        [self.view insertSubview:_backgroundView atIndex:0];
        [self enableEffect:NO];
    }
}

- (void)setViewControllers:(NSArray *)viewControllers {
    
    if(_viewControllers != viewControllers) {
        //        _selectedIndex = 0;
        
        for(UIViewController *c in _viewControllers) {
            [c removeFromParentViewController];
        }
        
        _viewControllers = viewControllers;
        
        //        for(UIViewController *c in _viewControllers) {
        //            [self addChildViewController:c];
        //        }
        
        [self loadMenuView];
        // default page
        [self setSelectedIndex:_selectedIndex];
    }
}

- (void)loadMenuView {
    NSMutableArray *items = [NSMutableArray array];
    for(UIViewController *viewController in _viewControllers) {
        RMenuItem *item = [[RMenuItem alloc] initWithFrame:CGRectMake(0, 0,_menuWidth,_menuRowHeight)];
        
        if ([viewController respondsToSelector:@selector(menuTitle)]) {
            item.titleLabel.text = viewController.menuTitle;
        }
        if ([viewController respondsToSelector:@selector(menuImage)]) {
            item.imageView.image = viewController.menuImage;
        }
        if ([viewController respondsToSelector:@selector(selectedMenuImage)]) {
            item.imageView.highlightedImage = viewController.selectedMenuImage;
        }
        [items addObject:item];
    }
    [self.menuView setItems:items];
    
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex == 0&&!isSelect) {
        isSelect = YES;
    }
    [self setSelectedIndex:selectedIndex animation:NO];
    if (selectedIndex>3) {
        _pageTwoSelect = selectedIndex;
    }else{
        _pageOneSelect = selectedIndex;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animation:(BOOL)animation {
    if (selectedIndex >= [_viewControllers count]) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    [self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
    
    UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
    if (self.selectedViewController == vc) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:animation];
        }
        self.selectedViewController = vc;
    } else {
        self.selectedViewController = vc;
    }
    
    [self closeMenu:YES];
    
}


- (void)setSelectedViewController:(UIViewController *)vc {
    UIViewController *oldVC = _selectedViewController;
    if (_selectedViewController != vc) {
        _selectedViewController = vc;
        
        for(UIView *v in self.contentView.subviews) {
            [v removeFromSuperview];
        }
        if (/*!self.childViewControllers && */1) {
            //			[oldVC viewWillDisappear:NO];
            [vc viewWillAppear:NO];
            [oldVC removeFromParentViewController];
            
        }
        if ([oldVC isKindOfClass:[UINavigationController class]]) {
            
        }
        vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addChildViewController:vc];
        [vc didMoveToParentViewController:self];
        vc.view.frame = self.contentView.bounds;
        [self.contentView addSubview:vc.view];
        
        if (/*!self.childViewControllers &&*/ _visible) {
            //			[oldVC viewDidDisappear:NO];
            //			[_selectedViewController viewDidAppear:NO];
        }
        [self.menuView setSelectedItem:[self.menuView.items objectAtIndex:_selectedIndex]];
    }
}



#pragma mark -
#pragma mark - Drag and animations
- (void)transformForMenuView:(CGFloat)distance animation:(BOOL)animation {
    [self.menuView setTranslationX:distance animation:animation];
}

- (void)transformForTopView:(CGFloat)distance animation:(BOOL)animation {
    float percentage = distance / _activeWidth;
    percentage = MAX(percentage, 0);
    percentage = MIN(percentage, 1);
    if(animation) {
        [UIView animateWithDuration:0.20 animations:^{
            self.topView.bottom =  percentage * self.topView.height;
        }];
    } else {
        self.topView.bottom =  percentage * self.topView.height;
    }
}


- (void)transformForContentView:(CGFloat)distance animation:(BOOL)animation{
    CGFloat distanceThreshold = _activeWidth;
    CGFloat coverAngle = -55.0 / 180.0 * M_PI;
    CGFloat perspective = -1.0/1150;  // fixed
    
    CGFloat coverScale = 0.5;       // fixed
    CGFloat percentage = fabsf(distance)/distanceThreshold;
    
    [self.contentView setAnchorPoint:CGPointMake(0, 0.5)];
    NSLog(@"percentage : %f",percentage);
    if (percentage>1) {
        percentage=1;
    }
    if (!animation) {
        self.contentView.layer.transform = [self
                                            transform3DWithRotation:percentage * coverAngle
                                            scale:(1 - percentage) * (1 - coverScale) + coverScale
                                            translationX:distance
                                            perspective:perspective
                                            ];
    } else {
        [UIView animateWithDuration:0.20 animations:^{
            self.contentView.layer.transform = [self
                                                transform3DWithRotation:percentage * coverAngle
                                                scale:(1 - percentage) * (1 - coverScale) + coverScale
                                                translationX:distance
                                                perspective:perspective
                                                ];
        }];
    }
    
}

- (CATransform3D)transform3DWithRotation:(CGFloat)angle
                                   scale:(CGFloat)scale
                            translationX:(CGFloat)tranlationX
                             perspective:(CGFloat)perspective {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = perspective;
    transform = CATransform3DTranslate(transform, tranlationX , 0, 0);
    transform = CATransform3DScale(transform, scale, scale, 1.0);
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    
    return transform;
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"MJNIndexStart"] boolValue]) {
        return NO;
    }
    CGPoint translation = [panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    
    _draggingHorizonal = fabs(translation.y) < fabs(translation.x);
    if(_menuOpened && velocity.x > 0) {
        return NO;
    }
    
    if ([_selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigator = (UINavigationController *)_selectedViewController;
        if (navigator.topViewController != [navigator.viewControllers firstObject]) {
            return NO;
        }
    }
    
    return YES;
}


- (void)handleRevealGesture:(UIPanGestureRecognizer *)recognizer
{
    if (_draggingHorizonal) {
        switch ( recognizer.state)
        {
            case UIGestureRecognizerStateBegan:
                [self handleRevealGestureStateBeganWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateChanged:
                [self handleRevealGestureStateChangedWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateEnded:
                [self handleRevealGestureStateEndedWithRecognizer:recognizer];
                break;
                
            case UIGestureRecognizerStateCancelled:
                [self handleRevealGestureStateEndedWithRecognizer:recognizer];
                break;
            case UIGestureRecognizerStateFailed:
                [self handleRevealGestureStateEndedWithRecognizer:recognizer];
                break;
            default:
                break;
        }
    } else {
        //        CGPoint point = [recognizer locationInView:self.view];
        //        if (CGRectContainsPoint(self.contentView.frame, point)) {
        //            NSLog(@"point: %@", NSStringFromCGPoint(point));
        //            NSLog(@"rect : %@", NSStringFromCGRect(self.contentView.frame));
        //        } else {
        //
        //        }
        
    }
}

- (void)handleRevealGestureStateBeganWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    _startX=translation.x;
}

- (void)handleRevealGestureStateChangedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    if(!_menuOpened && translation.x <= 0 ){
        return;
    }
    if (translation.x + _translationX<0) {
        return;
    }
    //    [self transformForContentView:translation.x + _translationX animation:NO];
    //    [self transformForMenuView:translation.x + _translationX animation:NO];
    //    [self transformForTopView:translation.x + _translationX animation:NO];
    if (translation.x-_startX>60) {
        [self openMenu:YES];
    }else{
        [self closeMenu:YES];
    }
    
}

- (void)handleRevealGestureStateEndedWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    //    CGPoint translation = [recognizer translationInView:self.view];
    //    CGFloat threshold = 150;
    //    NSLog(@"translation.x = %f",translation.x);
    //    if(translation.x > threshold) {
    //        // open menu
    //        [self openMenu:YES];
    //    } else if (translation.x < 0) {
    //        // close menu
    //        [self closeMenu:YES];
    //    } else {
    //        [self closeMenu:YES];
    //    }
}

- (void)handleRevealGestureStateCancelledWithRecognizer:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)closeAction:(id)sender {
    [self closeMenu:YES];
}

- (void)closeMenu:(BOOL)animation {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.menuView.userInteractionEnabled=NO;
    _menuOpened = NO;
    _translationX = 1;
    [self transformForContentView:0 animation:animation];
    [self transformForMenuView:0 animation:animation];
    [self transformForTopView:0 animation:animation];
    
    self.contentView.userInteractionEnabled = YES;
}

- (void)openMenu:(BOOL)animation {
    //    self.menuView.userImageView.imageURL=[NSURL URLWithString:[MXUserInfo sharedInstance].avatar];
    //    self.menuView.userName.text=[MXUserInfo sharedInstance].nickname?[MXUserInfo sharedInstance].nickname:@"小苏苏";
    if (_selectedIndex == 0) {
        //[self.menuView cancelPoint];
    }
    if (_selectedIndex == 3) {
        //[self.menuView cancelPoint];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    //    if ([MXUserInfo sharedInstance].isLogin) {
    self.menuView.userInteractionEnabled=YES;
    _translationX = _activeWidth;
    _menuOpened = YES;
    [self transformForContentView:_translationX animation:animation];
    [self transformForMenuView:_translationX animation:animation];
    [self transformForTopView:_translationX animation:animation];
    
    self.contentView.userInteractionEnabled = NO;
    //    }else{
    //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您还未登录，请先登录！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //        [alert show];
    //    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"请先登录");
}

- (void)menuView:(RAirMenuView *)menu didSelectItemAtIndex:(NSInteger)index {
    
    [self setSelectedIndex:index];
}


- (void)enableEffect:(BOOL)effect {
    if (!effect) {
        return;
    }
    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);
    
    if([self.backgroundView respondsToSelector:@selector(addMotionEffect:)]) {
        [self.backgroundView addMotionEffect:horizontalMotionEffect];
    }
}
//跳转个人中心
//- (void)menuViewToPersonCenter{
//    if (!personCenterNav)
//    {
//        MXPersonDetailInfoViewController *personCenter = [[MXPersonDetailInfoViewController alloc]init];
//        personCenter.isMenu = YES;
//        personCenterNav=[[UINavigationController alloc]initWithRootViewController:personCenter];
//    }
//    UIViewController *vc = personCenterNav;
//    if (self.selectedViewController == vc) {
//        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
//        }
//    } else {
//        self.selectedViewController = vc;
//    }
//    //    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//    //        UINavigationController *nav=(UINavigationController*)self.selectedViewController;
//    //        [nav pushViewController:personCenter animated:NO];
//    //    }
//    [self closeMenu:YES];
//}
//跳转皮肤中心
//-(void)menuViewToSkinCenter
//{
//    if (!skinCenterNav) {
//        MXPersonalizedSkinViewController *personCenter = [[MXPersonalizedSkinViewController alloc]init];
//        personCenter.isMenu = YES;
//        skinCenterNav=[[UINavigationController alloc]initWithRootViewController:personCenter];
//    }
//    UIViewController *vc = skinCenterNav;
//    if (self.selectedViewController == vc) {
//        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:NO];
//        }
//    } else {
//        self.selectedViewController = vc;
//    }
//    //    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//    //        UINavigationController *nav=(UINavigationController*)self.selectedViewController;
//    //        [nav pushViewController:personCenter animated:NO];
//    //    }
//    [self closeMenu:YES];
//}
//滚动的时候 contentView缩进和出来
-(void)menuView:(RAirMenuView *)menu scrollPercentage:(float)percent currentPage:(NSInteger)page isUp:(BOOL)isUp
{
    //    [menu.items makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:NO]];
    _visible=YES;
    CGFloat distanceThreshold = _activeWidth;
    CGFloat coverAngle = -55.0 / 180.0 * M_PI;
    CGFloat perspective = -1.0/1150;  // fixed
    
    CGFloat coverScale = 0.5;       // fixed
    CGFloat percentage = fabsf(_activeWidth)/distanceThreshold;
    CATransform3D transform=[self
                             transform3DWithRotation:percentage * coverAngle
                             scale:(1 - percentage) * (1 - coverScale) + coverScale
                             translationX:_activeWidth
                             perspective:perspective
                             ];
    if (percent<=0.5) {
        if (isExceedHalf) {
            if (!isUp) {
                if (page==0) {
                    _selectedIndex=_pageOneSelect;
                }else
                {
                    _selectedIndex=_pageTwoSelect;
                }
                UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
                self.selectedViewController = vc;
                CATransform3D newTransform=CATransform3DTranslate(transform,percent*SCREEN_WIDTH/2.0,0,0);
                self.contentView.layer.transform=newTransform;
                
            }else
            {
                if (page==0) {
                    _selectedIndex=_pageOneSelect;
                }else
                {
                    _selectedIndex=_pageTwoSelect;
                }
                self.contentView.layer.transform = [self
                                                    transform3DWithRotation:0
                                                    scale:1
                                                    translationX:0
                                                    perspective:perspective
                                                    ];
                UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
                self.selectedViewController = vc;
                CATransform3D newTransform=CATransform3DTranslate(transform,percent*SCREEN_WIDTH/2.0,0,0);
                self.contentView.layer.transform=newTransform;
                
            }
        }else{
            if (page==0) {
                _selectedIndex=_pageOneSelect;
            }else
            {
                _selectedIndex=_pageTwoSelect;
            }
            CATransform3D newTransform=CATransform3DTranslate(transform,percent*SCREEN_WIDTH/2.0,0,0);
            self.contentView.layer.transform=newTransform;
        }
        [self transformForMenuView:_activeWidth animation:NO];
        self.contentView.userInteractionEnabled = NO;
    }else if (percent<1){
        isExceedHalf=YES;
        if (!isUp) {
            if (page==0) {
                _selectedIndex=_pageOneSelect;
            }else
            {
                _selectedIndex=_pageTwoSelect;
            }
        }else{
            if (page==0) {
                _selectedIndex=_pageOneSelect;
            }else
            {
                _selectedIndex=_pageTwoSelect;
            }
        }
        [self transformForMenuView:_activeWidth animation:NO];
        self.contentView.userInteractionEnabled = NO;
        self.contentView.layer.transform = [self
                                            transform3DWithRotation:0
                                            scale:1
                                            translationX:0
                                            perspective:perspective
                                            ];
        UIViewController *vc = [self.viewControllers objectAtIndex:_selectedIndex];
        self.selectedViewController = vc;
        CATransform3D newTransform=CATransform3DTranslate(transform,SCREEN_WIDTH/4-(percent-0.5)*SCREEN_WIDTH/2.0,0,0);
        self.contentView.layer.transform=newTransform;
    }else if (percent==1) {
        isExceedHalf=NO;
        //        [menu.items makeObjectsPerformSelector:@selector(setUserInteractionEnabled:) withObject:[NSNumber numberWithBool:YES]];
    }
    _percent=percent;
}
@end
