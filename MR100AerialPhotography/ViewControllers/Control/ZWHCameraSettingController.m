//
//  ZWHCameraSettingController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHCameraSettingController.h"
#import "ZWHCameraSettingDetailViewController.h"
#import "CameraSyncSetting.h"
#import "TcpManager.h"
#import "ViewController.h"
#import "ZWHSettingCell.h"
@interface ZWHCameraSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, strong) UITableView *tableView;          //

@property(nonatomic, strong) NSArray *titleListArr;          //

@end

@implementation ZWHCameraSettingController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self topBarView];
    
     self.titleListArr = @[NSLocalizedString(@"white_balance", @"白平衡"),NSLocalizedString(@"exposure", @"曝光度"),NSLocalizedString(@"contrast", @"对比度"),NSLocalizedString(@"brightness", @"明亮度"),NSLocalizedString(@"factory_reset", @"恢复出厂设置")];
    self.view.backgroundColor = kWhiteColor;
    
    if (kIsIpad) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, kWidth, kHeight - 75) style:UITableViewStylePlain];
        
    }
    else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tableFooterView = [[UIView alloc] init];
    
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
}

- (void)dealloc {


}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = NSLocalizedString(@"camera", @"相机");
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
    
    ZWHSettingCell *cell = [[ZWHSettingCell alloc] init];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    cell.lable.text = self.titleListArr[indexPath.row];
    cell.lable.textColor = kBlackColor;
    if (kIsIpad) {
        cell.lable.font = [UIFont systemFontOfSize:19];
    }
    else {
        cell.lable.font = [UIFont systemFontOfSize:15];
    }
    
    cell.lable.highlightedTextColor = kWhiteColor;
    cell.lable.textAlignment = NSTextAlignmentLeft;
    if (indexPath.row != 4) {
        cell.appearIndicator = YES;
    }
    
    return cell;
}

-(void)dismissAlert:(UIAlertController *)alert
{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
#if TARGET_IPHONE_SIMULATOR
#else
    if (![self rtspIsValidate]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"unable to connect on unmanned aerial vehicle (uav), please retry after connection on the plane",  @"无法连接上无人机,请连接上飞机后重试") preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            
            [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1];
        }];
    }
#endif
    
    if (indexPath.row == 0) {
        ZWHCameraSettingDetailViewController *vc = [[ZWHCameraSettingDetailViewController alloc] initWithSelectedIndex:indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    else if (indexPath.row == 1) {
        
        ZWHCameraSettingDetailViewController *vc = [[ZWHCameraSettingDetailViewController alloc] initWithSelectedIndex:indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    else if (indexPath.row == 2) {
        
        ZWHCameraSettingDetailViewController *vc = [[ZWHCameraSettingDetailViewController alloc] initWithSelectedIndex:indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    else if (indexPath.row == 3) {
        
        ZWHCameraSettingDetailViewController *vc = [[ZWHCameraSettingDetailViewController alloc] initWithSelectedIndex:indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    TcpManager *manager = [[ViewController sharedViewController] getTcpManager];
    if ([manager tcpConnected])//连接上tcp就发送恢复出厂设置命令
    {
        SEQ_CMD cmd = CMD_REQ_FACTORY_RESTORE_SET;
        NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@(-1)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        [manager sendData:data Response:^(NSData *responseData) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"RESULT"] isEqual:@(0)])
            {
                [[CameraSyncSetting cameraSetting] reset];
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"reset_successfully", @"恢复出厂设置成功！")  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
                [view show];
            }
            else
            {
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"reset_failure", @"恢复出厂设置失败，请重新尝试。") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
                [view show];
            }
        } Tag:0];
    }
    else//没有连接上，弹窗告知用户
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"tcp is not connected", @"TCP没有连接") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(BOOL)rtspIsValidate
{
    ViewController *vc = [ViewController sharedViewController];
    return [vc rtspIsValidate];
}

@end
