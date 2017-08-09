//
//  ZWHSettingTableView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHSettingTableView.h"
#import "ZWHSettingCell.h"

@interface ZWHSettingTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;          //

@property(nonatomic, strong) UISwitch *swi;          //

@end

@implementation ZWHSettingTableView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self tableView];
    }
    return self;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];

        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.tableFooterView = [[UIView alloc] init];
        
        _tableView.showsHorizontalScrollIndicator = YES;
        _tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [self addSubview:_tableView];

        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return _tableView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (kIsIpad) {
        return kIpadCellHeight;
    }
    else {
        return kSettingCellHeight;
    }
}

#pragma mark - UITableViewDataDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWHSettingCell *cell = [[ZWHSettingCell alloc] init];
    
    cell.lable.text = self.titleArr[indexPath.row];
    cell.lable.textColor = kBlackColor;
    if (kIsIpad) {
        cell.lable.font = FontSize(19);
    }
    else {
        cell.lable.font = FontSize(15);
    }
    
    cell.lable.highlightedTextColor = kWhiteColor;
    cell.lable.textAlignment = NSTextAlignmentLeft;
    
    if (indexPath.row == 4) {

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *swi = [[UISwitch alloc] init];
        BOOL ret = [[kUserDefaults objectForKey:kClearScreen] boolValue];
        swi.on = ret;
        [swi addTarget:self action:@selector(swithAction) forControlEvents:UIControlEventValueChanged];
        if (kIsIpad) {
            swi.frame = CGRectMake(kWidth / 2 - 1 - 51 - 15, (kIpadCellHeight - 31)*0.5, 51, 31);
        }
        else {
            swi.frame = CGRectMake(kWidth / 2 - 1 - 51 - 15, (kSettingCellHeight - 31)*0.5, 51, 31);
        }

        [cell.contentView addSubview:swi];
        _swi = swi;
    }
    else if (indexPath.row == 5) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UISwitch *swi = [[UISwitch alloc] init];
        swi.on = [[kUserDefaults objectForKey:@"flyModel"] boolValue];
        [swi addTarget:self action:@selector(changeModel:) forControlEvents:UIControlEventValueChanged];
        swi.frame = CGRectMake(kWidth / 2 - 1 - 51 - 15, (kSettingCellHeight - 31)*0.5, 51, 31);
        [cell.contentView addSubview:swi];
    }

    else {
        if (_accessoryType == UITableViewCellAccessoryNone) {
        }
        else {
            cell.appearIndicator = YES;
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
        
    }

    return cell;
}

- (void)swithAction {
    
    if (self.swi.isOn) {
        [kUserDefaults setObject:@1 forKey:kClearScreen];
        [kUserDefaults synchronize];
    }
    else {
        [kUserDefaults setObject:@0 forKey:kClearScreen];
        [kUserDefaults synchronize];
    }
}

-(void)changeModel:(UISwitch *)swi
{
    if (swi.on) {
        [kUserDefaults setObject:@1 forKey:@"flyModel"];
    }
    else {
        [kUserDefaults setObject:@0 forKey:@"flyModel"];
    }
    if (_delegate) {
        [_delegate changeFlyModel:swi.on];
    }
    [kUserDefaults synchronize];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
        [self.delegate didSelectRowAtIndexPath:indexPath];
    }
}

- (void)dealloc {
    
}
@end
