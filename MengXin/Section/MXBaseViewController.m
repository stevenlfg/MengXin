//
//  MXBaseViewController.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXBaseViewController.h"

@interface MXBaseViewController ()

@end

@implementation MXBaseViewController
- (NSString *)menuTitle {
    return _menuTitle;
}

- (NSString *)menuImage {
    return _menuImage;
}

- (NSString*)tipImage {
    return _tipImage;
}

- (NSString *)selectedMenuImage {
    return _selectedMenuImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.view.clipsToBounds=NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.view.layer.cornerRadius=5;
    self.view.backgroundColor=[UIColor whiteColor];
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
