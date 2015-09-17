//
//  MXSettingViewController.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXSettingViewController.h"

@interface MXSettingViewController ()

@end

@implementation MXSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"light_green_public_menu@2x.png" title:nil highLightIcon:@"light_green_public_menu_highlight@2x.png" target:self action:@selector(openMenu)];
}
- (void)openMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openMenu" object:nil userInfo:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
