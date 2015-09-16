//
//  MXStartView.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXStartView.h"
@interface MXStartView ()
@property (strong, nonatomic) UIImageView *bgImageView;
@end
@implementation MXStartView

+ (instancetype)startView
{
    UIImage *image = [UIImage imageNamed:@"start.png"];
    return [[self alloc] initWithBgImage:image];
}
-(instancetype)initWithBgImage:(UIImage *)bgImage{
    self = [super initWithFrame:kScreen_Bounds];
    if (self) {
        //add custom code
        _bgImageView = [[UIImageView alloc] initWithFrame:kScreen_Bounds];
        _bgImageView.alpha = 0.0;
        [self addSubview:_bgImageView];
        
        [self configWithBgImage:bgImage];
    }
    return self;
}
- (void)configWithBgImage:(UIImage *)bgImage{
    //    bgImage = [bgImage scaleToSize:[_bgImageView doubleSizeOfFrame] usingMode:NYXResizeModeAspectFill];
    self.bgImageView.image = bgImage;
    [self updateConstraintsIfNeeded];
}
- (void)startAnimationWithCompletionBlock:(void(^)(MXStartView *easeStartView))completionHandler{
    [kKeyWindow addSubview:self];
    [kKeyWindow bringSubviewToFront:self];
    _bgImageView.alpha = 0.0;
    @weakify(self);
    [UIView animateWithDuration:0.1 animations:^{
        @strongify(self);
        self.bgImageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 delay:4 options:UIViewAnimationOptionCurveEaseIn animations:^{
            @strongify(self);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            @strongify(self);
            [self removeFromSuperview];
            if (completionHandler) {
                completionHandler(self);
            }
        }];
    }];
}


@end
