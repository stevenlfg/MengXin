//
//  UIBarButtonItem+Common.h
//  JXM
//
//  Created by stevenlfg on 15/3/31.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon title:(NSString *)title highLightIcon:(NSString *)highLightIcon target:(id)target action:(SEL)action;

@end
