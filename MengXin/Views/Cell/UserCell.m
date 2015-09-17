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
            _userIconView.image = [UIImage imageNamed:@"add_user_icon@2x.png"];
            _userIconView.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
            [self.contentView addSubview:_userIconView];
        }
        if (!_userNameLabel) {
            _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, ([UserCell cellHeight]-30)/2, SCREEN_WIDTH - 66 - 100, 30)];
            _userNameLabel.font = [UIFont systemFontOfSize:17];
            _userNameLabel.textColor = [UIColor colorWithHexString:@"0x222222"];
            _userNameLabel.text = @"小七七";
            [self.contentView addSubview:_userNameLabel];

        }
        
        if (!_rightBtn) {
            _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80-kPaddingLeftWidth, ([UserCell cellHeight]-30)/2, 80, 32)];
            [_rightBtn setImage:[UIImage imageNamed:@"btn_project_add@2x.png"] forState:UIControlStateNormal];
            [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_rightBtn];
            
        }
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}
- (void)rightBtnClicked:(id)sender
{
    
}
+ (CGFloat)cellHeight
{
    return 57;
}
@end
