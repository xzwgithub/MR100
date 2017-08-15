//
//  ResetViewController.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/12/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ResetViewController.h"
#import "ZWHSettingTableView.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/CADisplayLink.h>
#import "CustomAlertController.h"
#import "AWLinkConstant.h"
#import "AWProgressView.h"
#import "StatusSenseCorrectModel.h"

typedef enum {
    CalibratingNone = 0,
    CalibratingAcc,
    CalibratingMagXY,
    CalibratingMagZ
}Calibrating;

@interface ResetViewController ()<ZWHSettingTableViewDelegate,calibDelegate>
{
    NSInteger num;
    Calibrating state;
}
@property(nonatomic,strong)ZWHSettingTableView *menuTab;
@property(nonatomic, weak) UIView *topBarView;
@property(nonatomic,strong)CustomAlertController *alert;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)UILabel *calibrateMsg;
@property (nonatomic,strong) AWProgressView * progressView;
@property (nonatomic,assign) BOOL   isAccCorrect;//是否acc校验
@end

@implementation ResetViewController

-(AWProgressView *)progressView
{
    if (!_progressView) {
        
        _progressView = [[AWProgressView alloc] initWithFrame:CGRectMake(30, 100, 250, 25)];
        _progressView.progress = 0;
        _progressView.center = self.view.center;
        [self.view addSubview:_progressView];
    }
    return _progressView;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_progressView) {
        [_progressView removeFromSuperview];
        _progressView = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self topBarView];
    [self menuTab];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCorrectProgress:) name:kProgress_correct_acc object:nil];
    
}

-(void)updateCorrectProgress:(NSNotification*)notice
{
    if (!_isAccCorrect) return;
   
    StatusSenseCorrectModel * correctModel = (StatusSenseCorrectModel*)notice.object;
    NSInteger progress = correctModel.acc;
    if (progress >= 0 && progress <=100) {
        
        self.progressView.progress = progress/100.0;
        NSLog(@"acc_progress--%f",self.progressView.progress);
        if (progress == 100 && _isAccCorrect == YES) {
            
            _isAccCorrect = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.progressView removeFromSuperview];
                self.progressView = nil;
                
                UIAlertView *view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"acc_finish", @"Acc校准完成")  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
                [view show];

            });
    }

    }
    
}


- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.text = NSLocalizedString(@"acc reduction", @"acc还原");
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
            lb.frame = CGRectMake(kWidth / 2 - 50, 0, 200, 50);
            lb.center = view.center;
            lb.font = [UIFont boldSystemFontOfSize:19];
        }
        
        _topBarView = view;
    }
    return _topBarView;
}

- (void)back{
    
    ViewController *vc = [ViewController sharedViewController];
    vc.deleate = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (ZWHSettingTableView *)menuTab {
    if (_menuTab == nil) {
        if (kIsIpad) {
            _menuTab = [[ZWHSettingTableView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, self.view.bounds.size.height - 75)];
        }
        else {
            _menuTab = [[ZWHSettingTableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height - 50)];
        }
        
        _menuTab.backgroundColor = kWhiteColor;
        _menuTab.delegate = self;
        _menuTab.accessoryType = UITableViewCellAccessoryNone;
        
        ViewController *vc = [ViewController sharedViewController];
          _menuTab.titleArr = @[NSLocalizedString(@"mag calibration",@""),[NSString stringWithFormat:NSLocalizedString(@"aileron zero bias: %d lift zero bias: %d", @"副翼零偏: %d   升降零偏: %d"),[vc getFlyManager].controller.fuyilingpian,[vc getFlyManager].controller.shengjianglingpian],NSLocalizedString(@"acc calibration", @"acc校准")];

        [self.view addSubview:_menuTab];
    }
    return _menuTab;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ViewController *vc = [ViewController sharedViewController];
    
    switch (indexPath.row) {
        case 0:
        {
            //mag
            state = CalibratingMagXY;
            vc.deleate = self;
            [self playVideo];
            if ([vc getFlyManager]) {
                [[vc getFlyManager].controller magXAdapt_action];
            }
        }
            break;
        case 1:
        {


        }
            break;
        case 2:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"tip",@"提示") message:NSLocalizedString(@"please place the unmanned aerial vehicle (uav) in the horizontal plane after reduction, reduction takes about 2 seconds",@"请将无人机放置在水平面上后还原,还原大概需要2秒钟") preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action_confirm = [UIAlertAction actionWithTitle:NSLocalizedString(@"unmanned aerial vehicle (uav) has been placed",@"无人机已水平放置")  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                state = CalibratingAcc;
                vc.deleate = self;
                if ([vc getFlyManager]) {
                    [[vc getFlyManager].controller accAdapt_action];
                    [self progressView];
                    _isAccCorrect = YES;
                }
            }];
            UIAlertAction *action_cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel",@"取消") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
            }];
            [alert addAction:action_confirm];
            [alert addAction:action_cancel];
            [self.navigationController presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}


-(CustomAlertController *)alert
{
    if (!_alert) {
        _alert = [CustomAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            
            [self.alert dismissViewControllerAnimated:NO completion:^{
                
            }];
            self.alert.isVisable = NO;
            
//            if ([_alert.message isEqualToString:@"校准成功"] && ) {
//                ViewController *vc = [ViewController sharedViewController];
//                state = CalibratingMagZ;
//                vc.deleate = self;
//                //mag竖直
//                if ([vc getFlyManager]) {
//                    [[vc getFlyManager].controller magYAdapt_action];
//                }
//            }
        }];
        [self.alert addAction:action];
    }
    return _alert;
}


static bool isChanged = false;  //true代表第一次开始校准

-(void)getProgress:(int)progress MagXY:(BOOL)magXY MagZ:(BOOL)magZ Acc:(BOOL)acc
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (progress > 0) {
            
            if (state == CalibratingMagXY) {
                _calibrateMsg.text = [NSString stringWithFormat:@"正在进行水平校准:%d％",progress];
            }
            else if (state == CalibratingMagZ){
                
                _calibrateMsg.text = [NSString stringWithFormat:@"正在进行垂直校准:%d％",progress];
            }
            else if (state == CalibratingAcc){
                
                self.alert.message = [NSString stringWithFormat:@"正在进行acc校准:%d％",progress];
                if (self.alert.isVisable == NO) {
                    
                    [self.navigationController presentViewController:self.alert animated:YES completion:nil];
                    self.alert.isVisable = YES;
                }
                
            }
            isChanged = true;
            
        }
        else if (progress == 0 && isChanged && state!=CalibratingNone) {
            
            _calibrateMsg.text = @"";
            if (magXY && state == CalibratingMagXY) {
                
                [self nextItem];
                ViewController *vc = [ViewController sharedViewController];
                state = CalibratingMagZ;
                vc.deleate = self;
                //mag垂直
                if ([vc getFlyManager]) {
                    [[vc getFlyManager].controller magYAdapt_action];
                }
                isChanged = false;
                return ;
            }
            else if (magZ && state == CalibratingMagZ)
            {
                if (self.alert.isVisable == NO) {
                    [self.playerLayer.player pause];
                    self.alert.message = [NSString stringWithFormat:@"校准完成"];
                    [self.navigationController presentViewController:self.alert animated:YES completion:nil];
                    self.alert.isVisable = YES;
                }
            }
            else if(acc && state == CalibratingAcc)
            {
                self.alert.message = [NSString stringWithFormat:@"校准完成"];
            }
            else{
                self.alert.message = [NSString stringWithFormat:@"校准失败"];
                if (state == CalibratingAcc) {
                }
                else if (state == CalibratingMagXY || state == CalibratingMagZ)
                {
                    [_playerLayer.player pause];
                    
                    
                    if (self.alert.isVisable == NO) {
                        
                        [self.navigationController presentViewController:self.alert animated:YES completion:nil];
                        self.alert.isVisable = YES;
                    }
                    
                }
            }
            state = CalibratingNone;
            isChanged = false;
            
        }
    });
}


-(void)playVideo{
    
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"magH" ofType:@"mp4"]]];
    [self initPlayer:item];
    
    UIButton *finish_butt = [UIButton buttonWithType:UIButtonTypeCustom];
    finish_butt.frame = CGRectMake(_playerLayer.bounds.size.width-100, 30, 50, 30);
//    finish_butt.backgroundColor = [UIColor redColor];
    [finish_butt setImage:[UIImage imageNamed:@"CalibrateFinished"] forState:UIControlStateNormal];
    [finish_butt addTarget:self action:@selector(finishPlayed:) forControlEvents:UIControlEventTouchUpInside];
    
    _calibrateMsg = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, _playerLayer.bounds.size.width, 30)];
    _calibrateMsg.textAlignment = NSTextAlignmentCenter;
    _calibrateMsg.textColor = [UIColor whiteColor];
    _calibrateMsg.font = [UIFont systemFontOfSize:16];
    
    //关掉后面的tableview可点击
    _menuTab.userInteractionEnabled = NO;
    
    [self.view.layer addSublayer:_playerLayer];
    [self.view addSubview:finish_butt];
    [self.view addSubview:_calibrateMsg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    [self.playerLayer.player play];
}

-(void)nextItem{

    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"magV" ofType:@"mp4"]]];
    [self.playerLayer.player replaceCurrentItemWithPlayerItem:item];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    [self.playerLayer.player play];
}

-(void)playbackItemFinished:(NSNotification *)notification {

    [self.playerLayer.player seekToTime:CMTimeMake(0, 1)];
    [self.playerLayer.player play];
    
}

- (void)initPlayer:(AVPlayerItem *)item {

    if (_playerLayer == nil) {
        // Create an AVPlayer with the AVPlayerItem.
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        
        // Create an AVPlayerLayer with the AVPlayer.
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        // Configure the AVPlayerLayer and add it to the view.
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _playerLayer.backgroundColor = kLightGrayColor.CGColor;
        _playerLayer.frame = CGRectMake(0, 0, kWidth, kHeight);
    }
}

-(void)finishPlayed:(UIButton *)sender{

    _menuTab.userInteractionEnabled = YES;
    [self.playerLayer.player pause];
    [sender removeFromSuperview];
    [_calibrateMsg removeFromSuperview];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer.player = nil;
    self.playerLayer = nil;
    
    ViewController *vc = [ViewController sharedViewController];
    vc.deleate = nil;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
