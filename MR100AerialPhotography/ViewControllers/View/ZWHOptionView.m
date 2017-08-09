//
//  ZWHOptionView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/1.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHOptionView.h"
#import "ZWHButton.h"

@interface ZWHOptionView ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, copy) WhiteBgButtonDidClick whiteBlock;          //
@property(nonatomic, copy) GrayBgButtonDidClick grayBlock;          //

@property(nonatomic, weak) ZWHButton *grayButton;                //

@property(nonatomic, strong) NSArray *titleArr;          //

@property(nonatomic, assign) ZWHOptionViewPlatformType type;
@property(nonatomic, weak) UITableView *whiteBgView;          //

@end

@implementation ZWHOptionView

#pragma mark - 视图生命周期

- (instancetype)initWithFrame:(CGRect)frame andButtonImageName:(NSString *)imageName dropDownListTitleArray:(NSArray<NSString *> *)titleArr platformType:(ZWHOptionViewPlatformType)type {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        NSString *currentPlatform;
        if (type == ZWHOptionViewPlatformTypeShare1) {
            NSInteger i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
            
            currentPlatform = titleArr[(NSInteger)log2(i) - 4];
        }
        else {
            NSInteger i = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
            
            currentPlatform = titleArr[(NSInteger)log2(i) - 4];
        }
        
        [self.grayButton setTitle:currentPlatform forState:UIControlStateNormal];
        [self.grayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.grayButton setBackgroundColor:[UIColor grayColor]];
        if (kIsIpad) {
            self.grayButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
        }
        else {
            self.grayButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        }
        
        [self.grayButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.titleArr = titleArr;
        self.type = type;
    }
    return self;
}

- (void)handleClickEventsWhiteBlock:(WhiteBgButtonDidClick)whiteBlock andGrayBlock:(GrayBgButtonDidClick)grayBlock {
    
    self.whiteBlock = whiteBlock;
    self.grayBlock = grayBlock;
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
    
    static NSString *const reuseIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor greenColor];
    cell.textLabel.text = self.titleArr[indexPath.row];
    cell.textLabel.textColor = kBlackColor;
    if (kIsIpad) {
        cell.textLabel.font = FontSize(19);
    }
    else {
        cell.textLabel.font = FontSize(15);
    }
    
    cell.textLabel.highlightedTextColor = kWhiteColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.whiteBlock) {
        self.whiteBlock(indexPath.row);
    }
    if (self.grayBlock) {
        self.grayBlock(0);
        self.grayButton.selected = NO;
        [self.grayButton setTitle:self.titleArr[indexPath.row] forState:UIControlStateNormal];
    }
    CGRect frame = self.frame;
    if (kIsIpad) {
        frame.size.height = kIpadCellHeight;
    }
    else {
        frame.size.height = kSettingCellHeight;
    }
    
    self.frame = frame;
    [self.whiteBgView removeFromSuperview];
}


#pragma mark - 懒加载

- (ZWHButton *)grayButton {
    if (_grayButton == nil) {
        ZWHButton *btn = [ZWHButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor grayColor];
        if (kIsIpad) {
            btn.frame = CGRectMake(0, 0, self.frame.size.width, kIpadCellHeight);
        }
        else {
            btn.frame = CGRectMake(0, 0, self.frame.size.width, kSettingCellHeight);
        }
        
        [btn addTarget:self action:@selector(grayButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.selected = NO;
        [self addSubview:btn];
        _grayButton = btn;
    }
    return _grayButton;
}

- (UITableView *)whiteBgView {

    if (_whiteBgView == nil) {
        UITableView *view = nil;
        if (kIsIpad) {
            view = [[UITableView alloc] initWithFrame:CGRectMake(80, kIpadCellHeight, self.frame.size.width - 80, 4*kIpadCellHeight) style:UITableViewStylePlain];
        }
        else {
            view = [[UITableView alloc] initWithFrame:CGRectMake(60, kSettingCellHeight, self.frame.size.width - 60, kHeight - self.frame.origin.y - 2*kSettingCellHeight - 1) style:UITableViewStylePlain];
        }
        view.dataSource = self;
        view.delegate = self;
        view.separatorColor = [UIColor grayColor];
        view.separatorInset = UIEdgeInsetsZero;
        view.layoutMargins = UIEdgeInsetsZero;
        view.separatorStyle = 1;
        view.tableFooterView = [[UIView alloc] init];
        view.showsHorizontalScrollIndicator = YES;
        view.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [self addSubview:view];
        _whiteBgView = view;
    }
    return _whiteBgView;
}

#pragma mark - 按钮点击事件

- (void)grayButtonClickAction:(ZWHButton *)btn {
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        
        if (self.grayBlock) {
            self.grayBlock(YES);
        }
        CGRect frame = self.frame;
        if (kIsIpad) {
            frame.size.height = 4*kIpadCellHeight;
        }
        else {
            frame.size.height = kHeight - self.frame.origin.y - kSettingCellHeight - 1;
        }
        
        self.frame = frame;
        [self.whiteBgView reloadData];
        
        NSInteger i;
        //分享平台一
        if (self.type == ZWHOptionViewPlatformTypeShare1) {
            i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
        }
        else {
            //分享平台二
            i = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
        }
        [self.whiteBgView selectRowAtIndexPath:[NSIndexPath indexPathForRow:((NSInteger)log2(i) - 4) inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        return;
    }
    
    CGRect frame = self.frame;
    if (kIsIpad) {
        frame.size.height = kIpadCellHeight;
    }
    else {
        frame.size.height = kSettingCellHeight;
    }
    
    self.frame = frame;
    [self.whiteBgView removeFromSuperview];
    if (self.grayBlock) {
        self.grayBlock(NO);
    }
}

- (void)refresh {
    
    //分享平台一
    if (self.type == ZWHOptionViewPlatformTypeShare1) {
        NSInteger i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
        [self.grayButton setTitle:self.titleArr[(NSInteger)log2(i) - 4] forState:UIControlStateNormal];
    }
    else {
        //分享平台二
        NSInteger i = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
        [self.grayButton setTitle:self.titleArr[(NSInteger)log2(i) - 4] forState:UIControlStateNormal];
    }
}

- (void)dealloc {

}

@end
