//
//  UserCell.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc]initWithFrame:CGRectMake(kPaddingLeftWidth, ([UserCell cellHeight]-40)/2, 40, 40)];
            _userIconView.layer.masksToBounds = YES;
            _userIconView.layer.cornerRadius = _userIconView.frame.size.width/2;
            _userIconView.layer.borderWidth = 0.5;
            _userIconView.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
            [self.contentView addSubview:_userIconView];
        }
#warning To DO
        if (!_userNameLabel) {
            
            
        }
        
        if (!_rightBtn) {
            
            
        }
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}
+ (CGFloat)cellHeight
{
    return 57;
}
@end
