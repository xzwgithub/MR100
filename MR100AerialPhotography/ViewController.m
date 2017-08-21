//
//  ViewController.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/8/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ZWHShareManager.h"
#import "AsyncSocket.h"
#import "RtspConnection.h"
#import "Decoder.h"
#import "MP4Helper.h"
#import "Config.h"
#import "ParaSetViewController.h"
#import "Masonry.h"
#import "ZWHSettingIndicatorView.h"
#import "ZWHBatteryView.h"
#import "ZWHSdView.h"
#import "ZWHGalleryViewController.h"
#import "FZJPhotoTool.h"
#import "ZWHLockButton.h"
#import "UIFont+MyFontSize.h"
#import "ZWHFlashLedButton.h"
#import "ZWHSatelliteView.h"
#import "ZWHHelpViewController.h"
#import "CameraSyncSetting.h"
#import "FTPManager.h"
#import "PGQCAEAGLLayer.h"
#import "ZWHCaptionView.h"
#import "StatusBaseInfoModel.h"
#import "AWLinkHelper.h"
#import "AWLinkConstant.h"
#import <objc/runtime.h>
#import "StatusBaseInfoModel.h"
#import "Singleton.h"
#import "StatusSenseModel.h"
#import "ZWDebugInfoView.h"
#import "DebugInfoModel.h"
#import "AWTools.h"
#import "NSString+StatusTransform.h"


static char kAlertKey;


@interface ViewController ()<NSURLConnectionDelegate, NSStreamDelegate,UIGestureRecognizerDelegate,rtspDeleagte,responseBlockDelegate,UIAlertViewDelegate>
#pragma mark - UI相关属性

@property(nonatomic, strong) PGQCAEAGLLayer *bgImageView;          //最下面的背景图片视图
@property(nonatomic, weak) UIView *topBarView;
@property(nonatomic, weak) UIView *bottomBarView;
@property(nonatomic, weak) UIView *gesCtrView;  //触控板
@property(nonatomic, weak) UIView *mainCtrStickView;/** 限制飞控方向手势活动范围的imageView */
@property(nonatomic, weak) UIButton *topBtn;          //
@property(nonatomic, weak) UIButton *bottomBtn;          //
@property(nonatomic, weak) UIButton *leftBtn;          //
@property(nonatomic, weak) UIButton *rightBtn;          //
@property(nonatomic, weak) UIView *slideView;
@property(nonatomic, weak) UIView *trackView;//垂直导轨视图
@property(nonatomic, weak) UIButton *followBtn;
@property(nonatomic, weak) ZWHLockButton *lock;//解锁按钮
@property(nonatomic, weak) ZWHSatelliteView *sateView;//卫星视图
@property(nonatomic, weak) UIImageView *wifiImageView;          //
@property(nonatomic, weak) ZWHBatteryView *batteryView;
@property(nonatomic, weak) ZWHSdView *SDcard;
@property(nonatomic, weak) ZWHFlashLedButton *lightBtn;//提示灯按钮
@property(nonatomic, weak) UIButton *camaraBtn;//相机按钮
@property(nonatomic, weak) UIButton *liveBtn;//摄像按钮
@property(nonatomic, weak) UIButton *circleBtn;//360度旋转按钮
@property(nonatomic, weak) UIButton *emergercyBtn;//紧急降落按钮
@property(nonatomic, weak) UIButton *share1Btn;//分享按钮1
@property(nonatomic, weak) UIButton *share2Btn;//分享按钮2
@property(nonatomic, weak) UIButton *gelleryBtn;//相册按钮
@property(nonatomic, weak) UIButton *settingBtn;//设置按钮
@property(nonatomic, weak) UIButton *takeOffOrLandingBtn;//一键起飞一键降落按钮
@property(nonatomic, strong) ZWHSettingIndicatorView *cameraDropView; //相机长按下拉视图
@property(nonatomic, strong) ZWHSettingIndicatorView *cameraDropChildView; //相机长按下拉二级视图
@property(nonatomic, strong) ZWHSettingIndicatorView *liveDropView ;  //录像按钮下拉视图
@property(nonatomic, strong) ZWHSettingIndicatorView *circleDropView; //360按钮下拉视图
@property(nonatomic, strong) NSTimer *countDownTimer;                 //倒计时的定时器,录像计数的定时器
@property(nonatomic, strong) UIImage *currentImage;     //记录当前的画面
@property(nonatomic, assign) NSInteger expectedPhotoCount;          //记录要拍照的数量。思路：只要这个数不为-1，拍照按钮就不能工作，要等照片拍完后才可以

#pragma mark - 图传飞控相关属性

@property(nonatomic,strong)Decoder *h264Decoder;
@property(nonatomic,strong)MP4Helper *mp4Helper;
@property(nonatomic,strong)FlyControlManager *flyControlManager;
@property(nonatomic,assign)BOOL rtspState;

/** 飞控油门的手势 */
@property(nonatomic, strong) UIPanGestureRecognizer *acceleratorPan;
/** 飞控方向的手势 */
@property(nonatomic, strong) UIPanGestureRecognizer *directionPan;

/** 显示方向的手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *leftOrRightPan;
/** 随飞控油门手势移动的指示图 */
@property(nonatomic, strong) UIImageView *acceleratorIndicator;
/** 随飞控方向手势移动的指示图 */
@property(nonatomic, strong) UIImageView *directionIndicator;

/** 启动TCP连接的定时器 */
@property(nonatomic, strong) dispatch_source_t tcpTimer;

/** 启动调试信息定时器 */
@property(nonatomic, strong) dispatch_source_t debugInfoTimer;

@property(nonatomic, strong) NSDateFormatter *formatter;
/** 用户是否选择更新飞机版本 */
@property(nonatomic, assign) BOOL upgratedFirmware;
/** 提示用户更新飞机版本的alertcontroller */
@property(nonatomic, strong) UIAlertController *upgrateController;
/** 标记有没有在主界面，进入后台通知方法用到 */
@property(nonatomic, assign) BOOL viewDidAppear;

@property(nonatomic,strong) UIView *bigCircle;

/**
 *  调试信息View
 */
@property (nonatomic,strong) ZWDebugInfoView * debugInfoView;
/**
 *  调试信息模型
 */
@property (nonatomic,strong) DebugInfoModel * debugInfo;

/**
 *  起飞时长
 */
@property (nonatomic,assign) long  takeoff_time;


@end

@implementation ViewController
{
    NSInteger _second;//闪光灯倒计时用到的变量,录制视频也会用到秒；
    NSInteger _minute;//分钟
    
    UIImageView *_recordingImgView;//录像中的闪烁小红点
    
    FTPManager *manager;
    TcpManager *tcpManager;
    
    CGPoint _validPoint; //滑动点有效坐标
    CGPoint _translation;//滑动点起始的坐标
    BOOL _isClick;//记录用户是否点击了takeoff按钮
}

static unsigned int frameCount = 0;


#pragma mark - 控制器生命周期方法
singleton_implementation(ViewController)

- (void)loadView {
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:kBounds];
    bgView.image = [UIImage imageNamed:@"bg"];
    self.view = bgView;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resumeScreen)];
    [self.view addGestureRecognizer:tapGes];
    self.view.userInteractionEnabled = YES;
}


-(DebugInfoModel *)debugInfo
{
    if (!_debugInfo) {
        _debugInfo = [[DebugInfoModel alloc] init];
    }
    return _debugInfo;
}

//恢复
- (void)resumeScreen {
    if (kIsIpad) {
        if (self.slideView.frame.origin.x < 0) {
            [UIView animateWithDuration:0.5 animations:^{
                if (self.topBarView.frame.origin.y < 0) {
                    self.topBarView.frame = CGRectMake(0, 0, kWidth, 75);
                }
                
                self.bottomBarView.frame = CGRectMake(0, kHeight-60, kWidth, 60);
                self.slideView.frame = CGRectMake(0, kHeight - 495, 125, 370);
                self.mainCtrStickView.frame = CGRectMake(kWidth - 436, kHeight - 496, 436, 436);
                self.lock.frame = CGRectMake(kWidth/2 - 233*0.5, kHeight - 60 - 80, 233, 80);
            }];
        }
    }
    else {
        if (self.slideView.frame.origin.x < 0) {
            [UIView animateWithDuration:0.5 animations:^{
                if (self.topBarView.frame.origin.y < 0) {
                    self.topBarView.frame = CGRectMake(0, 0, kWidth, 50);
                }
                
                self.bottomBarView.frame = CGRectMake(0, kHeight-40, kWidth, 40);
                self.slideView.frame = CGRectMake(0, kHeight - 92 - kHeight*0.5, 80, kHeight*0.5);
                self.mainCtrStickView.frame = CGRectMake(kWidth - (kHeight - 90), 50, kHeight - 90, kHeight - 90);
                self.lock.frame = CGRectMake(kWidth/2 - 75, kHeight - 40 - 50, 150, 50);
            }];
        }
    }
}

//全屏
- (void)makeScreenFull {
   
    //在主页面时执行动画
    if (self.viewDidAppear && self.topBtn.frame.origin.x > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            if (kIsIpad) {
                if (!_circleDropView && !_cameraDropView && !_liveDropView) {
                    self.topBarView.frame = CGRectMake(0, -75, kWidth, 75);
                }
                self.bottomBarView.frame = CGRectMake(0, kHeight+80, kWidth, 60);
                self.slideView.frame = CGRectMake(-125, kHeight - 495, 125, 370);
                self.mainCtrStickView.frame = CGRectMake(kWidth, kHeight - 496, 436, 436);
                self.lock.frame = CGRectMake(kWidth/2 - 233*0.5, kHeight, 233, 80);
            }
            else {
                if (!_circleDropView && !_cameraDropView && !_liveDropView) {
                    self.topBarView.frame = CGRectMake(0, -50, kWidth, 50);
                }
                self.bottomBarView.frame = CGRectMake(0, kHeight+50, kWidth, 40);
                self.slideView.frame = CGRectMake(-80, kHeight - 92 - kHeight*0.5, 80, kHeight*0.5);
                self.mainCtrStickView.frame = CGRectMake(kWidth, 50, kHeight - 90, kHeight - 90);
                self.lock.frame = CGRectMake(kWidth/2 - 75, kHeight, 150, 50);
            }
            
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bgImageView];
    [self topBarView];
    [self debugInfoView];
    [self observerDebugInfo];
    [self bottomBarView];
    [self gesCtrView];
    [self mainCtrStickView];
    [self topBtn];
    [self bottomBtn];
    [self rightBtn];
    [self leftBtn];
    [self slideView];
    [self lightBtn];
    [self camaraBtn];
    [self liveBtn];
    [self followBtn];
    [self circleBtn];
    [self emergercyBtn];
    [self share2Btn];
    [self share1Btn];
    [self gelleryBtn];
    [self settingBtn];
    [self takeOffOrLandingBtn];
    [self lock];
    [self acceleratorIndicator];
    [self directionIndicator];
    [self batteryView];
    [self SDcard];
    [self sateView];
    [self wifiImageView];
    [self getStates:NO];
    
    [RtspConnection sharedRtspConnection].delegate = self;
    
    //decoder
    _h264Decoder = [[Decoder alloc] init];
    
    //tcp
    tcpManager = [[TcpManager alloc] init];
    tcpManager.delegate = self;
    if (_tcpTimer == nil) {
        dispatch_resume(self.tcpTimer);
    }
    
    
    //fly control
    [self.flyControlManager connectToDevice];
    [self.flyControlManager startUploadData];
    self.expectedPhotoCount = -1;
    
    //监听 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBg)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI)
                                                 name:kUpdateUI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(observerDebugInfo)
                                                 name:kOpenDebugMode object:nil];


}

//调试模式开关
-(void)observerDebugInfo
{
    boolean_t isOpen = [[[NSUserDefaults standardUserDefaults] objectForKey:kTestModeIsOpen] boolValue];
    
    if (isOpen) {
        
        self.debugInfoView.hidden = NO;
        [self debugInfoTimer];
        
    }else
    {
        if (_debugInfoTimer != nil) {
            dispatch_source_cancel(_debugInfoTimer);
            _debugInfoTimer = nil;
        }
        [_debugInfoView removeFromSuperview];
        _debugInfoView = nil;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (_h264Decoder) {
        _h264Decoder.showLayer = self.bgImageView;
    }
    
    if (_tcpTimer == nil) {
        dispatch_resume(self.tcpTimer);
    }
    
    self.navigationController.navigationBar.hidden = YES;
    
    [kAppDelegate sendEvent:[[UIEvent alloc] init]];
    if (kIsIpad) {
        [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.height.mas_equalTo(75);
        }];
        
        [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(-65);
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(370);
        }];
        
        [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slideView.mas_left).with.offset(53.5);
            make.bottom.equalTo(self.slideView.mas_bottom).with.offset(0);
            make.top.equalTo(self.slideView.mas_top).with.offset(0);
            make.width.mas_equalTo(18);
        }];
        
        [self.acceleratorIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.slideView);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        [self.mainCtrStickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(0);
            make.width.mas_equalTo(436);
            make.height.mas_equalTo(436);
        }];
        
        [self.gesCtrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight * 0.5);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(-10);
            make.right.equalTo(self.mainCtrStickView.mas_left).with.offset(-10);
            make.left.equalTo(self.slideView.mas_right).with.offset(10);
            
        }];
        
        [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.height.equalTo(@60);
        }];
        
        [self.camaraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.camaraBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.liveBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.emergercyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(229, 58));
        }];
        
        
        [self.share1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emergercyBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.share2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.share1Btn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.share2Btn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kIpadMainTopBtnWidth);
            make.height.mas_equalTo(75);
        }];
        
        [self.SDcard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth);
            make.height.mas_equalTo(60);
        }];
        
        [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.SDcard.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(60);
        }];
        
        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.batteryView.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(60);
        }];
        
        [self.sateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wifiImageView.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(60);
        }];
        
        [self.takeOffOrLandingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBarView.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(233, 60));
        }];
        
        [self.lock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.batteryView.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(233, 80));
        }];
        
        [self.gelleryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.takeOffOrLandingBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth);
            make.height.mas_equalTo(60);
        }];
        
        [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gelleryBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth);
            make.height.mas_equalTo(60);
        }];
        
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.settingBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kIpadMainBottomBtnWidth);
            make.height.mas_equalTo(60);
        }];
        
        [self.debugInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.topBarView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(130);
            
        }];
        
    }
    else {
        [self.topBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.height.mas_equalTo(50);
        }];
        
        [self.slideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(-40);
            make.top.greaterThanOrEqualTo(self.topBarView.mas_bottom).with.offset(40);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(kHeight * 0.5);
        }];
        
        [self.trackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.slideView.mas_left).with.offset(35);
            make.bottom.equalTo(self.slideView.mas_bottom).with.offset(0);
            make.top.equalTo(self.slideView.mas_top).with.offset(0);
            make.width.mas_equalTo(10);
        }];
        
        [self.acceleratorIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.slideView);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        [self.mainCtrStickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(0);
            make.width.mas_equalTo(kHeight - 90);
            make.height.mas_equalTo(kHeight - 90);
        }];
        
        [self.gesCtrView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kHeight * 0.5);
            make.bottom.equalTo(self.bottomBarView.mas_top).with.offset(-20);
            make.right.equalTo(self.mainCtrStickView.mas_left).with.offset(0);
            make.left.equalTo(self.slideView.mas_right).with.offset(0);
        }];
        
        [self.bottomBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.height.equalTo(@40);
        }];
        
        [self.camaraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.liveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.camaraBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.liveBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.emergercyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(148, 39));
        }];
        
        
        [self.share1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.emergercyBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.share2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.share1Btn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.share2Btn.mas_right).with.offset(0);
            make.centerY.equalTo(self.topBarView);
            make.width.mas_equalTo(kMainTopBtnWidth);
            make.height.mas_equalTo(50);
        }];
        
        [self.SDcard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth);
            make.height.mas_equalTo(40);
        }];
        
        [self.batteryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.SDcard.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(40);
        }];
        
        [self.wifiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.batteryView.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(40);
        }];
        
        [self.sateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.wifiImageView.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth*2/3);
            make.height.mas_equalTo(40);
        }];
        
        [self.takeOffOrLandingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomBarView.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(150, 40));
        }];
        
        [self.lock mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.batteryView.mas_top).with.offset(0);
            make.centerX.equalTo(self.bottomBarView.mas_centerX).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(150, 50));
        }];
        
        [self.gelleryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.takeOffOrLandingBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth);
            make.height.mas_equalTo(40);
        }];
        
        [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.gelleryBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth);
            make.height.mas_equalTo(40);
        }];
        
        [self.followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.settingBtn.mas_right).with.offset(0);
            make.centerY.equalTo(self.bottomBarView);
            make.width.mas_equalTo(kMainBottomBtnWidth);
            make.height.mas_equalTo(40);
        }];
        
        [self.debugInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            make.top.equalTo(self.topBarView.mas_bottom).with.offset(0);
            make.height.mas_equalTo(130);
            
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewDidAppear = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self tapGesClickAction];
    if (_tcpTimer != nil) {
        dispatch_source_cancel(_tcpTimer);
        _tcpTimer = nil;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.viewDidAppear = NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.lock removeObserver:self forKeyPath:@"selected"];
}

#pragma mark - 监听应用进入前台后台方法

-(void)becomeActive {
    
    if (_tcpTimer == nil) {
        dispatch_resume(self.tcpTimer);
    }
//    if (_debugInfoTimer == nil) {
//        dispatch_resume(self.debugInfoTimer);
//    }
    
    if (kIsIpad) {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-ash-ipad"] forState:UIControlStateNormal];
        [self getStates:NO];
        
        if (self.lock.selected) {
            [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-green-ipad"] forState:UIControlStateNormal];
            [self getStates:YES];
        }
    }
    else {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
        [self getStates:NO];
        
        if (self.lock.selected) {
            [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-green"] forState:UIControlStateNormal];
            [self getStates:YES];
        }
    }
    
    
    if ([self.flyControlManager isConnected]) {
        
        
    }
    else{
    
        [self.flyControlManager connectToDevice];
        [self.flyControlManager startUploadData];
    }
}

-(void)enterBg {
    //    关闭follow me
    if (self.followBtn.selected) {
        [self followBtnClickAction:nil];
    }
    
    if (_tcpTimer != nil) {
        dispatch_source_cancel(_tcpTimer);
        _tcpTimer = nil;
    }
//    if (_debugInfoTimer != nil) {
//        dispatch_source_cancel(_debugInfoTimer);
//        _debugInfoTimer = nil;
//    }
    
    //  关闭所有的下拉视图，相应的计时器关闭
    [self tapGesClickAction];
    
    if ([[RtspConnection sharedRtspConnection] isConnecting])
    {
        [[RtspConnection sharedRtspConnection] close_rtsp_client];
    }
    [tcpManager disConnectTcp];
    
    [self.flyControlManager stopUploadData];
    [self.flyControlManager disconnectDevice];
    
}

-(TcpManager *)getTcpManager
{
    return tcpManager;
}

- (void)connectRtsp {
    
    TcpManager *tcpMgr = [TcpManager defaultManager];
    tcpMgr.delegate = self;
    [tcpMgr tcpConnect];
    
   
    SEQ_CMD cmd = CMD_REQ_VID_ENC_PREVIEW_ON;
    NSDictionary *params = @{@"CMD":[NSNumber numberWithInt:cmd],@"PARAM":[NSNumber numberWithInt:-1]};
    NSData *encode_data = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [tcpMgr sendData:encode_data Response:^(NSData *data){
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (result && ( [[result objectForKey:@"RESULT"] intValue] == 1 ||[[result objectForKey:@"RESULT"] intValue] == 0)) {
            
            [[RtspConnection shareStore] start_rtsp_session:NO];
            NSLog(@"开启rtsp");
            //设置日期时间
            [self syncSysTime];
            
        }
    } Tag:0];
}

#pragma mark -开始录制
-(void)startRecord {
    //录制
    if (_mp4Helper) {
        [_mp4Helper startRecord:[[self dateFormat] UTF8String] Width:1280 Height:720];
    }
    if ([[RtspConnection sharedRtspConnection] isConnecting])
    {
        //飞机录制
        SEQ_CMD cmd = CMD_REQ_VID_ENC_START;
        NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@(-1)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        [tcpManager sendData:data Response:^(NSData *responseData) {
            
        } Tag:0];
    }
}

#pragma mark -结束录制
-(void)closeRecord {
    
    if (self.mp4Helper && [self.mp4Helper isRecording]) {
        [_mp4Helper closeFile];
        //飞机关闭录制
        SEQ_CMD cmd = CMD_REQ_VID_ENC_STOP;
        NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@(-1)};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        [tcpManager sendData:data Response:^(NSData *responseData) {
            
        } Tag:0];
    }
}

#pragma mark -控制所有的下拉视图消失
- (void)tapGesClickAction {
    
    [self liveDropViewbuttonClickAction:nil];
    [self circleDropViewbuttonClickAction:nil];
    [self removeCameraDropView];
}

#pragma mark -关闭和开启状态
-(void)getStates:(BOOL)state {
    self.slideView.userInteractionEnabled = state;
//    self.mainCtrStickView.userInteractionEnabled = state;
    self.gesCtrView.userInteractionEnabled = state;
    self.takeOffOrLandingBtn.userInteractionEnabled = state;
    self.followBtn.userInteractionEnabled = state;
}

#pragma mark -获取当前的背景图片
- (UIImage *)currentImage {
    
    if (self.bgImageView.contents) {
        return [self.bgImageView currentImg];
    }
    
    return [UIImage imageNamed:@"bg"];
}

#pragma mark -锁住飞控
-(void)lockStatues {
    [self getStates:NO];
    self.lock.hidden = NO;//显示锁按钮
    self.lock.selected = NO;
    self.takeOffOrLandingBtn.selected = NO;
    if (kIsIpad) {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-ash-ipad"] forState:UIControlStateNormal];
    }
    else {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - 油门手柄视图
- (UIImageView *)acceleratorIndicator {
    if (_acceleratorIndicator == nil) {
        UIImageView *imaView = nil;
        //滑块
        if (kIsIpad) {
            imaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sliding-rod-ipad"]];
        }
        else {
            imaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Sliding-rod"]];
        }
        self.acceleratorPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveAcceleratorIndicator:)];
        [self.slideView addGestureRecognizer:self.acceleratorPan];
        [self.slideView addSubview:imaView];
        
        _acceleratorIndicator = imaView;
    }
    return _acceleratorIndicator;
}

#pragma mark -油门控制按钮
- (void)moveAcceleratorIndicator:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.slideView];
    NSLog(@"acceleratorIndicator:%@",NSStringFromCGPoint(point));
    if (kIsIpad) {
        if (CGRectContainsPoint(self.slideView.bounds, point))
        {
            self.acceleratorIndicator.center = CGPointMake(125*0.5, point.y);
        }
        
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            self.acceleratorIndicator.frame = CGRectMake(25, self.slideView.bounds.size.height/2 - 37.5, 75, 75);
        }
    }
    else {
        if (CGRectContainsPoint(self.slideView.bounds, point))
        {
            self.acceleratorIndicator.center = CGPointMake(40, point.y);
        }
        
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            self.acceleratorIndicator.frame = CGRectMake(18, kHeight * 0.25 - 22-5, 44, 44);
        }
    }
    
    if (self.flyControlManager) {
        CGPoint acceleratorPoint = self.acceleratorIndicator.center;
        
        int16_t ymValue;
        
        if (acceleratorPoint.y>=0 && acceleratorPoint.y < self.slideView.bounds.size.height/2) {
            
            ymValue = (self.slideView.bounds.size.height/2 - acceleratorPoint.y)*1000/(_slideView.bounds.size.height/2);
            
            _flyControlManager.controller.youmen = abs(ymValue);
            
        }else if(acceleratorPoint.y > self.slideView.bounds.size.height/2 && acceleratorPoint.y <= self.slideView.bounds.size.height)
        {
            ymValue = ((acceleratorPoint.y-self.slideView.bounds.size.height/2))*1000/(_slideView.bounds.size.height/2);
            
             _flyControlManager.controller.youmen = -abs(ymValue) ;
        }else if (acceleratorPoint.y == self.slideView.bounds.size.height/2)
        {
            _flyControlManager.controller.youmen = 0;
        }
        
         NSLog(@"油门:%hd",_flyControlManager.controller.youmen);
//        _flyControlManager.controller.youmen = (self.slideView.bounds.size.height - acceleratorPoint.y)*1000/(_slideView.bounds.size.height);
       
    }
}

#pragma mark -方向手柄视图
- (UIImageView *)directionIndicator {
    if (_directionIndicator == nil) {
        UIImageView *imaView = [[UIImageView alloc]init];
        
        if (kIsIpad) {
            imaView.frame = CGRectMake(350*0.25,350*0.25, 350*0.5, 350*0.5);
            imaView.layer.masksToBounds = YES;
            imaView.layer.cornerRadius = 350*0.25;
        }
        else {
            imaView.frame = CGRectMake(kHeight * 0.125 + (kHeight - 90 - 0.5*kHeight - 52),kHeight * 0.125 + (kHeight - 90 - 0.5*kHeight - 52), kHeight * 0.25, kHeight * 0.25);
            imaView.layer.masksToBounds = YES;
            imaView.layer.cornerRadius = kHeight * 0.125;
        }
        
        
        imaView.layer.borderColor = [UIColor whiteColor].CGColor;
        imaView.layer.borderWidth = 3;
        imaView.backgroundColor = kRGBAColorFloat(0.3, 0.3, 0.3, 0.3);
        
        self.directionPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveDirectionIndicator:)];
        [self.mainCtrStickView addGestureRecognizer:self.directionPan];
        [self.mainCtrStickView addSubview:imaView];
        [self.mainCtrStickView bringSubviewToFront:imaView];
        
        _directionIndicator = imaView;
    }
    return _directionIndicator;
}

#pragma mark -方向控制按钮
- (void)moveDirectionIndicator:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.mainCtrStickView];
    
    if ([self judgeIsThePointInTheCicleRect:point])
    {
        self.directionIndicator.center = point;
    }
    else {
        
        self.directionIndicator.center = [self translateOutPointToIn:point];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (kIsIpad) {
            self.directionIndicator.center = CGPointMake(175, 175);
        }
        else {
            self.directionIndicator.center = CGPointMake(kHeight * 0.25 + (kHeight - 90 - 0.5*kHeight - 52), kHeight * 0.25 + (kHeight - 90 - 0.5*kHeight - 52));
        }
    }
    if (self.flyControlManager) {
        CGPoint directionPoint = self.directionIndicator.center;
        CGPoint bigCirclePoint = _bigCircle.center;
        _flyControlManager.controller.shengjiang = floor((bigCirclePoint.y - directionPoint.y)*1000/(0.125*kHeight));
        _flyControlManager.controller.fuyi = floor((directionPoint.x-bigCirclePoint.x)*1000/(0.125*kHeight));
        NSLog(@"fuyi:%hd---shengjiang:%hd", _flyControlManager.controller.fuyi, _flyControlManager.controller.shengjiang);
        
//        NSLog(@"%f--------%f",(bigCirclePoint.y - directionPoint.y)/(0.125*kHeight),(directionPoint.x-bigCirclePoint.x)/(0.125*kHeight));
    }
    
}

#pragma mark -判断点是否在圆形区域，用以限制方向盘的拖动范围
- (BOOL)judgeIsThePointInTheCicleRect:(CGPoint)point {
    CGFloat x = point.x;
    CGFloat y = point.y;
   
    if (kIsIpad) {
        CGFloat centerMainCtrX = 175;
        CGFloat centerMainCtrY = 175;
        //触摸点在x，y方向距离圆心的距离
        CGFloat xDistance = fabs(x - centerMainCtrX);
        CGFloat yDistance = fabs(y - centerMainCtrY);
        
        CGFloat r = 175*0.5;
        
        //当前点到圆心的距离
        CGFloat rSquare = fabs(xDistance * xDistance) + fabs(yDistance * yDistance);
        BOOL square = (rSquare <= r * r);
        
        if (square) {
            return YES;
        }
        return NO;
        
    }
    
    CGFloat centerMainCtrX = kHeight - 90 - 52 - 0.25*kHeight;
    CGFloat centerMainCtrY = kHeight - 90 - 52 - 0.25*kHeight;
    //触摸点在x，y方向距离圆心的距离
    CGFloat xDistance = fabs(x - centerMainCtrX);
    CGFloat yDistance = fabs(y - centerMainCtrY);
    
    CGFloat r = kHeight * 0.125;
    
    //当前点到圆心的距离
    CGFloat rSquare = fabs(xDistance * xDistance) + fabs(yDistance * yDistance);
    BOOL square = (rSquare <= r * r);
    
    if (square) {
        return YES;
    }
    return NO;
}

#pragma mark -把圆形外部的点，转化为符合条件的内部的点
- (CGPoint)translateOutPointToIn:(CGPoint)point {
    
    //触摸点的x,y
    CGFloat x = point.x;
    CGFloat y = point.y;
    CGFloat centerMainCtrX;
    CGFloat centerMainCtrY;
    CGFloat r;
    if (kIsIpad) {
        //mainCtr的中心点x,y
        centerMainCtrX = 175;
        centerMainCtrY = 175;
        //轨道半径
        r = 175*0.5;
    }
    else {
        //mainCtr的中心点x,y
        centerMainCtrX = kHeight - 90 - 52 - 0.25*kHeight;
        centerMainCtrY = kHeight - 90 - 52 - 0.25*kHeight;
        //轨道半径
        r = kHeight * 0.125;
    }
   
    
    //触摸点在x，y方向距离圆心的距离
    CGFloat xDistance = fabs(x - centerMainCtrX);
    CGFloat yDistance = fabs(y - centerMainCtrY);
    
    //当前点到圆心的距离
    CGFloat rSquare = fabs(xDistance * xDistance) + fabs(yDistance * yDistance);
    CGFloat rPoint = pow(rSquare, 0.5);
    
    //转化之后的点xy方向距离圆心的距离
    xDistance = r * xDistance / rPoint;
    yDistance = r * yDistance / rPoint;
    
    //第一象限
    if (x <= centerMainCtrX && y <= centerMainCtrY) {
        
        return CGPointMake(centerMainCtrX - xDistance, centerMainCtrY - yDistance);
    }
    //第二象限
    else if (x > centerMainCtrX && y <= centerMainCtrY) {
        
        return CGPointMake(centerMainCtrX + xDistance, centerMainCtrY - yDistance);
    }
    //第三象限
    else if (x > centerMainCtrX && y > centerMainCtrY) {
        
        return CGPointMake(centerMainCtrX + xDistance, centerMainCtrY + yDistance);
    }
    //第四象限
    else {
        return CGPointMake(centerMainCtrX - xDistance, centerMainCtrY + yDistance);
    }
}

#pragma mark -触控板
- (UIView *)gesCtrView {
    if (_gesCtrView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kClearColor;
        [self.view addSubview:view];
        _gesCtrView = view;
        _gesCtrView.userInteractionEnabled = YES;
        self.leftOrRightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveleftOrRight:)];
        [_gesCtrView addGestureRecognizer:self.leftOrRightPan];
    }
    return _gesCtrView;
}

#pragma mark -触控板左右
-(void)moveleftOrRight:(UIPanGestureRecognizer*)sender {
    
    CGPoint temp = [sender translationInView:self.gesCtrView];
    _validPoint = temp;  //有效点
    if (sender.state == UIGestureRecognizerStateBegan) {
        _translation = temp;  //起始点
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        _validPoint = _translation = CGPointMake(0, 0);
    }
    if (self.flyControlManager) {
        //算出有效滑动距离  -127 ~ 127
        
        float distance = _validPoint.x - _translation.x;
        if (distance < -_gesCtrView.bounds.size.width) {
            distance = -_gesCtrView.bounds.size.width;
        }
        else if (distance > _gesCtrView.bounds.size.width)
        {
            distance = _gesCtrView.bounds.size.width;
        }
        _flyControlManager.controller.fangxiang = floor(distance/self.gesCtrView.bounds.size.width*1000);
        NSLog(@"fangxiang:%hd",_flyControlManager.controller.fangxiang);
    }
    
}

#pragma mark - 照相按钮的懒加载及相应方法
- (UIButton *)camaraBtn {
    if (_camaraBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"camera-clike-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"camera-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"camera-clike"] forState:UIControlStateSelected];
        }
       
        [btn addTarget:self action:@selector(camara:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(camaraBtnbtnLong:)];
        longPress.minimumPressDuration = 1;
        [btn addGestureRecognizer:longPress];
        [self.topBarView addSubview:btn];
        
        _camaraBtn = btn;
    }
    return _camaraBtn;
}

#pragma mark -点击拍照
-(void)camara:(UIButton*)btn {
    BOOL ret = NO;
    if (btn.selected) {
        ret = YES;//记录这个按钮是不是只想关闭拍照长按视图
    }
    //拍照前清除所有下拉视图
    [self tapGesClickAction];
    
    if (_liveBtn.selected || _circleBtn.selected || !_rtspState || ret)//有下拉视图时不能拍照
    {
      return;
    }
    
    //如果连拍的这个变量不等于－1，则按钮不能操作
    if (self.expectedPhotoCount != -1) {
        return;
    }
    
    SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
    NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@1,@"delay":@0}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [tcpManager sendData:data Response:^(NSData *responseData) {
        
    } Tag:0];
    [self takePhotoFlashScreenWithImage:self.currentImage];
    _h264Decoder.takePhotosNum = 1;
}

#pragma mark -拍照闪屏效果
- (void)takePhotoFlashScreenWithImage:(UIImage *)image {
    self.camaraBtn.userInteractionEnabled = NO;
    AudioServicesPlaySystemSound(1108);
    self.view.alpha = 0;
    UIImageView *imgView;
    if (kIsIpad) {
        if (imgView == nil) {
            imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = CGRectMake(130, 85, 130, 130 * kHeight / kWidth);
            imgView.layer.borderColor = kWhiteColor.CGColor;
            imgView.layer.borderWidth = 3;
        }
    }
    else {
        if (imgView == nil) {
            imgView = [[UIImageView alloc] initWithImage:image];
            imgView.frame = CGRectMake(100, 55, 100, 100 * kHeight / kWidth);
            imgView.layer.borderColor = kWhiteColor.CGColor;
            imgView.layer.borderWidth = 3;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1;
        [self.view addSubview:imgView];
    } completion:^(BOOL finished) {
        
        if (self.expectedPhotoCount > -1)  {
            
            [imgView removeFromSuperview];
            self.expectedPhotoCount--;
            [self takePhotoFlashScreenWithImage: self.currentImage];
            return;
        }
        
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imgView removeFromSuperview];
                self.gelleryBtn.userInteractionEnabled = YES;
                self.camaraBtn.userInteractionEnabled = YES;
            });
        }
    }];
}

#pragma mark-长按拍照按钮
-(void)camaraBtnbtnLong:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (_liveBtn.selected || _circleBtn.selected || !_rtspState)//录像时不能拍照
    {
        return;
    }
    
    self.camaraBtn.selected = YES;
    
    if (_cameraDropView == nil) {
        if (kIsIpad) {
            _cameraDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 111.5)/2, 75, kWidth * 0.5 - 111.5, 45)];
        }
        else {
            _cameraDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 74)/2, 50, kWidth * 0.5 - 74, 30)];
        }
        
        
        UIButton *delayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delayBtn addTarget:self action:@selector(delayBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraDropView addSubview:delayBtn];
        
        UIButton *continuousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [continuousBtn addTarget:self action:@selector(continuousBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cameraDropView addSubview:continuousBtn];
        
        if (kIsIpad) {
            [delayBtn setImage:[UIImage imageNamed:@"delayed-ipad"] forState:UIControlStateNormal];
            [delayBtn setImage:[UIImage imageNamed:@"delayed-clike-ipad"] forState:UIControlStateSelected];
            delayBtn.frame = CGRectMake(25, 0, (kWidth * 0.5 - 111.5 - 50)*0.5, 45);
            [continuousBtn setImage:[UIImage imageNamed:@"Continuous-shooting-ipa"] forState:UIControlStateNormal];
            [continuousBtn setImage:[UIImage imageNamed:@"Continuous-shooting-clike-ipa"] forState:UIControlStateSelected];
            continuousBtn.frame = CGRectMake(25+(kWidth * 0.5 - 111.5 - 50)*0.5, 0, (kWidth * 0.5 - 111.5 - 50)*0.5, 45);
        }
        else {
            [delayBtn setImage:[UIImage imageNamed:@"delayed"] forState:UIControlStateNormal];
            [delayBtn setImage:[UIImage imageNamed:@"delayed-selec"] forState:UIControlStateSelected];
            delayBtn.frame = CGRectMake(15, 0, (kWidth * 0.5 - 74 - 30)*0.5, 30);
            [continuousBtn setImage:[UIImage imageNamed:@"Continuous-shooting"] forState:UIControlStateNormal];
            [continuousBtn setImage:[UIImage imageNamed:@"Continuous-shooting-selec"] forState:UIControlStateSelected];
            continuousBtn.frame = CGRectMake(15+(kWidth * 0.5 - 74 - 30)*0.5, 0, (kWidth * 0.5 - 74 - 30)*0.5, 30);
        }
        
        [self.view addSubview:_cameraDropView];
    }
}

#pragma mark -倒计时按钮
- (void)delayBtnDidClick:(UIButton *)sender {
    
    for (id obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    if (_cameraDropChildView == nil) {
        if (kIsIpad) {
            _cameraDropChildView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 111.5 - 50)/2, 120, kWidth * 0.5 - 111.5 - 50, 45)];
        }
        else {
            _cameraDropChildView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 74 - 30)/2, 80, kWidth * 0.5 - 74 - 30, 30)];
        }
        
        [self.view addSubview:_cameraDropChildView];
    }
    for (id obj in _cameraDropChildView.subviews) {
        [obj removeFromSuperview];
    }
    
    UIButton *threeSecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [threeSecBtn setTitle:@"3s" forState:UIControlStateNormal];
    [threeSecBtn addTarget:self action:@selector(threeSecBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraDropChildView addSubview:threeSecBtn];
    
    UIButton *tenSecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tenSecBtn setTitle:@"10s" forState:UIControlStateNormal];
    [tenSecBtn addTarget:self action:@selector(tenSecBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (kIsIpad) {
        threeSecBtn.frame = CGRectMake(25, 0, (kWidth * 0.5 - 111.5 - 50 - 50)*0.5, 45);
        [threeSecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        threeSecBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
        
        [tenSecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tenSecBtn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
        tenSecBtn.frame = CGRectMake(25+(kWidth * 0.5 - 111.5 - 50 - 50)*0.5, 0, (kWidth * 0.5 - 111.5 - 50 - 50)*0.5, 45);
    }
    else {
        threeSecBtn.frame = CGRectMake(15, 0, (kWidth * 0.5 - 74 - 30 - 30)*0.5, 30);
        [threeSecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        threeSecBtn.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        
        [tenSecBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tenSecBtn.titleLabel.font = [UIFont boldSystemFontOfSize:23];
        tenSecBtn.frame = CGRectMake(15+(kWidth * 0.5 - 74 - 30 - 30)*0.5, 0, (kWidth * 0.5 - 74 - 30 - 30)*0.5, 30);
    }
    [_cameraDropChildView addSubview:tenSecBtn];
    
}

#pragma mark -三秒按钮
- (void)threeSecBtnDidClick:(UIButton *)sender {
    _cameraDropView.userInteractionEnabled = NO;
    UIView *view = sender.superview;
    
    for (id obj in sender.superview.subviews) {
        [obj removeFromSuperview];
    }
    
    _second = 3;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"3";
    if (kIsIpad) {
        lab.font = [UIFont boldSystemFontOfSize:26];
        lab.frame = CGRectMake(25, 0, kWidth * 0.5 - 111.5 - 50 - 50, 45);
    }
    else {
        lab.font = [UIFont boldSystemFontOfSize:23];
        lab.frame = CGRectMake(15, 0, kWidth * 0.5 - 74 - 30 - 30, 30);
    }
    
    lab.textColor = kWhiteColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(threeSecTimerAction:) userInfo:lab repeats:YES];
    
    [self.countDownTimer fire];
    
}

#pragma mark -三秒倒计时器
- (void)threeSecTimerAction:(NSTimer *)timer {
    
    UILabel *lab = timer.userInfo;
    
    if (_second >= 0) {
        lab.text = [NSString stringWithFormat:@"%ld",_second];
        _second--;
        return;
    }
    [lab.superview removeFromSuperview];
    [self.cameraDropView removeFromSuperview];
    _cameraDropView = nil;
    _cameraDropChildView = nil;
    self.camaraBtn.selected = NO;
    [timer invalidate];
    timer = nil;
    
    //飞机拍照
    SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
    NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@1,@"delay":@3}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [tcpManager sendData:data Response:^(NSData *responseData) {
        
    } Tag:0];
    [self takePhotoFlashScreenWithImage:self.currentImage];
    _h264Decoder.takePhotosNum = 1;
}

#pragma mark -十秒按钮
- (void)tenSecBtnDidClick:(UIButton *)sender {
    _cameraDropView.userInteractionEnabled = NO;
    UIView *view = sender.superview;
    
    for (id obj in sender.superview.subviews) {
        [obj removeFromSuperview];
    }
    
    _second = 10;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"10";
    if (kIsIpad) {
        lab.font = [UIFont boldSystemFontOfSize:26];
        lab.frame = CGRectMake(25, 0, kWidth * 0.5 - 111.5 - 50 - 50, 45);
    }
    else {
        lab.font = [UIFont boldSystemFontOfSize:23];
        lab.frame = CGRectMake(15, 0, kWidth * 0.5 - 74 - 30 - 30, 30);
    }
    
    lab.textColor = kWhiteColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tenSecTimerAction:) userInfo:lab repeats:YES];
    [self.countDownTimer fire];
    
}

#pragma mark -十秒倒计时器
- (void)tenSecTimerAction:(NSTimer *)timer {
    
    UILabel *lab = timer.userInfo;
    
    if (_second >= 0) {
        lab.text = [NSString stringWithFormat:@"%ld",_second];
        _second--;
        return;
    }
    [lab.superview removeFromSuperview];
    [self.cameraDropView removeFromSuperview];
    _cameraDropView = nil;
    _cameraDropChildView = nil;
    self.camaraBtn.selected = NO;
    [timer invalidate];
    timer = nil;
#warning 在这里做倒计时完成后的命令操作
    
    //飞机拍照
    SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
    NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@1,@"delay":@10}};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [tcpManager sendData:data Response:^(NSData *responseData) {
        
    } Tag:0];
    [self takePhotoFlashScreenWithImage:self.currentImage];
    _h264Decoder.takePhotosNum = 1;
}

- (void)continuousBtnDidClick:(UIButton *)sender {
    for (id obj in sender.superview.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = obj;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    if (_cameraDropChildView == nil) {
        if (kIsIpad) {
            _cameraDropChildView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 111.5 - 50)/2, 120, kWidth * 0.5 - 111.5 - 50, 45)];
        }
        else {
            _cameraDropChildView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(kWidth * 0.5 - (kWidth * 0.5 - 74 - 30)/2, 80, kWidth * 0.5 - 74 - 30, 30)];
        }
        [self.view addSubview:_cameraDropChildView];
    }
    for (id obj in _cameraDropChildView.subviews) {
        [obj removeFromSuperview];
    }
    
    NSArray *arr = @[@"3",@"5",@"10",@"15"];
    if (kIsIpad) {
        CGFloat w = (kWidth * 0.5 - 111.5 - 50 - 50) / arr.count;
        
        for (NSInteger i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 100;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(25 + w*i, 0, w, 45);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:26];
            [btn addTarget:self action:@selector(continousBtnChoiceHandle:) forControlEvents:UIControlEventTouchUpInside];
            [_cameraDropChildView addSubview:btn];
        }
    }
    else {
        CGFloat w = (kWidth * 0.5 - 74 - 30 - 30) / arr.count;
        
        for (NSInteger i = 0; i < arr.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i + 100;
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            btn.frame = CGRectMake(15 + w*i, 0, w, 30);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:23];
            [btn addTarget:self action:@selector(continousBtnChoiceHandle:) forControlEvents:UIControlEventTouchUpInside];
            [_cameraDropChildView addSubview:btn];
        }
    }
    
}

- (void)continousBtnChoiceHandle:(UIButton *)sender {
    
    //如果此时还有未保存完成的图片，则直接退出
    if (_h264Decoder.takePhotosNum) {
        return;
    }
    [self.cameraDropView removeFromSuperview];
    _cameraDropView = nil;
    [self.cameraDropChildView removeFromSuperview];
    _cameraDropChildView = nil;
    self.camaraBtn.selected = NO;
    
    NSInteger index = sender.tag - 100;
    switch (index) {
            
        case 0:
        {
            self.expectedPhotoCount = 1;
            
            //飞机连拍
            SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
            
            NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@(self.expectedPhotoCount + 2),@"delay":@0}};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [tcpManager sendData:data Response:^(NSData *responseData) {
                
            } Tag:0];
            //连拍期间不能访问相册，拍完后恢复
            self.gelleryBtn.userInteractionEnabled = NO;
            [self takePhotoFlashScreenWithImage:self.currentImage];
            _h264Decoder.takePhotosNum = 3;
        }
            break;
        case 1:
        {
            self.expectedPhotoCount = 3;
            
            //飞机连拍
            SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
            NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@(self.expectedPhotoCount + 2),@"delay":@0}};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [tcpManager sendData:data Response:^(NSData *responseData) {
                
            } Tag:0];
            //连拍期间不能访问相册，拍完后恢复
            self.gelleryBtn.userInteractionEnabled = NO;
            [self takePhotoFlashScreenWithImage:self.currentImage];
            _h264Decoder.takePhotosNum = 5;
            
        }
            break;
        case 2:
        {
            self.expectedPhotoCount = 8;
            
            //飞机连拍
            SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
            NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@(self.expectedPhotoCount + 2),@"delay":@0}};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [tcpManager sendData:data Response:^(NSData *responseData) {
                
            } Tag:0];
            //连拍期间不能访问相册，拍完后恢复
            self.gelleryBtn.userInteractionEnabled = NO;
            [self takePhotoFlashScreenWithImage:self.currentImage];
            
            _h264Decoder.takePhotosNum = 10;
        }
            break;
        case 3:
        {
            self.expectedPhotoCount = 13;
            
            //飞机连拍
            SEQ_CMD cmd = CMD_REQ_VID_ENC_CAPTURE;
            NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":@{@"num":@(self.expectedPhotoCount + 2),@"delay":@0}};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            [tcpManager sendData:data Response:^(NSData *responseData) {
                
            } Tag:0];
            //连拍期间不能访问相册，拍完后恢复
            self.gelleryBtn.userInteractionEnabled = NO;
            [self takePhotoFlashScreenWithImage:self.currentImage];
            
            _h264Decoder.takePhotosNum = 15;
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -移除拍照长按的下拉框
- (void)removeCameraDropView {
    [self.cameraDropView removeFromSuperview];
    _cameraDropView = nil;
    [self.cameraDropChildView removeFromSuperview];
    _cameraDropChildView = nil;
    self.camaraBtn.selected = NO;
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

#pragma mark - 录像按钮的懒加载及相应方法

//录像按钮
- (UIButton *)liveBtn {
    if (_liveBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"Recording-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Recording-clike-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"Recording"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Recording-clike"] forState:UIControlStateSelected];
        }
        
        btn.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [btn addTarget:self action:@selector(liveBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _liveBtn = btn;
    }
    return _liveBtn;
}

- (void)liveBtnClickAction:(UIButton *)sender {
    
    if (!_rtspState)//未连接图传，直接退出
    {
        return;
    }
    
     uint8_t electric = [[[NSUserDefaults standardUserDefaults] objectForKey:ELECTRIC_NUM] integerValue];
    
    if (electric < CAPACITY_LOW_FOR_RECORD) {
        
        //电量低于百分之十禁止录像
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"The electricity is Less than 10%  to record", @"电量低于10%，请不要进行录像") delegate:self
                                               cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
        [alert show];
        return;
    }
    
    sender.exclusiveTouch = YES;
    sender.selected = !sender.selected;
    if (sender.selected) {
//            ------------------------     UI效果代码       ---------------------------
        [self circleDropViewbuttonClickAction:nil];
        [self removeCameraDropView];
        for (id obj in self.view.subviews) {
            if ([obj isKindOfClass:[ZWHSettingIndicatorView class]]) {
                [obj removeFromSuperview];
            }
        }
        if (kIsIpad) {
            _liveDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(0, 75, kWidth * 0.5 - 111.5, 100)];
        }
        else {
            _liveDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(0, 50, kWidth * 0.5 - 74, 75)];
        }
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:ImageNamed(@"stop_42x42") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(liveDropViewbuttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_liveDropView addSubview:btn];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [_liveDropView addSubview:imageView];
        
        _recordingImgView = imageView;
        
        _second = 0;
        _minute = 0;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"00:00";
        lab.textColor = kWhiteColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [_liveDropView addSubview:lab];
        
        if (kIsIpad) {
            btn.frame = CGRectMake((kWidth * 0.5 - 111.5)*0.5 - 22.5, 45, 55, 55);
            imageView.image = ImageNamed(@"Small-ipad");
            imageView.frame = CGRectMake((kWidth*0.5 - 111.5)*0.5 - 40, 14.5, 16, 16);
            lab.frame = CGRectMake((kWidth*0.5 - 111.5)*0.5 - 18, 0, 60, 45);
            lab.font = FontSize(17);
        }
        else {
            btn.frame = CGRectMake((kWidth * 0.5 - 74)*0.5 - 15, 35, 30, 30);
            imageView.image = ImageNamed(@"videorecording_9x9");
            imageView.frame = CGRectMake((kWidth*0.5 - 74)*0.5 - 28, 10.5, 9, 9);
            lab.frame = CGRectMake((kWidth*0.5 - 74)*0.5 - 20, 0, 50, 30);
            lab.font = FontSize(13);
        }
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimerAction:) userInfo:lab repeats:YES];
        [self.countDownTimer fire];
        [self.view addSubview:_liveDropView];
        
        [self startRecord];
        
    }
    
    else {
        [self tapGesClickAction];
    }
    
}

- (void)countTimerAction:(NSTimer *)timer {
    
    UILabel *lab = timer.userInfo;
    
    _recordingImgView.hidden = !_recordingImgView.hidden;
    
    if (_second == 60) {
        _minute++;
        _second = 0;
        
    }
    lab.text = [NSString stringWithFormat:@"%02ld:%02ld",(long)_minute,(long)_second];
    _second++;
    
    //分享时长小于等于30秒关闭录制
    if (_second>30 && (_share1Btn.selected || _share2Btn.selected))
    {
        //关闭录制并更新UI
        if (_liveBtn.selected)
        {
            [self liveDropViewbuttonClickAction:nil];
        }
        else if (_circleBtn.selected)
        {
            [self circleDropViewbuttonClickAction:nil];
        }
    }
    
}

- (void)liveDropViewbuttonClickAction:(UIButton *)sender {
    
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    [_liveDropView removeFromSuperview];
    _liveDropView = nil;
    self.liveBtn.selected = NO;
    
    [self closeRecord];
    
}


#pragma mark - 360按钮的懒加载及相应方法
//360按钮
- (UIButton *)circleBtn {
    if (_circleBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"surround-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"surround-clike-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"surround"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"surround-clike"] forState:UIControlStateHighlighted];
        }
        
        [btn addTarget:self action:@selector(circleBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _circleBtn = btn;
    }
    return _circleBtn;
}
- (void)circleBtnClickAction:(UIButton *)sender {
    
     NSInteger  FlyModel = [[[NSUserDefaults standardUserDefaults] objectForKey:FLY_MODE_STATUS] integerValue];
    
    if (!_rtspState || FlyModel != BASE_INFO_FLY_MODEL_TYPE_SKY)//未连接图传，直接退出
    {
        return;
    }
    
    [self liveDropViewbuttonClickAction:nil];
    [self removeCameraDropView];
    for (id obj in self.view.subviews) {
        if ([obj isKindOfClass:[ZWHSettingIndicatorView class]]) {
            [obj removeFromSuperview];
        }
    }
    
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (kIsIpad) {
            _circleDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(0, 75, kWidth * 0.5 - 111.5, 100)];
        }
        else {
            _circleDropView = [[ZWHSettingIndicatorView alloc] initWithFrame:CGRectMake(0, 50, kWidth * 0.5 - 74, 75)];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:ImageNamed(@"stop_42x42") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(circleDropViewbuttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_circleDropView addSubview:btn];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [_circleDropView addSubview:imageView];
        
        _recordingImgView = imageView;
        
        _second = 0;
        _minute = 0;
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"00:00";
        lab.textColor = kWhiteColor;
        lab.textAlignment = NSTextAlignmentCenter;
        [_circleDropView addSubview:lab];
        
        if (kIsIpad) {
            btn.frame = CGRectMake((kWidth * 0.5 - 111.5)*0.5 - 22.5, 45, 55, 55);
            imageView.image = ImageNamed(@"Small-ipad");
            imageView.frame = CGRectMake((kWidth*0.5 - 111.5)*0.5 - 40, 14.5, 16, 16);
            lab.frame = CGRectMake((kWidth*0.5 - 111.5)*0.5 - 18, 0, 60, 45);
            lab.font = FontSize(17);
        }
        else {
            btn.frame = CGRectMake((kWidth * 0.5 - 74)*0.5 - 15, 35, 30, 30);
            imageView.image = ImageNamed(@"videorecording_9x9");
            imageView.frame = CGRectMake((kWidth*0.5 - 74)*0.5 - 28, 10.5, 9, 9);
            lab.frame = CGRectMake((kWidth*0.5 - 74)*0.5 - 20, 0, 50, 30);
            lab.font = FontSize(13);
        }
        
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countTimerAction:) userInfo:lab repeats:YES];
        [self.countDownTimer fire];
        [self.view addSubview:_circleDropView];
        
        [self startRecord];
    }
    
    else {
        [self tapGesClickAction];
    }
    
    if (self.flyControlManager) {
        
        [_flyControlManager.controller circle360_action:sender.selected];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice360 object:nil];
    }
}
- (void)circleDropViewbuttonClickAction:(UIButton *)sender {
    
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    [self closeRecord];
    [_circleDropView removeFromSuperview];
    _circleDropView = nil;
    self.circleBtn.selected = NO;
    [_flyControlManager.controller circle360_action:sender.selected];
}

#pragma mark - 零偏校准功能按钮的懒加载及相应方法
- (UIButton *)topBtn {

    if (_topBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (kIsIpad) {
            btn.frame = CGRectMake(350, 0, 86, 175);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-top-ipad"] forState:UIControlStateNormal];
        }
        else {
            CGFloat centYMainCtrView = 0.75*kHeight - 90 - 52;
            btn.frame = CGRectMake(kHeight - 90 - 52, centYMainCtrView-80, 52, 80);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-top"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(topBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCtrStickView addSubview:btn];
        _topBtn = btn;
    }
    return _topBtn;
}
- (void)topBtnClickAction:(UIButton *)sender {
    
    if (self.flyControlManager) {
        _flyControlManager.controller.shengjianglingpian += 0.1;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_lingPian object:nil];
        [self syncLocalCache:YES];
        NSLog(@"shengjianglingpian:%f",_flyControlManager.controller.shengjianglingpian);
    }
}
- (UIButton *)bottomBtn {
    
    if (_bottomBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(350, 175, 86, 175);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-bottom-ipad"] forState:UIControlStateNormal];
        }
        else {
            CGFloat centYMainCtrView = 0.75*kHeight - 90 - 52;
            btn.frame = CGRectMake(kHeight - 90 - 52, centYMainCtrView, 52, 80);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-bottom"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(bottomBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCtrStickView addSubview:btn];
        _bottomBtn = btn;
    }
    return _bottomBtn;
}
- (void)bottomBtnClickAction:(UIButton *)sender {
    
    if (self.flyControlManager) {
        _flyControlManager.controller.shengjianglingpian -= 0.1;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_lingPian object:nil];
        [self syncLocalCache:YES];
        NSLog(@"shengjianglingpian:%f",_flyControlManager.controller.shengjianglingpian);
    }
}
- (UIButton *)leftBtn {
    
    if (_leftBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(0, 350, 175, 86);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-left-ipad"] forState:UIControlStateNormal];
        }
        else {
            CGFloat centXMainCtrView = 0.75*kHeight - 90 - 52;
            btn.frame = CGRectMake(centXMainCtrView - 80, kHeight - 90 - 52, 80, 52);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-left"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(leftBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCtrStickView addSubview:btn];
        _leftBtn = btn;
    }
    return _leftBtn;
}
- (void)leftBtnClickAction:(UIButton *)sender {
    
    if (self.flyControlManager) {
        _flyControlManager.controller.fuyilingpian -= 0.1;
        //发送lingpian控制命令
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_lingPian object:nil];
        [self syncLocalCache:NO];
        NSLog(@"fuyilingpian:%f",_flyControlManager.controller.fuyilingpian);
    }
}
- (UIButton *)rightBtn {
    
    if (_rightBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(175, 350, 175, 86);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-right-ipad"] forState:UIControlStateNormal];
        }
        else {
            CGFloat centXMainCtrView = 0.75*kHeight - 90 - 52;
            btn.frame = CGRectMake(centXMainCtrView, kHeight - 90 - 52, 80, 52);
            [btn setImage:[UIImage imageNamed:@"Zero-offset-calibration-right"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(rightBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainCtrStickView addSubview:btn];
        _rightBtn = btn;
    }
    return _rightBtn;
}
- (void)rightBtnClickAction:(UIButton *)sender {
    
    if (self.flyControlManager) {
        _flyControlManager.controller.fuyilingpian += 0.1;
        //发送lingpian控制命令
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_lingPian object:nil];
        [self syncLocalCache:NO];
        NSLog(@"fuyilingpian:%f",_flyControlManager.controller.fuyilingpian);
    }
}
-(void)syncLocalCache:(BOOL)index
{
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if (index) {
            [userDefaults setObject:[NSNumber numberWithInt:_flyControlManager.controller.shengjianglingpian] forKey:@"shengjianglingpian"];
        }
        else
        {
            [userDefaults setObject:[NSNumber numberWithInt:_flyControlManager.controller.fuyilingpian] forKey:@"fuyilingpian"];
        }
    });
}

#pragma mark - 其他功能按钮的懒加载及相应方法
//紧急降落按钮
- (UIButton *)emergercyBtn {
    if (_emergercyBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"ipad-Emergency"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"Emergency"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(emergercyBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _emergercyBtn = btn;
    }
    return _emergercyBtn;
}
- (void)emergercyBtnClickAction:(UIButton *)sender {
    
    //当锁上的时候移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    //移除通知时候
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];


    [self getStates:NO];
    self.lock.hidden = NO;
    self.lock.selected = NO;
    if (kIsIpad) {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-ash-ipad"] forState:UIControlStateNormal];
    }
    else {
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
    }
    
    self.takeOffOrLandingBtn.selected = NO;
    
    _isClick = NO;

    if (self.flyControlManager) {
        [_flyControlManager.controller emergency_action];
    }
}

#pragma mark-快捷分享1
- (UIButton *)share1Btn {
    
    if (_share1Btn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"Share-1-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Share-1-clike-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"Share-1"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Share-1select"] forState:UIControlStateSelected];
        }
        
        [btn addTarget:self action:@selector(share1BtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _share1Btn = btn;
    }
    return _share1Btn;
}
- (void)share1BtnClickAction:(UIButton *)sender {
    
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"Temporarily unsupported", @"暂不支持") delegate:self
                                           cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
    [alert show];
    return;

    
    if (self.share2Btn.selected || !frameCount) {
        return;
    }
    sender.selected = !sender.selected;
    [self tapGesClickAction];
    
    if (sender.selected) {
        [kUserDefaults setObject:nil forKey:kShareCaption];
        [kUserDefaults synchronize];
        NSInteger index = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
        NSString *title;
        switch (index) {
            case ZWHSharePlatformFacebook:
                title = @"Facebook";
                break;
            case ZWHSharePlatformTwitter:
                title = @"Twitter";
                break;
            case ZWHSharePlatformGoolePlus:
                title = nil;
                break;
            case ZWHSharePlatformYoutube:
                title = @"Youtube";
                break;
                
            default:
                break;
        }
        NSInteger index1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
        switch (index1) {
            case ZWHShareCaptionModeBefore:
            {
                if (index == ZWHSharePlatformGoolePlus) {
                    break;
                }
                ZWHCaptionView *view = [ZWHCaptionView viewWithPlatformTitle:title image:nil cancelCallBack:^{
                    
                } issueCallBack:^(NSString *description) {
                    [kUserDefaults setObject:description forKey:kShareCaption];
                    [kUserDefaults synchronize];
                }];
                [self.view addSubview:view];
            }
                
                break;
                
            default:
                break;
        }
        [[ZWHShareManager sharedZWHShareManager] shareImageForOneWithImageArr:nil];
        //分享图片
        [_h264Decoder startShareAndCollectImageDataWithBlock:^(NSArray<UIImage *> *arrImg) {
            [[ZWHShareManager sharedZWHShareManager] shareImageForOneWithImageArr:arrImg];
        }];
        
        //分享视频
        [_mp4Helper startShareVideoAndCallBackWithBlock:^(NSString *filepath) {
            [[ZWHShareManager sharedZWHShareManager] shareVideoForOneWithFilePath:filepath thubImage:[self currentImage]];
        }];
        
        return;
    }
    //关闭分享图片
    [_h264Decoder closeShare];
    //关闭分享视频
    [_mp4Helper closeShareVideo];
}

#pragma mark-快捷分享2
- (UIButton *)share2Btn {
    if (_share2Btn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"Share-2-ipad"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"Share-2-clike-ipad"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(share2BtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _share2Btn = btn;
    }
    return _share2Btn;
}
- (void)share2BtnClickAction:(UIButton *)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"Temporarily unsupported", @"暂不支持") delegate:self
                                           cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
    [alert show];
    return;

    if (self.share1Btn.selected || !frameCount) {
        return;
    }
    
    sender.selected = !sender.selected;
    [self tapGesClickAction];
    
    if (sender.selected) {
        [kUserDefaults setObject:nil forKey:kShareCaption];
        [kUserDefaults synchronize];
        NSInteger index = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
        NSString *title;
        switch (index) {
            case ZWHSharePlatformFacebook:
                title = @"Facebook";
                break;
            case ZWHSharePlatformTwitter:
                title = @"Twitter";
                break;
            case ZWHSharePlatformGoolePlus:
                title = nil;
                break;
            case ZWHSharePlatformYoutube:
                title = @"Youtube";
                break;
                
            default:
                break;
        }
        NSInteger index1 = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0x0f;
        switch (index1) {
            case ZWHShareCaptionModeBefore:
            {
                if (index == ZWHSharePlatformGoolePlus) {
                    break;
                }
                ZWHCaptionView *view = [ZWHCaptionView viewWithPlatformTitle:title image:nil cancelCallBack:^{
                    
                } issueCallBack:^(NSString *description) {
                    [kUserDefaults setObject:description forKey:kShareCaption];
                    [kUserDefaults synchronize];
                }];
                [self.view addSubview:view];
            }
                
                break;
                
            default:
                break;
        }
        
        [[ZWHShareManager sharedZWHShareManager] shareImageForTwoWithImageArr:nil];
        //分享图片
        [_h264Decoder startShareAndCollectImageDataWithBlock:^(NSArray<UIImage *> *arrImg) {
            [[ZWHShareManager sharedZWHShareManager] shareImageForTwoWithImageArr:arrImg];
        }];
        
        //分享视频
        [_mp4Helper startShareVideoAndCallBackWithBlock:^(NSString *filepath) {
            [[ZWHShareManager sharedZWHShareManager] shareVideoForTwoWithFilePath:filepath thubImage:[self currentImage]];
        }];
        return;
    }
    //关闭分享
    [_h264Decoder closeShare];
    [_mp4Helper closeShareVideo];
}

#pragma mark -闪光灯按钮
- (ZWHFlashLedButton *)lightBtn {
    if (_lightBtn == nil) {
        ZWHFlashLedButton *btn = [[ZWHFlashLedButton alloc] init];
        btn.block = ^(ZWHFlashLedButtonState state){
           
            SEQ_CMD cmd = CMD_REQ_LED_IND_SET;
            NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":[NSNumber numberWithInt:state]};
            switch (state) {
                case 0:
                {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                    [tcpManager sendData:data Response:^(NSData *responseData) {
                        
                    } Tag:0];
                }
                    break;
                    
                case 1:
                {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                    [tcpManager sendData:data Response:^(NSData *responseData) {
                        
                    } Tag:0];
                }
                    
                    break;
                    
                case 2:
                {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                    [tcpManager sendData:data Response:^(NSData *responseData) {
                        
                    } Tag:0];
                }
                    break;
                    
                default:
                    break;
            }
        };
        
        [self.topBarView addSubview:btn];
        
        _lightBtn = btn;
    }
    return _lightBtn;
}

#pragma mark -follow me
- (UIButton *)followBtn {
    
    if (_followBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"logo-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"follow-me-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"follow-me"] forState:UIControlStateSelected];
        }
        
        [btn addTarget:self action:@selector(followBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        
        _followBtn = btn;
    }
    return _followBtn;
}
- (void)followBtnClickAction:(UIButton *)sender {
    
    if (![self.flyControlManager.response getFlyingState])//未连接图传，直接退出
    {
        return;
    }
    sender.selected = !sender.selected;
    if (self.flyControlManager) {
        [_flyControlManager.controller followMe_action:sender.selected];
    }
}

#pragma mark -设置按钮
- (UIButton *)settingBtn {
    if (_settingBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"Set-up-ipad"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"Set-up"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(ParamsSet:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        
        _settingBtn = btn;
    }
    return _settingBtn;
}

#pragma mark -参数设置
-(void)ParamsSet:(UIButton*)btn {
    
    ParaSetViewController *vc = [[ParaSetViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -相册按钮
- (UIButton *)gelleryBtn {
    if (_gelleryBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"album-ipad"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(gelleryBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBarView addSubview:btn];
        
        _gelleryBtn = btn;
    }
    return _gelleryBtn;
}
- (void)gelleryBtnClickAction:(UIButton *)sender {
    
    ZWHGalleryViewController *vc = [[ZWHGalleryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -一键降落一键起飞按钮
- (UIButton *)takeOffOrLandingBtn {
    if (_takeOffOrLandingBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"takeoff-ash-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"landing-"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"landing"] forState:UIControlStateSelected];
        }
        
        
        [btn addTarget:self action:@selector(takeOffOrLandingBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bottomBarView addSubview:btn];
        
        _takeOffOrLandingBtn = btn;
    }
    
    return _takeOffOrLandingBtn;
}
- (void)takeOffOrLandingBtnClickAction:(UIButton *)sender {
    
    if (![self.flyControlManager isConnected]) {//udp是否连接上
        return;
    }
//    else if (![self.flyControlManager.location isValidate]){
//        UIAlertView *alert;
//        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"please go to the Settings in the access to open the GPS before take-off", @"请到设置中打开GPS使用权限之后再进行起飞操作") delegate:nil
//                                 cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
//        [alert show];
//        return;
//    }
    _isClick = YES;//只要操作了这个按钮就会有值，用以开锁5秒后不操作自动关闭
    
       UIAlertView *alert;
    uint8_t electric = [[[NSUserDefaults standardUserDefaults] objectForKey:ELECTRIC_NUM] integerValue];
    
    if (electric > CAPACITY_LOW_FOR_FLY) {
        
            if (!sender.selected) {
                
                //一键起飞之前做判断
              boolean_t flyModel =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"flyModel"] boolValue];
                if (flyModel) { //定高模式起飞
                    if (self.flyControlManager){
                        [_flyControlManager.controller takeoffAction];//定高模式
                    }
                }else //定点模式
                {
                    //判断gps 光流
                    uint8_t gps =  self.flyControlManager.response.senseStatusModel.gps;
                    uint8_t flow = self.flyControlManager.response.senseStatusModel.flow;
                    if (gps == 5 && flow == 5) { //未配备
                        if (self.flyControlManager){
                            [_flyControlManager.controller takeoffAction];//定高模式
                        }
                    }else
                    {
                        if ((gps == 1 && flow == 1) || (gps == 5 && flow == 1) || (gps == 1 && flow == 5)) {//异常
                            //弹框提示
                            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"Fixed point pattern exception", @"定点模式异常") delegate:self
                                                     cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
                            [alert show];
                            
                             [_flyControlManager.controller takeoffAction];//定高模式
                            
                        }else //非异常
                        {
                             [_flyControlManager.controller takeoffAction];//定点模式
                        }
                    }
                    
                }
                
            }
            else
            {
                if (self.flyControlManager){
                    [_flyControlManager.controller landAction];//降落
                    _isClick = NO;
                    self.lock.hidden = NO;
                    self.lock.selected = NO;
                    [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
                    self.takeOffOrLandingBtn.selected = NO;
                    [self getStates:NO];
                }
            }
            
        }else{
          alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"The electricity is not enough to fly", @"电量低于10%，不能起飞") delegate:self
                                 cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
         alert.tag = 11;
         objc_setAssociatedObject(alert, &kAlertKey, @(alert.tag) , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
         [alert show];
    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = [objc_getAssociatedObject(alertView, &kAlertKey) integerValue];
    
    if (tag == 10) {
        
        if (buttonIndex == 1) {
            
            if (self.flyControlManager) {
                [_flyControlManager.controller takeoffAction];
                _flyControlManager.controller.flyModel = YES;
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"flyModel"];
            }
        }
        else if (buttonIndex == 0) {
            
            [self lockTakeoffBtn];
        }

    }else if(tag == 11)
    {
        [self lockTakeoffBtn];
    }
    
    
}

#pragma mark -锁住takeoff按钮
-(void)lockTakeoffBtn
{
    _isClick = NO;
    self.lock.hidden = NO;
    self.lock.selected = NO;
    [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
    //self.takeOffOrLandingBtn.selected = NO;
    [self getStates:NO];
}

#pragma mark -锁定键
- (ZWHLockButton *)lock {
    if (_lock == nil) {
        ZWHLockButton *btn = [ZWHLockButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"lock-ipad"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Unlock-ipad"] forState:UIControlStateSelected];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"lock"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"Unlock"] forState:UIControlStateSelected];
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lockBtnLongPressAction:)];
        longPress.minimumPressDuration = 1;
        [btn addGestureRecognizer:longPress];
        [self.view addSubview:btn];
        
        _lock = btn;
    }
    return _lock;
}
- (void)lockBtnLongPressAction:(UILongPressGestureRecognizer *)ges {
    
    
    if (!self.takeOffOrLandingBtn.userInteractionEnabled) {
        self.lock.selected = YES;
        [self.lock addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
        if (kIsIpad) {
            [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-green-ipad"] forState:UIControlStateNormal];
        }
        else {
            [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-green"] forState:UIControlStateNormal];
        }
        
        [self initAudioSession];
        [self getStates:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!_isClick) {
                    
                    [self getStates:NO];
                    if (kIsIpad) {
                        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"takeoff-ash-ipad"] forState:UIControlStateNormal];
                    }
                    else {
                        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
                    }
                    
                    self.takeOffOrLandingBtn.selected = NO;
                    self.lock.selected = NO;
                }
                _isClick = NO;
                [self.lock removeObserver:self forKeyPath:@"selected"];
            });
        });
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"selected"])
    {
        if (change[@"new"]) {
            _isClick = YES;
        }
    }
}


#pragma mark - 获取当前音量
//获取当前音量
-(void)initAudioSession {

    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
   
}
- (void)volumeChanged:(NSNotification *)notification
{
    float volume = [[AVAudioSession sharedInstance] outputVolume]+kVolume;
    if ([notification.userInfo[@"AVSystemController_AudioVolumeNotificationParameter"] floatValue]<volume&&volume<=1) {
        
        if (self.flyControlManager) {
            [_flyControlManager.controller reserveBitControl];
        }
    }
}

#pragma mark - tcp delegate
-(void)connectFailed
{
    UIImageView *imgV = (UIImageView *)self.view;
    imgV.image = [UIImage imageNamed:@"bg"];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}

-(void)connectSuccess
{
    [self catchCameraBaseInfo];
    [UIApplication sharedApplication].idleTimerDisabled=YES;//禁止自动休眠
}

-(void)SDCardReport:(id)obj
{
    if (![obj isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *resultDic = (NSDictionary *)obj;
    if ([[resultDic objectForKey:@"REPORT"] intValue] == 0) {
        
        int state = [[[resultDic objectForKey:@"PARAM"] objectForKey:@"online"] intValue];
        NSDictionary *dataDic = [resultDic objectForKey:@"PARAM"];
        if (state == 0) {
            //卡拔出
            [[CameraSyncSetting cameraSetting].cardCapcity setObject:[NSNumber numberWithInt:0] forKey:@"online"];
            [[CameraSyncSetting cameraSetting].cardCapcity setObject:[NSNumber numberWithInt:0] forKey:@"freeSpace"];
            [[CameraSyncSetting cameraSetting].cardCapcity setObject:[NSNumber numberWithInt:0] forKey:@"usedSpace"];
            [[CameraSyncSetting cameraSetting].cardCapcity setObject:[NSNumber numberWithInt:0] forKey:@"totalSpace"];
            
            [self.SDcard setMemoQuantity:0 Out:state];
        }
        else if (state == 1) {
            
            //卡插入
            CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
            camera.cardCapcity = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
            float freeSpace = [camera.cardCapcity[@"freeSpace"] floatValue];
            float totalSpace = [camera.cardCapcity[@"totalSpace"] floatValue];
            [self.SDcard setMemoQuantity:ceil(freeSpace / totalSpace * 100) Out:state];
        }
    }
    else if ([[resultDic objectForKey:@"REPORT"] intValue] == 1){
    
        int state = [[[resultDic objectForKey:@"PARAM"] objectForKey:@"charge"] intValue];
        
        //0代表未充电 1代表充电中
        if (state == 1) {
            self.batteryView.elecQuantity = -1;
            CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
            camera.isCharging = YES;
        }
        else{
        
            self.batteryView.elecQuantity = 0;
            CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
            camera.isCharging = NO;
        }
    }
}

#pragma mark -获取相机基础信息
-(void)catchCameraBaseInfo
{
    SEQ_CMD cmd;
    cmd = CMD_REQ_WIFI_DISPATCHER_SYS_PARAM_GET;
    NSDictionary *dict = @{@"CMD":[NSNumber numberWithInt:cmd], @"PARAM":[NSNumber numberWithInt:-1]};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [tcpManager sendData:data Response:^(NSData *responseData){
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
        if ([[resultDic objectForKey:@"CMD"] intValue] == 0) {
            [camera sync:[resultDic objectForKey:@"PARAM"]];
        }
        
        //flash灯状态更新
        [self updateFlashLED:camera.flash_state];
        
        //卡状态显示更新
        if ([[camera.cardCapcity objectForKey:@"online"] floatValue] == 0) {
            [self.SDcard setMemoQuantity:0 Out:0];
        }
        else
        {
            float freeSpace = [camera.cardCapcity[@"freeSpace"] floatValue];
            float totalSpace = [camera.cardCapcity[@"totalSpace"] floatValue];
            [self.SDcard setMemoQuantity:ceil(freeSpace / totalSpace * 100) Out:1];
        }
        if (camera.isCharging) {
            self.batteryView.elecQuantity = -1;
        }
        else{
        
            self.batteryView.elecQuantity = 0;
        }
        
        //检测固件版本
        static int rtsp_tag = 0;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self checkVersion];
        });
        
        //连接图传
        if (rtsp_tag > 0) {
            
            [self connectRtsp];
        }
        rtsp_tag++;
        
    } Tag:0];
}
//同步时间
-(void)syncSysTime
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    int hour = (int) [dateComponent hour];
    int minute = (int) [dateComponent minute];
    int second = (int) [dateComponent second];
    NSDictionary *param = @{@"YEAR":[NSNumber numberWithInt:year],@"MONTH":[NSNumber numberWithInt:month],@"DAY":[NSNumber numberWithInt:day],@"HOUR":[NSNumber numberWithInt:hour],@"MINUTE":[NSNumber numberWithInt:minute],@"SECOND":[NSNumber numberWithInt:second]};
    NSDictionary *sendParam = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:CMD_REQ_DATE_TIME_SET],@"CMD",param,@"PARAM", nil];

    [tcpManager sendData:[NSJSONSerialization dataWithJSONObject:sendParam options:NSJSONWritingPrettyPrinted error:nil] Response:^(NSData *responseData){
   
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if ([[resultDic objectForKey:@"RESULT"] intValue] == 0) {
            //设置成功
        }
    } Tag:0];
}

#pragma mark - 升级固件版本
-(void)checkVersion {
    CameraSyncSetting *camera = [CameraSyncSetting cameraSetting];
    NSString *droneFirmware = camera.version;
    if (!droneFirmware) {
        NSLog(@"无法获取到版本信息");
        return;
    }
    NSString *localFirmware = [[kFirmwarePath lastPathComponent] stringByDeletingPathExtension];
    if (localFirmware!=nil && [localFirmware compare:droneFirmware]==NSOrderedDescending)//飞机固件版本过低，提示用户升级
    {
        //弹框提示用户升级
        NSLog(@"提示用户升级固件");
        [self upgrateFirmware];
    }
    else [self connectRtsp];
}

- (BOOL)upgrateFirmware
{
    //传输文件和升级过程中要用到的alertView
    __block UIAlertView *alert = nil;
    
    self.upgrateController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Uavs found new firmware version, update now?",@"发现无人机固件新版本，现在要更新吗？") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.upgratedFirmware = NO;
    }];
    UIAlertAction *upgrate = [UIAlertAction actionWithTitle:NSLocalizedString(@"Update",@"更新") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.upgratedFirmware = YES;
        
        alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"Is updating, please don't close drones and APP...",@"正在更新中，请不要关闭无人机和APP...") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert show];
        
        if (!manager) {
            manager = [[FTPManager alloc]init];
        }
        
        __weak typeof(TcpManager *)tcp = tcpManager;
        
        manager.resultBlock = ^(BOOL result){
            if (result == YES)//文件传输完成，发送升级命令
            {
                SEQ_CMD cmd;
                //发送升级命令
                cmd = CMD_REQ_WIFI_DISPATCHER_FIRMWARE_UPDATE;
                NSString *localFirmware = [[kFirmwarePath lastPathComponent] stringByDeletingPathExtension];
                NSDictionary *dict = @{@"CMD":@(cmd), @"PARAM":localFirmware};
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                [tcp sendData:data Response:^(NSData *responseData) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                    if ([dict[@"RESULT"] isEqual:@0])
                    {
                        alert.message = NSLocalizedString(@"The update is successful",@"更新成功");
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alert dismissWithClickedButtonIndex:0 animated:YES];
                        });
                    }
                } Tag:0];
            }
            else//文件传输失败
            {
                alert.message = NSLocalizedString(@"Update failed, please try again later",@"更新失败，请稍后再试");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissWithClickedButtonIndex:0 animated:YES];
                });
            }
        };
        
        NSString *localFirmwarePath =kFirmwarePath;
        [manager startSendFirmware:localFirmwarePath];
        
    }];
    [self.upgrateController addAction:cancel];
    [self.upgrateController addAction:upgrate];
    [self presentViewController:self.upgrateController animated:YES completion:^{
        
    }];
    
    return self.upgratedFirmware;
}

#pragma mark rtsp delegate  解码

-(void)decodeNalu:(uint8_t *)buffer Size:(int)size
{
    uint8_t *temp_data;
    temp_data =(uint8_t *) malloc(size+4);
    uint8_t startCode[] = {0x00, 0x00, 0x00, 0x01};
    memcpy(temp_data, startCode, sizeof(startCode));
    memcpy(temp_data+sizeof(startCode), buffer, size);
    
    if (_mp4Helper) {
        [_mp4Helper doRunloop:temp_data Size:size+4];
    }
    [_h264Decoder decodeNalu:temp_data withSize:size+4];
    
    frameCount ++;
    free(temp_data);
    temp_data = nil;
}

-(void)gotSps:(uint8_t *)sps SpsSize:(int)spsSize Pps:(uint8_t *)pps PpsSize:(int)ppsSize
{
    [_h264Decoder gotSpsPps:sps pps:pps SpsSize:spsSize PpsSize:ppsSize];
    if (!_mp4Helper) {
        _mp4Helper = [[MP4Helper alloc] init];
    }
    
    [_mp4Helper gotSps:sps Pps:pps SpsSize:spsSize PpsSize:ppsSize];
   
}

-(NSString *)dateFormat
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    format.dateFormat = @"YYYYMMddHHmmss";
    NSString *dateStr = [NSString stringWithFormat:@"%@%@",[format stringFromDate:[NSDate date]], @".mp4"];
    return dateStr?dateStr:nil;
}

- (NSDateFormatter *)formatter {
    if (!_formatter)
    {
        _formatter = [[NSDateFormatter alloc]init];
        _formatter.dateFormat = @"YYYYMMddHHmmss";
    }
    return _formatter;
}

-(void)setNewDelegate:(PGQCAEAGLLayer *)newLayer
{
    if (_h264Decoder) {
        _h264Decoder.showLayer = newLayer;
    }
}

-(FlyControlManager *)getFlyManager
{
    if (self.flyControlManager) {
        return _flyControlManager;
    }
    else return nil;
}

#pragma mark - UI视图的懒加载

-(PGQCAEAGLLayer *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[PGQCAEAGLLayer alloc] initWithFrame:kBounds];
        _bgImageView.zPosition = -1;
        _bgImageView.backgroundColor = [[UIColor clearColor] CGColor];
        [self.view.layer addSublayer:_bgImageView];
    }
    return _bgImageView;
}

-(FlyControlManager *)flyControlManager
{
    if (!_flyControlManager) {
        _flyControlManager = [[FlyControlManager alloc] init];
        _flyControlManager.response.deleagte = self;
    }
    
    return _flyControlManager;
}

//调试信息
-(ZWDebugInfoView *)debugInfoView
{
    if (!_debugInfoView) {
        _debugInfoView = [ZWDebugInfoView creatDebugInfoView];
        _debugInfoView.backgroundColor = kRGBAColorFloat(0.3, 0.3, 0.3, 0.3);
        _debugInfoView.hidden = YES;
        [self.view addSubview:_debugInfoView];
    }
    return _debugInfoView;
}


//上部工具栏
- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kRGBAColorFloat(0.3, 0.3, 0.3, 0.3);
        [self.view addSubview:view];
        _topBarView = view;
    }
    return _topBarView;
}

//下部工具栏
- (UIView *)bottomBarView {
    if (_bottomBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kRGBAColorFloat(0.3, 0.3, 0.3, 0.3);
        [self.view addSubview:view];
        _bottomBarView = view;
    }
    return _bottomBarView;
}

#pragma mark -方向控制板视图
- (UIView *)mainCtrStickView {
    if (_mainCtrStickView == nil) {
        
        UIView *viewMain = [[UIView alloc] init];
        viewMain.backgroundColor = kClearColor;
        
        UIView *view = [[UIView alloc] init];
        if (kIsIpad) {
            view.frame = CGRectMake(0, 0, 350, 350);
            view.layer.cornerRadius = 175;
        }
        else {
            view.frame = CGRectMake(kHeight - 90 - 0.5*kHeight - 52, kHeight - 90 - 0.5*kHeight - 52, kHeight * 0.5, kHeight * 0.5);
            view.layer.cornerRadius = kHeight * 0.25;
        }
        _bigCircle = view;
        view.backgroundColor = kRGBAColorFloat(0.3, 0.3, 0.3, 0.3);
        view.layer.masksToBounds = YES;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 3;
        [viewMain addSubview:view];
        [self.view addSubview:viewMain];
        
        _mainCtrStickView = viewMain;
    }
    return _mainCtrStickView;
}

#pragma mark -油门控制视图
- (UIView *)slideView {
    if (_slideView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kClearColor;

        //垂直导轨
        UIView *verticalTrackView = [[UIView alloc] init];
        verticalTrackView.backgroundColor = [UIColor darkGrayColor];
        verticalTrackView.layer.borderColor = [UIColor whiteColor].CGColor;
        if (kIsIpad) {
            verticalTrackView.layer.cornerRadius = 9;
        }
        else {
            verticalTrackView.layer.cornerRadius = 5;
        }
        verticalTrackView.layer.borderWidth = 3;
        
        verticalTrackView.layer.masksToBounds = YES;
        
        [view addSubview:verticalTrackView];
        
        [self.view addSubview:view];
        _slideView = view;
        _trackView = verticalTrackView;
    }
    return _slideView;
}

#pragma mark-卫星视图
- (ZWHSatelliteView *)sateView {
    
    if (_sateView == nil) {
        
        ZWHSatelliteView *view = [[ZWHSatelliteView alloc] init];
        [self.bottomBarView addSubview:view];
        view.badgeLable.text = @"0";
        _sateView = view;
    }
    return _sateView;
}

#pragma mark -电源视图
- (ZWHBatteryView *)batteryView {
    
    if (_batteryView == nil) {
        ZWHBatteryView *view = [[ZWHBatteryView alloc] init];
        view.elecQuantity = 0;
        [self.bottomBarView addSubview:view];
        
        _batteryView = view;
    }
    
    return _batteryView;
}

#pragma mark -内存卡视图
- (ZWHSdView *)SDcard {
    
    if (_SDcard == nil) {
        ZWHSdView *view = [[ZWHSdView alloc] init];
        [view setMemoQuantity:0 Out:0];
        [self.bottomBarView addSubview:view];
        
        _SDcard = view;
    }
    return _SDcard;
}

#pragma mark -wifi图标
- (UIImageView *)wifiImageView {

    if (_wifiImageView == nil) {
        UIImageView *im = [[UIImageView alloc] init];
        im.contentMode = UIViewContentModeCenter;
        if (kIsIpad) {
            im.image = [UIImage imageNamed:@"wifi-gray-ipad"];
        }
        else {
            im.image = [UIImage imageNamed:@"wifi-gray"];
        }
        
        [self.bottomBarView addSubview:im];
        _wifiImageView = im;
    }
    return _wifiImageView;
}

#pragma mark -调试信息定时器

-(dispatch_source_t)debugInfoTimer
{
    if (_debugInfoTimer == nil) {
        
        _debugInfoTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(_debugInfoTimer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_debugInfoTimer, ^{
            
            self.debugInfo.cpuUseRate = [AWTools cpu_usage];//cpu使用率
            self.debugInfo.unUsedMemory = [AWTools availableMemory];//可用内存
            if ([self.flyControlManager isConnected] && self.flyControlManager.response.infoModel) {
                self.debugInfo.flyMode = [NSString flyModelTransform:self.flyControlManager.response.infoModel.flyMode];
            }else
            {
                self.debugInfo.flyMode = @"unKnown";
            }
            
            self.debugInfo.flyHeight = [self.flyControlManager.response.infoModel.pos[2] floatValue];
            self.debugInfo.flyTime = _takeoff_time++;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.debugInfoView.debugInfo = self.debugInfo;

            });
            
            
        });
         dispatch_resume(_debugInfoTimer);
        
    }
    return _debugInfoTimer;
}

#pragma mark-tcp定时器
- (dispatch_source_t)tcpTimer {

    if (_tcpTimer == nil) {
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            
            if ( tcpManager && [tcpManager tcpConnected])
            {
                if (frameCount == 0) {
                    _rtspState = NO;   //1s内没有图片帧数据，则认定rtsp失去连接/网络极差
                }
                else
                {
                    _rtspState = YES;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self updateWifiImg:frameCount];
                    frameCount = 0;
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                   [tcpManager tcpConnect];
                   [self.flyControlManager startUploadData];
                });
                
             }
        });
        _tcpTimer = timer;
    }
    return _tcpTimer;
}

-(void)updateWifiImg:(unsigned int)frameCount
{
    if (kIsIpad) {
        if (frameCount == 0) {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-gray-ipad"];
        }
        else if (0<frameCount && frameCount<=7)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-gules-ipad"];
        }
        else if (7<frameCount && frameCount<=14)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-yellow-ipad"];
        }
        else if (14<frameCount && frameCount<=21)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-green-ipad"];
        }
        else if (21<frameCount)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-ipad"];
        }
    }
    else {
        if (frameCount == 0) {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-gray"];
        }
        else if (0<frameCount && frameCount<=7)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-red"];
        }
        else if (7<frameCount && frameCount<=14)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-yellow"];
        }
        else if (14<frameCount && frameCount<=21)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi-green"];
        }
        else if (21<frameCount)
        {
            self.wifiImageView.image = [UIImage imageNamed:@"wifi"];
        }
    }
}
-(void)updateFlashLED:(FLASH_STATE)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        [self.lightBtn setFlashImgWithState:state];
    });
}

-(BOOL)rtspIsValidate{

    return _rtspState;
}


-(void)emergencyResponse:(int)ret
{
//    NSString *alertMsg;
//    switch (ret) {
//        case 1:
//        {
//            alertMsg = @"飞机温度过高";
//        }
//            break;
//        case 2:
//        {
//            alertMsg = @"电机运转异常";
//        }
//            break;
//        case 3:
//        {
//            alertMsg = @"电量过低";
//        }
//            break;
//            
//        default:
//            break;
//    }
}

static bool roting = false;

#pragma mark -更新信息
-(void)updateUI
{
    self.batteryView.elecQuantity = 0;
    
     NSInteger  FlyModel = [[[NSUserDefaults standardUserDefaults] objectForKey:FLY_MODE_STATUS] integerValue];
    
    if (FlyModel == BASE_INFO_FLY_MODEL_TYPE_SKY) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@(BASE_INFO_FLY_MODEL_TYPE_OVERGROUND) forKey:FLY_MODE_STATUS];
        
        self.takeOffOrLandingBtn.selected = NO;
        self.lock.hidden = NO;//显示锁按钮
        self.lock.selected = NO;
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
        [self getStates:NO];
        
    }
    
}

-(void)updateInfo
{
    
    //电压、gps星数、校准、校准进度
    self.sateView.badgeLable.text = [NSString stringWithFormat:@"%d",self.flyControlManager.response.responseUnion.info.gpsNum];
    
    StatusBaseInfoModel * info = self.flyControlManager.response.infoModel;
    if (info.charge) {
        self.batteryView.elecQuantity = -1;//表示充电中
    }
    
    if (!self.batteryView.isCharging) {
        self.batteryView.elecQuantity = self.flyControlManager.response.infoModel.capacity;
    }
    
     NSInteger  FlyModel = [[[NSUserDefaults standardUserDefaults] objectForKey:FLY_MODE_STATUS] integerValue];
    
    NSInteger electricNum = [[[NSUserDefaults standardUserDefaults] objectForKey:ELECTRIC_NUM] integerValue];
    
    //如果电量小于百分之10,自动禁止录像
    if (electricNum < 10 && _liveBtn.selected) {
        [self tapGesClickAction];//自动停止录像
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"The electricity is Less than 10%  to stop recording automaticly", @"电量低于10%，自动停止录像") delegate:self
                                               cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
        [alert show];
    }
    
    //如果飞行中电量低于10%,弹框提示
    if (electricNum < 10 &&  FlyModel == BASE_INFO_FLY_MODEL_TYPE_SKY) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"less_than_10_of_electricity_automatic_return", @"电量低于10%，自动返航") delegate:self
                                                   cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"确定"), nil];
            [alert show];
        });
    }
    
    NSLog(@"FlyModel:%ld",FlyModel);
    
    //获取飞行状态：天上，地下
    if (self.takeOffOrLandingBtn.selected == NO && FlyModel == BASE_INFO_FLY_MODEL_TYPE_SKY) {
        
        //起飞成功
        self.takeOffOrLandingBtn.selected = YES;
        if (_isClick == YES) {
            [self getStates:YES];
        }
        self.lock.hidden = YES;//隐藏锁按钮
    }
    else if (self.takeOffOrLandingBtn.selected == YES && FlyModel == BASE_INFO_FLY_MODEL_TYPE_OVERGROUND){
        
        //降落
        self.takeOffOrLandingBtn.selected = NO;
        self.lock.hidden = NO;//显示锁按钮
        self.lock.selected = NO;
        [self.takeOffOrLandingBtn setImage:[UIImage imageNamed:@"take-off-ash"] forState:UIControlStateNormal];
        [self getStates:NO];
    }
    

    if (self.flyControlManager.response.responseUnion.info.landed) {
        if (_followBtn.selected) {
            _followBtn.selected = NO;
            [_flyControlManager.controller followMe_action:_followBtn.selected];
        }
    }
    
    
    if (roting && self.flyControlManager.response.responseUnion.info.rote360 == 0 && self.circleBtn.selected){
        [self circleBtnClickAction:self.circleBtn];
    }
    roting = self.flyControlManager.response.responseUnion.info.rote360;
    NSLog(@"%d----------",self.flyControlManager.response.responseUnion.info.rote360);
    
    
    if (_deleate) {
        
        [_deleate getProgress:self.flyControlManager.response.responseUnion.info.calibProgress MagXY:self.flyControlManager.response.responseUnion.info.magXYCalib MagZ:self.flyControlManager.response.responseUnion.info.magZCalib Acc:self.flyControlManager.response.responseUnion.info.insCalib];
        
    }
    
    
    //    NSLog(@"%d",self.flyControlManager.response.responseUnion.info.calibProgress);
    //    if (self.flyControlManager.response.responseUnion.info.takeoff && self.takeOffOrLandingBtn.selected == NO) {
    //        //起飞成功
    //        self.takeOffOrLandingBtn.selected = YES;
    //        if (_isClick == YES) {
    //            [self getStates:YES];
    //        }
    //        self.lock.hidden = YES;//隐藏锁按钮
    //    }
    //    else if (self.flyControlManager.response.responseUnion.info.landed && self.takeOffOrLandingBtn.selected == YES){
    //        //降落
    //        self.takeOffOrLandingBtn.selected = NO;
    //        self.lock.hidden = NO;//显示锁按钮
    //    }
    
}

-(float)translateBattery:(unsigned int)vt
{
//    NSLog(@"  caocoaocooa   %d",vt);
    
    if (vt>780) {
        return 95;
    }
    else if (vt>700)
    {
        return 5+ceil((vt-700)/(0.8/0.9));
    }
    else return 5;
}

@end
