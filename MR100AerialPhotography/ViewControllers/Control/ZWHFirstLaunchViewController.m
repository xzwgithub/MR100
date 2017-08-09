//
//  ZWHFirstLaunchViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/12.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHFirstLaunchViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/CADisplayLink.h>

@interface ZWHFirstLaunchViewController ()

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property(nonatomic, strong) NSArray *movArray;          //
@property(nonatomic, strong) UIButton *previousBtn;      //
@property(nonatomic, strong) UIButton *nextBtn;          //
@property(nonatomic, strong) UIButton *replayBtn;        //
@property(nonatomic, strong) UIButton *skipBtn;          //
@property(nonatomic, assign) NSInteger index;            //
@property(nonatomic, strong) UIView *bgView;             //
@property(nonatomic, assign) NSInteger count;            //

@end

@implementation ZWHFirstLaunchViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self playerLayer];
        [self bgView];
        [self previousBtn];
        [self nextBtn];
        [self replayBtn];
        [self skipBtn];
        self.index = 0;
        self.count = 0;
        //给AVPlayerItem添加播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    }
    return self;
}

- (void)dealloc {

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self.playerLayer.player play];
}

- (UIView *)bgView {

    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgView.backgroundColor = kClearColor;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

- (UIButton *)previousBtn {

    if (_previousBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(50, kHeight - 150, 80, 45);
            [btn setImage:ImageNamed(@"last_ipad") forState:UIControlStateNormal];
        }
        else {
            btn.frame = CGRectMake(25, kHeight - 55 - 24, 46, 24);
            [btn setImage:ImageNamed(@"Last-step-icon") forState:UIControlStateNormal];
        }
        
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kClearColor.CGColor;
        btn.layer.borderWidth = 2;
        [btn setBackgroundImage:ImageNamed(@"Last-step-bg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(previousBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        _previousBtn = btn;
    }
    return _previousBtn;
}

- (void)previousBtnClickAction:(UIButton *)sender {

    self.bgView.backgroundColor = kClearColor;
    self.count = 0;
    
    self.index--;
    if (self.index < 0) {
        self.index = 0;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"it has already been done not have",@"前面已经没有了") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"确定"), nil];
        [alert show];
        return;
    }
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.movArray[self.index]]];
    [self.playerLayer.player replaceCurrentItemWithPlayerItem:item];
    [self.playerLayer.player play];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    
}

- (UIButton *)nextBtn {

    if (_nextBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(50 + 80 + 100, kHeight - 150, 80, 45);
            [btn setImage:ImageNamed(@"next_ipad") forState:UIControlStateNormal];
        }
        else {
            btn.frame = CGRectMake(25 + 46 + 50, kHeight - 55 - 24, 46, 24);
            [btn setImage:ImageNamed(@"Next-step-icon") forState:UIControlStateNormal];
        }
        
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kWhiteColor.CGColor;
        btn.layer.borderWidth = 2;
        [btn setBackgroundImage:ImageNamed(@"Last-step-bg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nextBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        _nextBtn = btn;
    }
    return _nextBtn;
}

- (void)nextBtnClickAction:(UIButton *)sender {

    self.bgView.backgroundColor = kClearColor;
    self.count = 0;
    self.index++;
    if (self.index > 8) {
        self.index = 8;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"is the last",@"已经是最后一个了")  delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok",@"确定"), nil];
        [alert show];
        return;
    }
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.movArray[self.index]]];
    [self.playerLayer.player replaceCurrentItemWithPlayerItem:item];
    [self.playerLayer.player play];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
}

- (UIButton *)replayBtn {

    if (_replayBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            btn.frame = CGRectMake(kWidth - 80 - 50 - 100 - 80, kHeight - 150, 80, 45);
            [btn setImage:ImageNamed(@"replay_ipad") forState:UIControlStateNormal];
        }
        else {
            btn.frame = CGRectMake(kWidth - 25 - 46 - 50 - 46, kHeight - 55 - 24, 46, 24);
            [btn setImage:ImageNamed(@"To-replay-icon") forState:UIControlStateNormal];
        }
        
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kWhiteColor.CGColor;
        btn.layer.borderWidth = 2;
        [btn setBackgroundImage:ImageNamed(@"Last-step-bg") forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(replayBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        _replayBtn = btn;
    }
    return _replayBtn;
}

- (void)replayBtnClickAction:(UIButton *)sender {

    self.bgView.backgroundColor = kClearColor;
    self.count = 0;
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.movArray[self.index]]];
    [self.playerLayer.player replaceCurrentItemWithPlayerItem:item];
    [self.playerLayer.player play];
    //给AVPlayerItem添加播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackItemFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
}

- (UIButton *)skipBtn {

    if (_skipBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:ImageNamed(@"Last-step-bg") forState:UIControlStateNormal];
        if (kIsIpad) {
            btn.frame = CGRectMake(kWidth - 80 - 50, kHeight - 150, 80, 45);
            [btn setImage:ImageNamed(@"skip_ipad") forState:UIControlStateNormal];
        }
        else {
            btn.frame = CGRectMake(kWidth - 25 - 46, kHeight - 55 - 24, 46, 24);
            [btn setImage:ImageNamed(@"skip-icon") forState:UIControlStateNormal];
        }
        
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = kWhiteColor.CGColor;
        btn.layer.borderWidth = 2;
        [btn addTarget:self action:@selector(skipBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        _skipBtn = btn;
    }
    return _skipBtn;
}

- (void)skipBtnClickAction:(UIButton *)sender {
    
    if (![kUserDefaults objectForKey:kShare1Platform]) {
        ViewController *vc = [ViewController sharedViewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = nav;

        [kUserDefaults setObject:@(ZWHSharePlatformFacebook | ZWHShareCaptionModeAfter) forKey:kShare1Platform];
        [kUserDefaults setObject:@(ZWHSharePlatformTwitter | ZWHShareCaptionModeAfter) forKey:kShare2Platform];
        [kUserDefaults setObject:@0 forKey:kClearScreen];
        [kUserDefaults synchronize];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (AVPlayerLayer *)playerLayer {

    if (_playerLayer == nil) {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:self.movArray[self.index]]];

        // Create an AVPlayer with the AVPlayerItem.
        AVPlayer *player = [AVPlayer playerWithPlayerItem:item];
        
        // Create an AVPlayerLayer with the AVPlayer.
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        // Configure the AVPlayerLayer and add it to the view.
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        playerLayer.backgroundColor = kLightGrayColor.CGColor;
        playerLayer.frame = CGRectMake(0, 0, kWidth, kHeight);
        
        [self.view.layer addSublayer:playerLayer];
        
        _playerLayer = playerLayer;
    }
    return _playerLayer;
}


#pragma mark - 通知

/**
 *  播放完成通知
 *
 *  @param notification 通知对象
 */
-(void)playbackItemFinished:(NSNotification *)notification {
    [self nextBtnClickAction:nil];
}


- (NSArray *)movArray {

    if (_movArray == nil) {
        NSString *path0 = [[NSBundle mainBundle] pathForResource:@"0_handle" ofType:@"mov"];
        NSString *path1 = [[NSBundle mainBundle] pathForResource:@"1_photo" ofType:@"mov"];
        NSString *path2 = [[NSBundle mainBundle] pathForResource:@"2_movie" ofType:@"mov"];
        NSString *path3 = [[NSBundle mainBundle] pathForResource:@"3_circle" ofType:@"mov"];
        NSString *path4 = [[NSBundle mainBundle] pathForResource:@"4_emergency" ofType:@"mov"];
        NSString *path5 = [[NSBundle mainBundle] pathForResource:@"5_light" ofType:@"mov"];
        NSString *path6 = [[NSBundle mainBundle] pathForResource:@"6_share" ofType:@"mov"];
        NSString *path7 = [[NSBundle mainBundle] pathForResource:@"7_sd" ofType:@"mov"];
        NSString *path8 = [[NSBundle mainBundle] pathForResource:@"8_takeoff" ofType:@"mov"];
        _movArray = @[path0,path1,path2,path3,path4,path5,path6,path7,path8];
    }
    return _movArray;
}
@end
