//
//  ZWHDeviceSettingController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHDeviceSettingController.h"
#import "ZWHModifyPasswordViewController.h"
#import "ViewController.h"
#import "CameraSyncSetting.h"
#import "ZWHSettingCell.h"
@interface ZWHDeviceSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, strong) UITableView *tableView;          //

@property(nonatomic, strong) NSArray *titleListArr;          //

@property(nonatomic, strong) UITextField *userNameLb;          //

@property(nonatomic, strong) UITextField *passwordLb;          //

@end

@implementation ZWHDeviceSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topBarView];
    [self tableView];
    CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
    self.userNameLb.text = camera.WifiInfo[@"ssid"];
    self.passwordLb.text = camera.WifiInfo[@"pass_phrase"];
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = @"Device";
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
        self.titleListArr = @[NSLocalizedString(@"name", @"用户名"),NSLocalizedString(@"password", @"密码"),NSLocalizedString(@"change_password", @"修改密码")];
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
    return _tableView;
}

- (UITextField *)passwordLb {
    if (_passwordLb == nil) {
        if (kIsIpad) {
            _passwordLb = [[UITextField alloc] initWithFrame:CGRectMake(kWidth - 450, 10, 350, kIpadCellHeight - 20)];
            _passwordLb.font = FontSize(19);
        }
        else {
            _passwordLb = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 2 + 40, 10, 240, kSettingCellHeight - 20)];
            _passwordLb.font = FontSize(15);
        }
        _passwordLb.borderStyle = UITextBorderStyleRoundedRect;
        _passwordLb.enabled = NO;
        _passwordLb.textAlignment = NSTextAlignmentCenter;
        _passwordLb.textColor = kGrayColor;
        
        _passwordLb.returnKeyType = UIReturnKeyDone;
        
    }
    return _passwordLb;
}

- (UITextField *)userNameLb {
    if (_userNameLb == nil) {
        if (kIsIpad) {
            _userNameLb = [[UITextField alloc] initWithFrame:CGRectMake(kWidth - 450, 10, 350, kIpadCellHeight - 20)];
            _userNameLb.font = FontSize(19);
        }
        else {
            _userNameLb = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 2 + 40, 10, 240, kSettingCellHeight - 20)];
            _userNameLb.font = FontSize(15);
        }
        
        _userNameLb.borderStyle = UITextBorderStyleRoundedRect;
        _userNameLb.enabled = NO;
        _userNameLb.textAlignment = NSTextAlignmentCenter;
        _userNameLb.textColor = kGrayColor;
        _userNameLb.returnKeyType = UIReturnKeyDone;
        
    }
    return _userNameLb;
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
    
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.userNameLb];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.passwordLb];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if (indexPath.row == 2) {
        cell.appearIndicator = YES;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    }
    
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //修改密码
    if (indexPath.row == 2) {
        ZWHModifyPasswordViewController *vc = [[ZWHModifyPasswordViewController alloc] init];
        vc.block = ^(NSString *wifiName,NSString *wifiPassword){
            
            SEQ_CMD cmd = CMD_REQ_WIFI_DISPATCHER_NET_SSID;
            NSDictionary *paramDict = @{@"ssid":wifiName,
                                        @"phrase":wifiPassword};
            NSDictionary *reqDict = @{@"CMD":@(cmd), @"PARAM":paramDict};
            NSData *reqData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
            
            [[[ViewController sharedViewController] getTcpManager] sendData:reqData Response:^(NSData *responseData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",dict.description);
                if ([dict[@"RESULT"] integerValue] == 0)
                {
                    NSLog(@"WiFi名称密码修改成功");
                    CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
                    [camera.WifiInfo setObject:wifiName forKey:@"ssid"];
                    [camera.WifiInfo setObject:wifiPassword forKey:@"pass_phrase"];
                    self.userNameLb.text = wifiName;
                    self.passwordLb.text = wifiPassword;
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"modify success, please reconnect WiFi drones", @"修改成功，请重新连接无人机WiFi") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
                    [alert show];

                }
                else//修改失败
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"modify the failed, please try again later", @"修改失败，请稍后重新尝试")  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定")  otherButtonTitles:nil, nil];
                    [alert show];

                }
            } Tag:0];

        };
        vc.userName = self.userNameLb.text;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)dealloc {
    NSLog(@"设备设置控制器挂掉了");
}

@end
