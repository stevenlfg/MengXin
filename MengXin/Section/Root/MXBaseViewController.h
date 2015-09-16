//
//  MXBaseViewController.h
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXBaseViewController : UIViewController
@property (nonatomic, strong) NSString *menuTitle;
@property (nonatomic, strong) UIImage *menuImage;
@property (nonatomic, strong) UIImage *selectedMenuImage;
@property (nonatomic, strong) UIView *contentView;
- (void)addSubview:(UIView*)view;
@end
