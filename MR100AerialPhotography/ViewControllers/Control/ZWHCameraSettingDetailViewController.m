//
//  ZWHCameraSettingDetailViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHCameraSettingDetailViewController.h"
#import "ViewController.h"
#import "UIColor+HexColor.h"
#import "CameraSyncSetting.h"
#import "PGQCAEAGLLayer.h"
#import "ViewController.h"

static int imgViewInterval = 120;

@interface ZWHCameraSettingDetailViewController ()
@property(nonatomic, assign) NSInteger index;           //点击的下标
@property(nonatomic, strong) NSArray *headImageArr;     //头部图片数组
@property(nonatomic, strong) NSArray *bottomImageArr;   //底部图片数组
@property(nonatomic, weak) UIView *topBarView;          //上部导航栏
@property(nonatomic, weak) UIImageView *topImgView;     //上部标题视图

@property(nonatomic, strong) PGQCAEAGLLayer *imgView;      //中间放置的大图

@property(nonatomic, strong) UIView *bottomBarView;//底部工具栏
@property(nonatomic, weak) UIImageView *bottomImgView;          //下部标题视图

@property(nonatomic, strong) UIView *bottomSliderTypeView;//带滑动条的
@property(nonatomic, strong) UIView *bottomNoneSliderView;//不带滑动条的
@property(nonatomic, strong) UIButton *lastBtn;          //记录白平衡设置界面下面那一排上一次点击的按钮

@property(nonatomic, weak) UIView *sliderAndLableView;  //滑块和数字整体的视图

@property(nonatomic, strong) UIButton *subBtn;          //
@property(nonatomic, strong) UIButton *addBtn;          //
@property(nonatomic, strong) UISlider *slider;          //


@end

@implementation ZWHCameraSettingDetailViewController
- (instancetype)initWithSelectedIndex:(NSInteger)index {
    
    if (self = [super init]) {

        [self topBarView];
        [self bottomBarView];
        [self imgView];
        self.index = index;
        self.topImgView.image = self.headImageArr[index];
        self.bottomImgView.image = self.bottomImageArr[index];
        if (index) {
            [self sliderAndLableView];
        }
        else {
            [self bottomNoneSliderView];
        }
    }
    return self;
}

- (NSArray *)headImageArr {

    if (_headImageArr == nil) {
        if (kIsIpad) {
            _headImageArr = @[ImageNamed(@"header-wb-ipad"),ImageNamed(@"header-exposure-ipad"),ImageNamed(@"header-contrast-ipad"),ImageNamed(@"header-brightness-ipad")];
        }
        else {
            _headImageArr = @[ImageNamed(@"header-wb"),ImageNamed(@"header-exposure"),ImageNamed(@"header-contrast"),ImageNamed(@"header-brightness")];
        }
    }
    return _headImageArr;
}

- (NSArray *)bottomImageArr {

    if (_bottomImageArr == nil) {
        if (kIsIpad) {
            _bottomImageArr = @[ImageNamed(@"bottom-wb-ipad"),ImageNamed(@"bottom-exposure-ipad"),ImageNamed(@"bottom-contrast-ipad"),ImageNamed(@"bottom-brightness-ipad")];
        }
        else {
            _bottomImageArr = @[ImageNamed(@"bottom-wb"),ImageNamed(@"bottom-exposure"),ImageNamed(@"bottom-contrast"),ImageNamed(@"bottom-brightness")];
        }
    }
    return _bottomImageArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kLightGrayColor;
    ViewController *vc = [ViewController sharedViewController];
    [vc setNewDelegate:self.imgView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //发送初始化请求获取相机白平衡曝光度等当前值
    CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
    
    switch (self.index)
    {
        case 0:/** 飞机返回来的是0 - 5 */
        {
            UIButton *btn = [self.bottomNoneSliderView viewWithTag:camera.white_balance + 222];
            btn.selected = YES;
            self.lastBtn = btn;
        }
            break;
            
        case 1:/** 飞机返回来的是-4 - 4 */
        {
            self.slider.value = camera.expousure;
        }
            break;
            
        case 2:/** 飞机返回来的是0 - 8 */
        {
            self.slider.value = (NSInteger)camera.cts;
        }
            break;
            
        case 3:/** 飞机返回来的是-4 - 4 */
        {
            self.slider.value = camera.brightness;
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc {
    
    
}

#pragma mark - 懒加载

- (UIButton *)subBtn {
    if (_subBtn == nil) {
        _subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            _subBtn.frame = CGRectMake(0, 0, 75, 75);
            [_subBtn setImage:ImageNamed(@"reduce-ipad") forState:UIControlStateNormal];
        }
        else {
            _subBtn.frame = CGRectMake(0, 0, 50, 50);
            [_subBtn setImage:ImageNamed(@"bottom-reduce") forState:UIControlStateNormal];
        }
        
        [_subBtn addTarget:self action:@selector(subBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _subBtn;
}

- (void)subBtnAction:(UIButton *)sender {
    if ((int)self.slider.value > self.slider.minimumValue) {
        sender.enabled = YES;
        self.slider.value--;
        [self sendModifyCommend];
        return;
    }
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            _addBtn.frame = CGRectMake(525, 0, 75, 75);
            [_addBtn setImage:ImageNamed(@"plus-ipad") forState:UIControlStateNormal];
        }
        else {
            _addBtn.frame = CGRectMake(408, 0, 50, 50);
            [_addBtn setImage:ImageNamed(@"bottom-plus") forState:UIControlStateNormal];
        }
        
        [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (void)addBtnAction:(UIButton *)sender {
    
    if ((NSInteger)self.slider.value < self.slider.maximumValue) {
        sender.enabled = YES;
        self.slider.value++;
        [self sendModifyCommend];
        return;
    }
}

- (UIView *)sliderAndLableView {

    if (_sliderAndLableView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kClearColor;
        [self.bottomSliderTypeView addSubview:view];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = [UIColor colorWithHexString:@"#bcbec0"];
        lb.textAlignment = NSTextAlignmentLeft;
        
        [view addSubview:lb];
        [view addSubview:self.slider];
        if (kIsIpad) {
            view.frame = CGRectMake(75, 0, 455, 75);
            lb.font = [UIFont fontWithName:@"Arial" size:24];
            lb.frame = CGRectMake(0, 45, 455, 30);
            lb.text = @"-4     -3     -2     -1     0      1      2      3      4";
        }
        else {
            view.frame = CGRectMake(60, 0, 338, 50);
            lb.font = [UIFont fontWithName:@"Arial" size:20];
            lb.frame = CGRectMake(0, 30, 338, 20);
            lb.text = @"-4    -3    -2    -1     0     1     2     3     4";
        }
        _sliderAndLableView = view;
    }
    return _sliderAndLableView;
}

- (UISlider *)slider {
    if (_slider == nil)
    {
        if (kIsIpad) {
            _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 8, 455, 35)];
            [_slider setThumbImage:ImageNamed(@"contrast-control-ipad") forState:UIControlStateNormal];
        }
        else {
            _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 5, 338, 30)];
            [_slider setThumbImage:ImageNamed(@"bottom-control") forState:UIControlStateNormal];
        }
        
        _slider.minimumTrackTintColor = kGreenColor;
        _slider.maximumTrackTintColor = kGrayColor;

        
        _slider.minimumValue = -4;
        _slider.maximumValue = 4;
        
        [_slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slider;
}

- (void)sliderValueChangedAction:(UISlider *)sender
{
    if (sender.value > 0) {
        sender.value = (NSInteger)(sender.value + 0.5);
    }
    else if (sender.value <= 0){
        sender.value = ceil(sender.value - 0.5);
    }
    [self sendModifyCommend];
}

- (void)sendModifyCommend {

    NSDictionary *reqDict = nil;
    NSData *reqData = nil;
    SEQ_CMD cmd;
    CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
    switch (self.index)
    {
        case 1://曝光度设置
        {
            cmd = CMD_REQ_AE_SET;
            reqDict = @{@"CMD":@(cmd), @"PARAM":@(self.slider.value)};
            reqData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
            
            [[[ViewController sharedViewController] getTcpManager] sendData:reqData Response:^(NSData *responseData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                if ([dict[@"RESULT"] isEqual:@0])
                {
                    camera.expousure = (MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX)(self.slider.value);
                    NSLog(@"曝光度设置成功");
                }
            } Tag:0];
        }
            break;
            
        case 2://对比度设置
        {
            cmd = CMD_REQ_CONTRAST_SET;
            reqDict = @{@"CMD":@(cmd), @"PARAM":@(self.slider.value)};
            reqData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
            
            [[[ViewController sharedViewController] getTcpManager] sendData:reqData Response:^(NSData *responseData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                if ([dict[@"RESULT"] intValue] == 0)
                {
                    camera.cts = (M_CTS)(self.slider.value);
                    NSLog(@"对比度设置成功");
                }
            } Tag:0];
        }
            break;
            
        case 3://明亮度设置
        {
            cmd = CMD_REQ_BRIGHTNESS_SET;
            reqDict = @{@"CMD":@(cmd), @"PARAM":@(self.slider.value)};
            reqData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
            
            [[[ViewController sharedViewController] getTcpManager] sendData:reqData Response:^(NSData *responseData) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                if ([dict[@"RESULT"] isEqual:@0])
                {
                    
                    camera.brightness = (BRIGHTNESS)(self.slider.value);
                    NSLog(@"明亮度设置成功");
                }
            } Tag:0];
        }
            break;
            
        default:
            break;
    }
}

- (PGQCAEAGLLayer *)imgView {
    
    if (_imgView == nil) {
        
        if (kIsIpad) {
            _imgView = [[PGQCAEAGLLayer alloc] initWithFrame:CGRectMake((kWidth - (kWidth/kHeight) * (kHeight - 180))/2, 105, kWidth/kHeight * (kHeight - 180), kHeight - 180)];
        }
        else {
            _imgView = [[PGQCAEAGLLayer alloc] initWithFrame:CGRectMake((kWidth - (kWidth/kHeight) * (kHeight - imgViewInterval))/2, 60, kWidth/kHeight * (kHeight - imgViewInterval), kHeight - imgViewInterval)];
        }
        [self.view.layer addSublayer:_imgView];
        _imgView.zPosition = -1;
        _imgView.backgroundColor = [[UIColor clearColor] CGColor];
        _imgView.borderColor = kGrayColor.CGColor;
        _imgView.borderWidth = 0.5;
    }
    return _imgView;
}

#pragma mark - 底部工具栏
- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        _bottomBarView = [[UIView alloc] init];
        _bottomBarView.backgroundColor = kWhiteColor;
        _bottomBarView.layer.borderColor = kGrayColor.CGColor;
        _bottomBarView.layer.borderWidth = 1;
        [self.view addSubview:_bottomBarView];
        
        UIImageView *imgV = [[UIImageView alloc] init];
        imgV.contentMode = UIViewContentModeCenter;
        [_bottomBarView addSubview:imgV];
        if (kIsIpad) {
            _bottomBarView.frame = CGRectMake(-1, kHeight - 76, kWidth + 2, 76);
            imgV.frame = CGRectMake(15, 0, 75, 75);
        }
        else {
            _bottomBarView.frame = CGRectMake(-1, kHeight - 51, kWidth + 2, 51);
            imgV.frame = CGRectMake(15, 0, 50, 50);
        }

        _bottomImgView = imgV;
    }
    return _bottomBarView;
}

- (UIView *)bottomSliderTypeView {
    if (_bottomSliderTypeView == nil) {
        if (kIsIpad) {
            _bottomSliderTypeView = [[UIView alloc] initWithFrame:CGRectMake(kWidth - 620, 0, 600, 75)];
        }
        else {
            _bottomSliderTypeView = [[UIView alloc] initWithFrame:CGRectMake(kWidth - 468, 0, 458, 50)];
        }
        
        _bottomSliderTypeView.backgroundColor = kWhiteColor;
        [_bottomSliderTypeView addSubview:self.subBtn];
        [_bottomSliderTypeView addSubview:self.addBtn];
        
        [self.bottomBarView addSubview:_bottomSliderTypeView];
    }
    return _bottomSliderTypeView;
}

- (UIView *)bottomNoneSliderView {
    if (_bottomNoneSliderView == nil) {
        NSArray *normalIgArr = nil;
        NSArray *selectedIgArr = nil;
        CGFloat originX;
        if (kIsIpad) {
            _bottomNoneSliderView = [[UIView alloc] initWithFrame:CGRectMake(180, 0, kWidth - 180, 75)];
            normalIgArr = @[ImageNamed(@"bottom-awb-ipad"),ImageNamed(@"bottom-sunshine-ipad"),ImageNamed(@"bottom-clody-ipad"),ImageNamed(@"bottom-dark-night-ipad"),ImageNamed(@"bottom-strong-light-ipad"),ImageNamed(@"bottom-weak-light-ipad")];
            selectedIgArr = @[ImageNamed(@"bottom-awb-celec-ipad"),ImageNamed(@"bottom-sunshine-celec-ipad"),ImageNamed(@"bottom-clody-celec-ipad"),ImageNamed(@"bottom-dark-night-celec-ipad"),ImageNamed(@"bottom-strong-light-click-ipad"),ImageNamed(@"bottom-weak-light-celec-ipad")];
            originX = (kWidth - 510 - 20 - 180);
        }
        else {
            _bottomNoneSliderView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, kWidth - 80, 50)];
            normalIgArr = @[ImageNamed(@"bottom-awb"),ImageNamed(@"bottom-sunshine"),ImageNamed(@"bottom-clody"),ImageNamed(@"bottom-dark-night"),ImageNamed(@"bottom-strong-light"),ImageNamed(@"bottom-weak-light")];
            selectedIgArr = @[ImageNamed(@"bottom-awb-celec"),ImageNamed(@"bottom-sunshine-celec"),ImageNamed(@"bottom-clody-celec"),ImageNamed(@"bottom-dark-night-celec"),ImageNamed(@"bottom-strong-light-celec"),ImageNamed(@"bottom-weak-light-celec")];
            originX = (kWidth - 360 - 20 - 80);
        }
        
        _bottomNoneSliderView.backgroundColor = kWhiteColor;
        [self.bottomBarView addSubview:_bottomNoneSliderView];
        
        for (NSInteger i = 0;i < 6; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (kIsIpad) {
                btn.frame = CGRectMake(originX + i*85, 0, 85, 75);
            }
            else {
                btn.frame = CGRectMake(originX + i*60, 0, 60, 50);
            }
            
            [btn setImage:normalIgArr[i] forState:UIControlStateNormal];
            [btn setImage:selectedIgArr[i] forState:UIControlStateSelected];
            btn.tag = i + 222;
            [btn addTarget:self action:@selector(noneSliderTypeViewBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomNoneSliderView addSubview:btn];
        }
    }
    return _bottomNoneSliderView;
}

- (void)noneSliderTypeViewBtnClickAction:(UIButton *)sender {
    self.lastBtn.selected = NO;
    sender.selected = !sender.selected;
    self.lastBtn = sender;
#warning 在这里做白平衡的设置
    SEQ_CMD cmd = CMD_REQ_AUTO_AWB_SET;
    NSDictionary *reqDict = @{@"CMD":@(cmd), @"PARAM":@(sender.tag - 222)};
    NSData *reqData = [NSJSONSerialization dataWithJSONObject:reqDict options:NSJSONWritingPrettyPrinted error:nil];
    
    [[[ViewController sharedViewController] getTcpManager] sendData:reqData Response:^(NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"RESULT"] isEqual:@0])
        {
            CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
            camera.white_balance = (MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX)sender.tag - 222;
            NSLog(@"白平衡设置成功");
        }
    } Tag:0];


}

#pragma mark - 上部导航栏设置

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
            setImaView.frame = CGRectMake(kWidth / 2 - 37.5, 0, 75, 75);
        }
        else {
            view.frame = CGRectMake(0, 0, kWidth, 50);
            [btn setImage:[UIImage imageNamed:@"jt-0"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 50, 50);
            setImaView.frame = CGRectMake(kWidth / 2 - 25, 0, 50, 50);
        }
        _topImgView = setImaView;
        _topBarView = view;
    }
    return _topBarView;
}

- (void)back{

    [self.navigationController popViewControllerAnimated:YES];
}



@end
