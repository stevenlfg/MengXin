//
//  MXFriendsViewController.m
//  MengXin
//
//  Created by stevenlfg on 15/9/16.
//  Copyright (c) 2015年 stevenlfg. All rights reserved.
//

#import "MXFriendsViewController.h"
#import "DJRefresh.h"
#import "SampleRefreshView.h"
#import "UserCell.h"
@interface MXFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,DJRefreshDelegate>
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)DJRefresh *refresh;
@end

@implementation MXFriendsViewController
- (void)openMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openMenu" object:nil userInfo:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"好友";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"light_green_public_menu@2x.png" title:nil highLightIcon:@"light_green_public_menu_highlight@2x.png" target:self action:@selector(openMenu)];
    _myTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[UserCell class] forCellReuseIdentifier:kCellIdentifier_UserCell];
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        tableView.sectionIndexColor = [UIColor colorWithHexString:@"0x666666"];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView;

    });
    SampleRefreshView *refreshView=[[SampleRefreshView alloc] initWithFrame:CGRectZero];
    [refreshView didDraggingProgressCompletionBlock:^(DJRefreshView *refreshView, CGFloat progress, NSDictionary *info) {
        // NSLog(@"拉动进度%.2f",progress);
    }];
    
    
    _refresh=[DJRefresh refreshWithScrollView:_myTableView];
    _refresh.delegate=self;
    _refresh.topEnabled=YES;
    _refresh.topRefreshView=refreshView;
}
- (void)refresh:(DJRefresh *)refresh didEngageRefreshDirection:(DJRefreshDirection)direction{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refresh finishRefreshingDirection:direction animation:YES];
        
    });
    
}
#pragma mark - UITableViewDataSource&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_UserCell forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UserCell cellHeight];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
