//
//  MXMenuViewController.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXMenuViewController.h"
#import "MXFriendsViewController.h"
#import "MXTweetsViewController.h"
#import "MXSettingViewController.h"
#import "MXMessagesViewController.h"
#import "MXPointsViewController.h"
@interface MXMenuViewController ()

@end

@implementation MXMenuViewController
- (void)openMenu
{
    [self openMenu:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius=5;
    self.view.layer.masksToBounds=YES;
    self.view.backgroundColor=[UIColor blackColor];
    // Do any additional setup after loading the view.
    self.menuView.backgroundColor = [UIColor whiteColor];
    self.menuView.layer.contents = (id)[UIImage imageNamed:@"light_green_side_pull_backdrop@2x.png"].CGImage;
    
    //我的好友
    MXFriendsViewController * friends = [[MXFriendsViewController alloc]init];
    friends.title = @"好友";
    friends.menuTitle = @"好友";
    friends.menuImage = [UIImage imageNamed:@"light_green_side_pull_newfriends@2x"];
    friends.selectedMenuImage = [UIImage imageNamed:@"light_green_side_pull_newfriends_highlight@2x.png"];
    UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:friends];
    
    //我的冒泡
    MXTweetsViewController *tweets = [[MXTweetsViewController alloc]init];
    tweets.title = @"冒泡";
    tweets.menuTitle = @"冒泡";
    tweets.menuImage = [UIImage imageNamed:@"light_green_side_pull_circle@2x.png"];
    tweets.selectedMenuImage = [UIImage imageNamed:@"light_green_side_pull_circle_highlight@2x.png"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:tweets];
    
    //私信
    MXMessagesViewController *message = [[MXMessagesViewController alloc]init];
    message.title = @"私信";
    message.menuTitle = @"私信";
    message.menuImage = [UIImage imageNamed:@"light_green_side_pull_chat@2x.png"];
    message.selectedMenuImage = [UIImage imageNamed:@"light_green_side_pull_chat_highlight@2x.png"];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:message];
    
    //码币
    MXPointsViewController *points = [[MXPointsViewController alloc]init];
    points.title = @"码币";
    points.menuTitle = @"码币";
    points.menuImage = [UIImage imageNamed:@"light_green_side_pull_interest@2x.png"];
    points.selectedMenuImage = [UIImage imageNamed:@"light_green_side_pull_interest_highlight@2x.png"];
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:points];

    //设置
    MXSettingViewController *setting = [[MXSettingViewController alloc]init];
    setting.title = @"设置";
    setting.menuTitle = @"设置";
    setting.menuImage = [UIImage imageNamed:@"light_green_side_pull_set@2x.png"];
    setting.selectedMenuImage = [UIImage imageNamed:@"light_green_side_pull_set_highlight@2x.png"];
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:setting];
    
    
    
    self.viewControllers=[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5,nil];
    self.selectedIndex = 1;
 
    [self.view insertSubview:self.topView atIndex:0];
    [self.topView addSubview:nav5.view];
    [nav5.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.01];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
