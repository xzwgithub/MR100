//
//  ZWHNewGuardViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/12/2.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHNewGuardViewController.h"
#import "ZWHPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZWHSettingCell.h"
static NSString *const reuseIdentifier = @"cell";
@interface ZWHNewGuardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏
@property(nonatomic, strong) UITableView *tableView;        //
@property(nonatomic, strong) NSArray *titleListArr;         //
@property(nonatomic, strong) NSArray *movArray;             //
@end

@implementation ZWHNewGuardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topBarView];
    [self tableView];
}

- (void)dealloc {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"Guard Videos";
        lb.textColor = [UIColor yellowColor];
        lb.textAlignment = NSTextAlignmentCenter;
        
        [view addSubview:lb];
        
        [self.view addSubview:view];
        if (kIsIpad) {
            view.frame = CGRectMake(0, 0, kWidth, 75);
            [btn setImage:[UIImage imageNamed:@"jt-ipad"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 75, 75);
            lb.frame = CGRectMake(kWidth / 2 - 150, 0, 300, 75);
            lb.font = [UIFont boldSystemFontOfSize:23];
        }
        else {
            view.frame = CGRectMake(0, 0, kWidth, 50);
            [btn setImage:[UIImage imageNamed:@"jt-0"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 50, 50);
            lb.frame = CGRectMake(kWidth / 2 - 50, 0, 100, 50);
            lb.font = [UIFont boldSystemFontOfSize:19];
        }
        
        _topBarView = view;
    }
    return _topBarView;
}

- (UITableView *)tableView {
    
    if (_tableView == nil) {
          self.titleListArr = @[NSLocalizedString(@"basic operation",@"基本操作"),NSLocalizedString(@"taking pictures",@"拍照"),NSLocalizedString(@"video",@"录像"),NSLocalizedString(@"360° rotation video",@"360°自转录像"),NSLocalizedString(@"the flash",@"闪光灯"),NSLocalizedString(@"emergency",@"紧急降落"),NSLocalizedString(@"share",@"分享"),NSLocalizedString(@"equipment usage information",@"设备用量信息"),NSLocalizedString(@"take off",@"起飞")];
        self.view.backgroundColor = kWhiteColor;
        if (kIsIpad) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, kWidth, kHeight - 75) style:UITableViewStylePlain];
        }
        else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50) style:UITableViewStylePlain];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView.showsHorizontalScrollIndicator = YES;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [self.view addSubview:_tableView];
        [_tableView registerClass:[ZWHSettingCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kIsIpad) {
        return kIpadCellHeight;
    }
    else {
        return kSettingCellHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWHSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    cell.lable.text = self.titleListArr[indexPath.row];
    cell.lable.textColor = kBlackColor;
    if (kIsIpad) {
        cell.lable.font = FontSize(19);
    }
    else {
        cell.lable.font = FontSize(15);
    }
    
    cell.lable.highlightedTextColor = kWhiteColor;
    cell.lable.textAlignment = NSTextAlignmentLeft;
    cell.appearIndicator = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZWHPlayerViewController *vc = [[ZWHPlayerViewController alloc] initWithPlayItem:[AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:self.movArray[indexPath.row]]]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSArray *)movArray {
    
    if (_movArray == nil) {
        NSString *path0 = [[NSBundle mainBundle] pathForResource:@"0_handle" ofType:@"mov"];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"1_photo" ofType:@"mov"];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"2_movie" ofType:@"mov"];
        NSString *path3 = [[NSBundle mainBundle] pathForResource:@"3_circle" ofType:@"mov"];
        NSString *path4 = [[NSBundle mainBundle] pathForResource:@"4_emergency" ofType:@"mov"];
        NSString *path5 = [[NSBundle mainBundle] pathForResource:@"5_light" ofType:@"mov"];
        NSString *path6 = [[NSBundle mainBundle] pathForResource:@"6_share" ofType:@"mov"];
        NSString *path7 = [[NSBundle mainBundle] pathForResource:@"7_sd" ofType:@"mov"];
        NSString *path8 = [[NSBundle mainBundle] pathForResource:@"8_takeoff" ofType:@"mov"];
        _movArray = @[path0,path1,path2,path3,path4,path5,path6,path7,path8];
    }
    return _movArray;
}
@end
