//
//  ParaSetViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/1.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ParaSetViewController.h"
#import "ZWHOptionView.h"
#import "ZWHChoiceInputTimeButton.h"
#import "ZWHSettingTableView.h"
#import "ZWHCameraSettingController.h"
#import "ZWHDeviceSettingController.h"
#import "ZWHHelpViewController.h"
#import "ResetViewController.h"
#import "ViewController.h"
@interface ParaSetViewController ()<ZWHSettingTableViewDelegate>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, weak) ZWHOptionView *share1View;   //

@property(nonatomic, weak) ZWHOptionView *share2View;   //

@property(nonatomic, strong) UIView *textView;          //添加两个标签的视图

@property(nonatomic, strong) UIView *choiceInputTimeView;          //

@property(nonatomic, assign) ZWHOptionViewPlatformType currentAppearPlatformType;     //当前要显示的平台

@property(nonatomic, strong) ZWHSettingTableView *settingTableView;     //

@property(nonatomic, assign) NSUInteger diagnosticsCount;

@end

@implementation ParaSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIView *lineView = [[UIView alloc] init];
    if (kIsIpad) {
        lineView.frame = CGRectMake(kWidth / 2 - 1, 75, 2, kHeight - 75);
    }
    else {
        lineView.frame = CGRectMake(kWidth / 2 - 1, 50, 2, kHeight - 50);
    }

    lineView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:lineView];
    _currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
    NSInteger i1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
    if (i1 == ZWHSharePlatformGoolePlus) {
        self.choiceInputTimeView.hidden = YES;
        self.textView.hidden = YES;
    }
    else {
        self.choiceInputTimeView.hidden = NO;
        self.textView.hidden = NO;
    }
    [self topBarView];
    [self share1View];
    [self share2View];
    [self settingTableView];
    [self textView];
    [self choiceInputTimeView];
}

- (void)dealloc {

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)back{

    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 选中的单元格跳转界面的方法
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //相机
    if (indexPath.row == 0) {
        ZWHCameraSettingController *vc = [[ZWHCameraSettingController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //无人机
    else if (indexPath.row == 1) {
        ZWHDeviceSettingController *vc = [[ZWHDeviceSettingController alloc] init];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    //帮助
    else if (indexPath.row == 2) {
        ZWHHelpViewController *vc = [[ZWHHelpViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    //零偏校准
    else if (indexPath.row == 3) {
        ResetViewController *vc = [[ResetViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
}

#pragma mark - 懒加载

- (UIView *)topBarView {

    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIImageView *setImaView = [[UIImageView alloc] init];
        setImaView.contentMode = UIViewContentModeCenter;
        [view addSubview:setImaView];
        
        [self.view addSubview:view];
        if (kIsIpad) {
            view.frame = CGRectMake(0, 0, kWidth, 75);
            [btn setImage:[UIImage imageNamed:@"jt-ipad"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 75, 75);
            setImaView.image = [UIImage imageNamed:@"set-up-ipad"];
            setImaView.frame = CGRectMake(kWidth / 2 - 37.5, 0, 75, 75);
        }
        else {
            view.frame = CGRectMake(0, 0, kWidth, 50);
            [btn setImage:[UIImage imageNamed:@"jt-0"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 50, 50);
            setImaView.image = [UIImage imageNamed:@"set-up"];
            setImaView.frame = CGRectMake(kWidth / 2 - 25, 0, 50, 50);
        }

        _topBarView = view;
    }
    return _topBarView;
}

- (ZWHOptionView *)share1View {
    if (_share1View == nil) {
        ZWHOptionView *view = nil;
        if (kIsIpad) {
            view = [[ZWHOptionView alloc] initWithFrame:CGRectMake(0, 75, kWidth / 2 - 1, kIpadCellHeight)andButtonImageName:@"Set-up-share-1-ipad" dropDownListTitleArray:@[@"FaceBook",@"Twitter",@"Google +",@"YouTube"] platformType:ZWHOptionViewPlatformTypeShare1];
        }
        else {
            view = [[ZWHOptionView alloc] initWithFrame:CGRectMake(0, 50, kWidth / 2 - 1, kSettingCellHeight) andButtonImageName:@"set_share1" dropDownListTitleArray:@[@"FaceBook",@"Twitter",@"Google +",@"YouTube"] platformType:ZWHOptionViewPlatformTypeShare1];
        }
    
        __weak typeof(self) weakSelf = self;
        [view handleClickEventsWhiteBlock:^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSInteger i2 = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
            if ((log2(i2)-4) == index) {
                NSNumber *n1 = [kUserDefaults objectForKey:kShare1Platform];
                NSNumber *n2 = [kUserDefaults objectForKey:kShare2Platform];
                [kUserDefaults setObject:n2 forKey:kShare1Platform];
                [kUserDefaults setObject:n1 forKey:kShare2Platform];
                [kUserDefaults synchronize];
            }
            else {
                NSInteger i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
                [kUserDefaults setObject:@(1 << (index+4) | i) forKey:kShare1Platform];
                [kUserDefaults synchronize];
                [strongSelf share2View];
            }
            
            strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
            [strongSelf changeInputTimeViewSelectedButton];
            
            if (index == 2) {
                strongSelf.choiceInputTimeView.hidden = YES;
                strongSelf.textView.hidden = YES;
            }
            else {
                strongSelf.choiceInputTimeView.hidden = NO;
                strongSelf.textView.hidden = NO;
            }
            
        } andGrayBlock:^(BOOL hidden){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (hidden) {
                strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
                [strongSelf changeInputTimeViewSelectedButton];
                [strongSelf.share2View removeFromSuperview];
            }
            else {
                [strongSelf share2View];
                strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
                [strongSelf changeInputTimeViewSelectedButton];
            }
            NSInteger i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
            if (i == ZWHSharePlatformGoolePlus) {
                strongSelf.choiceInputTimeView.hidden = YES;
                strongSelf.textView.hidden = YES;
            }
            else {
                strongSelf.choiceInputTimeView.hidden = NO;
                strongSelf.textView.hidden = NO;
            }
        }];
        
        [self.view addSubview:view];
        _share1View = view;
    }
    return _share1View;
}

- (ZWHOptionView *)share2View {
    if (_share2View == nil) {
        ZWHOptionView *view = nil;
        if (kIsIpad) {
            view = [[ZWHOptionView alloc] initWithFrame:CGRectMake(0, 75 + 2 + kIpadCellHeight, kWidth / 2 - 1, kIpadCellHeight) andButtonImageName:@"Set-up-share-2-ipad" dropDownListTitleArray:@[@"FaceBook",@"Twitter",@"Google +",@"YouTube"] platformType:ZWHOptionViewPlatformTypeShare2];
        }
        else {
            view = [[ZWHOptionView alloc] initWithFrame:CGRectMake(0, 50 + 2 + kSettingCellHeight, kWidth / 2 - 1, kSettingCellHeight) andButtonImageName:@"set_share2" dropDownListTitleArray:@[@"FaceBook",@"Twitter",@"Google +",@"YouTube"] platformType:ZWHOptionViewPlatformTypeShare2];
        }
        __weak typeof(self) weakSelf = self;
        [view handleClickEventsWhiteBlock:^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSInteger i1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
            if ((log2(i1)-4) == index) {
                NSNumber *n1 = [kUserDefaults objectForKey:kShare1Platform];
                NSNumber *n2 = [kUserDefaults objectForKey:kShare2Platform];
                [kUserDefaults setObject:n2 forKey:kShare1Platform];
                [kUserDefaults setObject:n1 forKey:kShare2Platform];
                [kUserDefaults synchronize];
                [strongSelf.share1View refresh];
            }
            else {
                NSInteger i = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0x0f;
                [kUserDefaults setObject:@(1 << (index+4) | i) forKey:kShare2Platform];
                [kUserDefaults synchronize];
            }
            
            strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
            [strongSelf changeInputTimeViewSelectedButton];
            NSInteger p1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
            if (p1 == ZWHSharePlatformGoolePlus) {
                strongSelf.choiceInputTimeView.hidden = YES;
                strongSelf.textView.hidden = YES;
            }
            else {
                strongSelf.choiceInputTimeView.hidden = NO;
                strongSelf.textView.hidden = NO;
            }
   
        } andGrayBlock:^(BOOL hidden){
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (hidden) {
                strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare2;
                [strongSelf changeInputTimeViewSelectedButton];
                NSInteger i1 = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
                if (i1 == ZWHSharePlatformGoolePlus) {
                    strongSelf.choiceInputTimeView.hidden = YES;
                    strongSelf.textView.hidden = YES;
                }
                else {
                    strongSelf.choiceInputTimeView.hidden = NO;
                    strongSelf.textView.hidden = NO;
                }
            }
            else {
                strongSelf.currentAppearPlatformType = ZWHOptionViewPlatformTypeShare1;
                [strongSelf changeInputTimeViewSelectedButton];
                NSInteger i1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
                if (i1 == ZWHSharePlatformGoolePlus) {
                    strongSelf.choiceInputTimeView.hidden = YES;
                    strongSelf.textView.hidden = YES;
                }
                else {
                    strongSelf.choiceInputTimeView.hidden = NO;
                    strongSelf.textView.hidden = NO;
                }
            }
        }];
        
        [self.view addSubview:view];
        
        _share2View = view;
    }
    return _share2View;
}

- (ZWHSettingTableView *)settingTableView {
    if (_settingTableView == nil) {
        if (kIsIpad) {
             _settingTableView = [[ZWHSettingTableView alloc] initWithFrame:CGRectMake(kWidth / 2 + 1, 75, kWidth / 2 - 1, 6 *kIpadCellHeight)];
        }
        else {
            _settingTableView = [[ZWHSettingTableView alloc] initWithFrame:CGRectMake(kWidth / 2 + 1, 50, kWidth / 2 - 1, kHeight - 50)];
        }

        _settingTableView.backgroundColor = kWhiteColor;
        _settingTableView.delegate = self;
         _settingTableView.titleArr = @[NSLocalizedString(@"camera", @"相机"),NSLocalizedString(@"device", @"设备"),NSLocalizedString(@"help", @"帮助"),NSLocalizedString(@"calibration", @"校准"),NSLocalizedString(@"full screen mode", @"全屏模式"),NSLocalizedString(@"indoor model", @"定高模式")];

        [self.view addSubview:_settingTableView];
    }
    return _settingTableView;
}

-(void)changeFlyModel:(BOOL)model
{
    ViewController *vc = [ViewController sharedViewController];
    [vc getFlyManager].controller.flyModel = model;
}

- (UIView *)choiceInputTimeView {
    if (_choiceInputTimeView == nil) {
        if (kIsIpad) {
            _choiceInputTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - kIpadCellHeight, kWidth / 2 - 1, kIpadCellHeight)];
        }
        else {
            _choiceInputTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - kSettingCellHeight, kWidth / 2 - 1, kSettingCellHeight)];
        }
        
        _choiceInputTimeView.backgroundColor = kWhiteColor;
        [self.view addSubview:_choiceInputTimeView];
        
       NSInteger number = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
        
        NSArray *titleArr = @[NSLocalizedString(@"before", @"之前"),NSLocalizedString(@"after", @"之后"),NSLocalizedString(@"never", @"没有")];
        for (NSInteger i = 0; i < titleArr.count; i++) {
            
            ZWHChoiceInputTimeButton *btn = [ZWHChoiceInputTimeButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * _choiceInputTimeView.frame.size.width / 3 , 0, _choiceInputTimeView.frame.size.width / 3, _choiceInputTimeView.frame.size.height);

            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
            if (kIsIpad) {
                [btn setImage:[UIImage imageNamed:@"Set-up-circle-ipad"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"Set-up-circle-ipad-click"] forState:UIControlStateSelected];
                btn.titleLabel.font = FontSize(16);
            }
            else {
                [btn setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"circle1"] forState:UIControlStateSelected];
                btn.titleLabel.font = FontSize(13);
            }
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(choiceInputTimeViewButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            if (i == 2 - (NSInteger)log2(number)) {
                btn.selected = YES;
            }
            [_choiceInputTimeView addSubview:btn];
        }
        
    }
    return _choiceInputTimeView;
}

- (void)choiceInputTimeViewButtonClickAction:(UIButton *)sender {
    
    for (id obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    if (self.currentAppearPlatformType == ZWHOptionViewPlatformTypeShare1) {
        NSInteger i = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
        switch (sender.tag) {
            case 0:
            {
                [kUserDefaults setObject:@( i | 0x04) forKey:kShare1Platform];
                [kUserDefaults synchronize];
            }
                break;
            case 1:
            {
                [kUserDefaults setObject:@( i | 0x02) forKey:kShare1Platform];
                [kUserDefaults synchronize];
            }
                break;
            case 2:
            {
                [kUserDefaults setObject:@( i | 0x01) forKey:kShare1Platform];
                [kUserDefaults synchronize];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        NSInteger i = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
        switch (sender.tag) {
            case 0:
            {
                [kUserDefaults setObject:@( i | 0x04) forKey:kShare2Platform];
                [kUserDefaults synchronize];
            }
                break;
            case 1:
            {
                [kUserDefaults setObject:@( i | 0x02) forKey:kShare2Platform];
                [kUserDefaults synchronize];
            }
                break;
            case 2:
            {
                [kUserDefaults setObject:@( i | 0x01) forKey:kShare2Platform];
                [kUserDefaults synchronize];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)changeInputTimeViewSelectedButton {
    
    NSInteger index = 0;
    if (self.currentAppearPlatformType == ZWHOptionViewPlatformTypeShare1) {
        index = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
    }
    else {
        index = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0x0f;
    }
    
    [self.choiceInputTimeView.subviews enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        if (idx == 2 - (NSInteger)log2(index)) {
            obj.selected = YES;
        }
    }];
}

- (UIView *)textView {

    if (_textView == nil) {
        _textView = [[UIView alloc] init];
        _textView.backgroundColor = kClearColor;
        [self.view addSubview:_textView];
        [self.view sendSubviewToBack:_textView];
        UILabel *lb1 = [[UILabel alloc] init];
        
        lb1.text = @"When do you add captions";
        lb1.textColor = kDarkGrayColor;
        lb1.textAlignment = NSTextAlignmentCenter;
        UILabel *lb2 = [[UILabel alloc] init];
        
        lb2.text = @"to your photos videos?";
        lb2.textColor = kDarkGrayColor;
        lb2.textAlignment = NSTextAlignmentCenter;
        [_textView addSubview:lb1];
        [_textView addSubview:lb2];
        if (kIsIpad) {
            _textView.frame = CGRectMake(0, kHeight - 2*75, kWidth/2 - 1, 75);
            lb1.frame = CGRectMake(0, 0, kWidth / 2 - 1, 75 / 2);
            lb1.font = FontSize(19);
            lb2.frame = CGRectMake(0, 75 / 2, kWidth / 2 - 1, 75 / 2);
            lb2.font = FontSize(19);
        }
        else {
            _textView.frame = CGRectMake(0, kHeight - 2*kSettingCellHeight, kWidth/2 - 1, kSettingCellHeight);
            lb1.frame = CGRectMake(0, 0, kWidth / 2 - 1, kSettingCellHeight / 2);
            lb1.font = FontSize(15);
            lb2.frame = CGRectMake(0, kSettingCellHeight / 2, kWidth / 2 - 1, kSettingCellHeight / 2);
            lb2.font = FontSize(15);
        }
    }
    return _textView;
}

@end
