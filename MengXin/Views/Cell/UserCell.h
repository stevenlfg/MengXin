//
//  UserCell.h
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (nonatomic,strong)UIImageView *userIconView;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UIButton *rightBtn;
+ (CGFloat)cellHeight;
@end
