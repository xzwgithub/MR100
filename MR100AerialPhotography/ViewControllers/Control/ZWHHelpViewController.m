//
//  ZWHHelpViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHHelpViewController.h"
#import "ZWHFirstLaunchViewController.h"
#import "ViewController.h"
#import "ZWHNewGuardViewController.h"
#import "ZWHSettingCell.h"
#import "PDFBrowseViewController.h"

static NSString *const reuseIdentifier = @"cell";
@interface ZWHHelpViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, strong) UITableView *tableView;          //

@property(nonatomic, strong) NSArray *titleListArr;          //

@property(nonatomic, strong) UIAlertController *accAlert;

@end

@implementation ZWHHelpViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    [self topBarView];
    
//    self.titleListArr = @[NSLocalizedString(@"quick user manual",@"快速使用手册"),NSLocalizedString(@"rookie help",@"新手帮助"),NSLocalizedString(@"product manual",@"产品说明书"),NSLocalizedString(@"geomagnetic calibration animation",@"地磁校准动画"),NSLocalizedString(@"find me use animation",@"Find me使用动画"),NSLocalizedString(@"contact us",@"联系我们"),@"http://www.c-mecamera.com"];
    
    self.titleListArr = @[NSLocalizedString(@"quick user manual",@"快速使用手册"),NSLocalizedString(@"rookie help",@"新手帮助"),NSLocalizedString(@"product manual",@"产品说明书"),NSLocalizedString(@"About the machine",@"关于本机"),@"http://www.c-mecamera.com"];

    
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
    
    _tableView.showsHorizontalScrollIndicator = YES;
    _tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[ZWHSettingCell class] forCellReuseIdentifier:reuseIdentifier];
    
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = NSLocalizedString(@"help", @"帮助");
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
    
    //快速使用手册
    if (indexPath.row == 0) {
     
        PDFBrowseViewController * pdfVC = [[PDFBrowseViewController alloc] init];
        pdfVC.pdfType = PDF_DOCUMENT_TYPE_USER;
        [self.navigationController pushViewController:pdfVC animated:YES];
        
    }
    
    //新手引导
    else if (indexPath.row == 1) {
        ZWHNewGuardViewController *guideVC = [[ZWHNewGuardViewController alloc]init];
        [self.navigationController pushViewController:guideVC animated:YES];
    }
    
    //产品说明书
    else if (indexPath.row == 2) {
        
        PDFBrowseViewController * pdfVC = [[PDFBrowseViewController alloc] init];
        pdfVC.pdfType = PDF_DOCUMENT_TYPE_PRODUCT;
        [self.navigationController pushViewController:pdfVC animated:YES];
    }
    
    //关于本机
    else if (indexPath.row == 3) {
        
        
    }
    
    //链接
    else if (indexPath.row == 4){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.c-mecamera.com"]];
    }
}

@end
