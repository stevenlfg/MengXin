//
//  UINavigationController+AirMenu.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "UINavigationController+AirMenu.h"
#import "UIViewController+AirMenu.h"

@implementation UINavigationController (AirMenu)

- (NSString *)menuTitle {
    NSString *menuTitle = nil;
    if([self.topViewController respondsToSelector:@selector(menuTitle)]) {
        menuTitle = [self.topViewController menuTitle];
    }
    return menuTitle;
}

- (NSString *)menuImage {
    NSString *menuImage = nil;
    if([self.topViewController respondsToSelector:@selector(menuImage)]) {
        menuImage = [self.topViewController menuImage];
    }
    return menuImage;
}

- (NSString *)selectedMenuImage {
    NSString *selectedMenuImage = nil;
    if([self.topViewController respondsToSelector:@selector(selectedMenuImage)]) {
        selectedMenuImage = [self.topViewController selectedMenuImage];
    }
    return selectedMenuImage;
}

- (NSString *)tipImage {
    NSString *tipImage = nil;
    if([self.topViewController respondsToSelector:@selector(tipImage)]) {
        tipImage = [self.topViewController tipImage];
    }
    return tipImage;
}

@end
