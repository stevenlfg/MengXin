//
//  RMenuItem.m
//  RAirMenuControllerDemo2
//
//  Created by Ryan Wang on 14-5-9.
//  Copyright (c) 2014年 Ryan Wang. All rights reserved.
//

#import "RMenuItem.h"
#import "UIViewAdditions.h"

@interface RMenuItem ()

//@property(nonatomic,strong) UIImageView *tipImage;
@end

@implementation RMenuItem

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView = [[UIView alloc] initWithFrame:frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.contentView.userInteractionEnabled = NO;
        [self addSubview:self.contentView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(98,0, 100,40)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.centerY = CGRectGetHeight(self.bounds) * 0.5;
        self.backgroundView=[[UIView alloc] initWithFrame:self.titleLabel.frame];
        self.backgroundView.backgroundColor=[UIColor clearColor];
        self.backgroundView.layer.cornerRadius=self.backgroundView.height/2;
        [self.contentView insertSubview:self.backgroundView belowSubview:self.titleLabel];
        
        self.tipImage = [[UIImageView alloc] initWithFrame:CGRectMake(185, 10, 10,10)];
        self.tipImage.backgroundColor = [UIColor clearColor];
//        self.tipImage.layer.cornerRadius = 5;
//        self.tipImage.hidden = YES;
        [self.contentView addSubview:self.tipImage];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40,0,40,40)];
        [self.contentView addSubview:self.imageView];
        self.imageView.centerY = CGRectGetHeight(self.bounds) * 0.5;

    }
    return self;
}

//- (void)setBadgeValue:(NSString *)badgeValue {
//    _badgeValue = badgeValue;
//    self.tipImage.text = _badgeValue;
//}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.highlighted =  !selected;
    if (selected) {
//        self.titleLabel.textColor = [UIColor colorWithRed:1 green:0.21 blue:0.21 alpha:1];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_prefix"] isEqualToString:@"christmas"]) {
            self.titleLabel.textColor=[UIColor whiteColor];
            self.backgroundView.backgroundColor=[UIColor colorWithHex:0xea5c55];
        }else{
            self.titleLabel.textColor=[UIColor colorWithHex:0x414141];
            self.backgroundView.backgroundColor=[UIColor clearColor];
        }
    } else {
//        self.titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"skin_prefix"] isEqualToString:@"christmas"]) {
            self.titleLabel.textColor=[UIColor whiteColor];
        }else{
            self.titleLabel.textColor=[UIColor colorWithHex:0x888888];
        }
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.backgroundView.backgroundColor=[UIColor clearColor];
    }
}


@end
