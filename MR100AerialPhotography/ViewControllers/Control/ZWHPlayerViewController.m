//
//  ZWHPlayerViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/12/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHPlayerViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
@interface ZWHPlayerViewController ()
@property(nonatomic, strong) AVPlayerItem *item;          //

@end

@implementation ZWHPlayerViewController

- (instancetype)initWithPlayItem:(AVPlayerItem *)item {

    if (self = [super init]) {
        _item = item;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:self.item];
    AVPlayerViewController *playVCtr = [[AVPlayerViewController alloc] init];
    playVCtr.player = player;
    playVCtr.showsPlaybackControls = true;
    [self addChildViewController:playVCtr];
    playVCtr.view.frame = self.view.bounds;
    [self.view addSubview:playVCtr.view];
    
    [playVCtr.player play];    //自动播放
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)dealloc {

}

@end
