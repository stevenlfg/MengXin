//
//  MXStartView.h
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MXStartView : UIView
+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void(^)(MXStartView *easeStartView))completionHandler;
@end
