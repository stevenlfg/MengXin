
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

@property(nonatomic,strong) UILabel *badgeValueLabel;
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
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.centerY = CGRectGetHeight(self.bounds) * 0.5;

        self.badgeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100,20)];
        self.badgeValueLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.badgeValueLabel];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40,0,40,40)];
        [self.contentView addSubview:self.imageView];
        self.imageView.centerY = CGRectGetHeight(self.bounds) * 0.5;

    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    self.badgeValueLabel.text = _badgeValue;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.highlighted =  !selected;
    if (selected) {
//        self.titleLabel.textColor = [UIColor colorWithRed:1 green:0.21 blue:0.21 alpha:1];
        self.titleLabel.textColor=[UIColor colorWithString:@"0x414141"];
    } else {
//        self.titleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
        self.titleLabel.textColor=[UIColor colorWithString:@"0x888888"];
    }
}


@end
