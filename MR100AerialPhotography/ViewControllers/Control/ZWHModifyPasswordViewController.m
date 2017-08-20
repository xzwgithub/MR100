//
//  ZWHModifyPasswordViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHModifyPasswordViewController.h"
#import "UIColor+HexColor.h"
#import "ZWHSettingCell.h"
@interface ZWHModifyPasswordViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, strong) UITableView *tableView;          //

@property(nonatomic, strong) NSArray *titleListArr;          //

@property (strong, nonatomic)  UITextField *userNameTf;

@property (strong, nonatomic)  UITextField *newwordTf;

@property (strong, nonatomic)  UITextField *confirmTf;

@property(nonatomic, strong) UIButton *modifyBtn;          //

@end

@implementation ZWHModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self topBarView];
    [self tableView];
    
}

- (void)setUserName:(NSString *)userName {
    
    _userName = userName;
    self.userNameTf.text = userName;
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = NSLocalizedString(@"Change Password", @"修改密码");
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
        self.titleListArr = @[NSLocalizedString(@"wifi Name", @"Wifi名"),NSLocalizedString(@"new Password", @"新密码"),NSLocalizedString(@"confirm New Password", @"确认新密码")];
        self.view.backgroundColor = kWhiteColor;
        if (kIsIpad) {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 75, kWidth, kHeight - 75) style:UITableViewStylePlain];
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kIpadCellHeight*3, kWidth, kHeight - kIpadCellHeight*3 - 75)];
            [footerView addSubview:self.modifyBtn];
            footerView.backgroundColor = kRGBColorInteger(218, 218, 218);
            _tableView.tableFooterView = footerView;
        }
        else {
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50) style:UITableViewStylePlain];
            UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kSettingCellHeight*3, kWidth, kHeight - kSettingCellHeight*3 - 50)];
            [footerView addSubview:self.modifyBtn];
            footerView.backgroundColor = kRGBColorInteger(218, 218, 218);
            _tableView.tableFooterView = footerView;
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UITextField *)userNameTf {
    if (_userNameTf == nil) {
        if (kIsIpad) {
            _userNameTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth - 450, 10, 350, kIpadCellHeight - 20)];
            _userNameTf.font = FontSize(19);
        }
        else {
            _userNameTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 2 + 40, 10, 240, kSettingCellHeight - 20)];
            _userNameTf.font = FontSize(15);
        }
        
        _userNameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _userNameTf.borderStyle = UITextBorderStyleRoundedRect;
        _userNameTf.textAlignment = NSTextAlignmentCenter;
        _userNameTf.textColor = kGrayColor;
        _userNameTf.returnKeyType = UIReturnKeyDone;
        _userNameTf.delegate = self;
        
    }
    return _userNameTf;
}

- (UITextField *)newwordTf {
    if (_newwordTf == nil) {
        if (kIsIpad) {
            _newwordTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth - 450, 10, 350, kIpadCellHeight - 20)];
            _newwordTf.font = FontSize(19);
        }
        else {
            _newwordTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 2 + 40, 10, 240, kSettingCellHeight - 20)];
            _newwordTf.font = FontSize(15);
        }
        
        _newwordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _newwordTf.borderStyle = UITextBorderStyleRoundedRect;
        _newwordTf.textAlignment = NSTextAlignmentCenter;
        _newwordTf.textColor = kGrayColor;
        _newwordTf.returnKeyType = UIReturnKeyDone;
        _newwordTf.delegate = self;
    }
    return _newwordTf;
}

- (UITextField *)confirmTf {
    if (_confirmTf == nil) {
        if (kIsIpad) {
            _confirmTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth - 450, 10, 350, kIpadCellHeight - 20)];
            _confirmTf.font = FontSize(19);
        }
        else {
            _confirmTf = [[UITextField alloc] initWithFrame:CGRectMake(kWidth / 2 + 40, 10, 240, kSettingCellHeight - 20)];
            _confirmTf.font = FontSize(15);
        }
        
        _confirmTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _confirmTf.borderStyle = UITextBorderStyleRoundedRect;
        _confirmTf.textAlignment = NSTextAlignmentCenter;
        _confirmTf.textColor = kGrayColor;
        _confirmTf.returnKeyType = UIReturnKeyDone;
        _confirmTf.delegate = self;
    }
    return _confirmTf;
}

- (UIButton *)modifyBtn {

    if (_modifyBtn == nil) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            _modifyBtn.frame = CGRectMake(kWidth / 2 - 80, (kHeight - kIpadCellHeight*3 - 50)/2 - 21.5, 160, 43);
        }
        else {
            _modifyBtn.frame = CGRectMake(kWidth / 2 - 80, (kHeight - kSettingCellHeight*3 - 50)/2 - 21.5, 160, 43);
        }
        
        [_modifyBtn setBackgroundImage:ImageNamed(@"Modify-button") forState:UIControlStateNormal];
        [_modifyBtn setBackgroundImage:ImageNamed(@"Modify-select-click") forState:UIControlStateHighlighted];
        [_modifyBtn setTitle:NSLocalizedString(@"modify", @"修改") forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:[UIColor colorWithHexString:@"#5c5c5c"] forState:UIControlStateHighlighted];
        [_modifyBtn addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
        _modifyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _modifyBtn.layer.cornerRadius = 8;
        _modifyBtn.layer.borderColor = kBlackColor.CGColor;
        _modifyBtn.layer.borderWidth = 2;
        _modifyBtn.layer.masksToBounds = YES;
    }
    return _modifyBtn;
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
        [cell.contentView addSubview:self.userNameTf];
    }
    
    else if (indexPath.row == 1) {
        [cell.contentView addSubview:self.newwordTf];
        
    }
    else if (indexPath.row == 2 ) {
        [cell.contentView addSubview:self.confirmTf];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
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

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyAction:(UIButton *)sender {
    
    //用户名和密码不能为空
    if (self.userNameTf.text.length==0 || self.confirmTf.text.length==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"the user name or password cannot be empty", @"用户名或密码不能为空") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //两次密码不一致
    if (![self.newwordTf.text isEqualToString:self.confirmTf.text]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"the user name or password cannot be empty", @"两次输入密码不一致，请核对") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok",@"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //密码不得小于8位
    if (self.confirmTf.text.length < 8) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"the password shall not be less than 8", @"密码不得少于8位") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (self.block) {
        self.block(self.userNameTf.text,self.confirmTf.text);
    }
    [self back:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (range.location + range.length >= 24) {
        return NO;
    }
    if (string.length) {
        char i = [string characterAtIndex:0];
        BOOL condition = ((i >= 'a') && (i <= 'z')) || ((i >= 'A') && (i <= 'Z')) || ((i >= '0') && (i <= '9'));
        
        if (!condition) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"illegal characters, only Numbers and letters", @"非法字符，只能是数字和字母") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}


@end
