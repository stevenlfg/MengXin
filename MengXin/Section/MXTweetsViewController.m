//
//  MXTweetsViewController.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXTweetsViewController.h"

@interface MXTweetsViewController ()
{
    
}
@property (nonatomic,strong)UITableView *myTableView;
@end


@implementation MXTweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"冒泡";
//    _myTableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        tableView.backgroundColor = [UIColor clearColor];
//        tableView.dataSource = self;
//        tableView.delegate = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self.view addSubview:tableView];
//        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
//        tableView;
//    });
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
