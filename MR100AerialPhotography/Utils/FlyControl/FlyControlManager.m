//
//  FlyControlManager.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/24.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "FlyControlManager.h"
#import "AWLinkHelper.h"
#import "RemoteControlModel.h"
#import "OffsetControlModel.h"
#import "AWLinkConstant.h"
#import "CorrectControlModel.h"
#import "AWLinkHelper.h"

@interface FlyControlManager ()<flyUdpDelegate>
{
    uint8_t _heartCount;//心跳计数
}
@property(nonatomic,strong)NSTimer *controlTimer;
@property(nonatomic,strong)NSTimer *baseInfoTimer;
@property(nonatomic,strong)NSTimer *heartBeatTimer;
@end

@implementation FlyControlManager

#define SendRate 10   //ms
#define BaseInfoRate 1000 //ms
#define HeartBeatRate 50 //ms

-(Controller *)controller
{
    if (!_controller) {
        _controller = [[Controller alloc] init];
    }
    return _controller;
}

-(LocationManager *)location
{
    if (!_location) {
        _location = [[LocationManager alloc] init];
    }
    return _location;
}


-(FlyControlUdp *)udp
{
    if (!_udp) {
        _udp = [[FlyControlUdp alloc] init];
        _udp.delegate = self;
    }
    return _udp;
}

-(FlyResponse *)response
{
    if (!_response) {
        _response = [[FlyResponse alloc] init];
    }
    return _response;
}

-(BOOL)isConnected
{
    return [self.udp udpConnected];
}

-(void)connectToDevice
{
    [self.udp udpConnect];
}

-(instancetype)init
{
    if (self = [super init]) {
        
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lingPian) name:kNotice_lingPian object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accCorrect) name:kNotice_correct_acc object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Rotate360) name:kNotice360 object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emergency) name:kEmergency object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeoff) name:ktakeoff object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(land) name:kland object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopBaseInfoTimer) name:kstopBaseInfoTimer object:nil];
        
    }
    
    return self;
}

-(void)stopBaseInfoTimer
{
    if (_baseInfoTimer) {
        [_baseInfoTimer invalidate];
        _baseInfoTimer = nil;
    }
}

-(void)startUploadData
{
    
    if (!_controlTimer) {
        _controlTimer = [NSTimer scheduledTimerWithTimeInterval:SendRate/1000.0 target:self selector:@selector(sendControlMsg:) userInfo:nil repeats:YES];
        [_controlTimer fire];
    }
    
    if (!_baseInfoTimer) {
        _baseInfoTimer = [NSTimer scheduledTimerWithTimeInterval:BaseInfoRate/1000.0 target:self selector:@selector(getBaseInfo:) userInfo:nil repeats:YES];
        [_baseInfoTimer fire];
    }
    if (!_heartBeatTimer) {
        _heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:HeartBeatRate/1000.0 target:self selector:@selector(sendHeartBeat) userInfo:nil repeats:YES];
        [_heartBeatTimer fire];
    }
    
}

//发送心跳
-(void)sendHeartBeat
{
    _heartCount++;
    if (_heartCount > 255) {
        _heartCount = 0;
    }
    [self.udp sendData:[AWLinkHelper getHeartBeatCommand:_heartCount] Tag:0];
    
}

//发送遥感控制命令
-(void)sendControlMsg:(NSTimer *)timer
{
    //发送遥感控制
    [self.udp sendData:[AWLinkHelper sendRemoteControlCommand:[self getRemoteModel]] Tag:0];
}


//获取基础信息和状态信息
-(void)getBaseInfo:(NSTimer*)timer
{
    //获取基本信息
    [self.udp sendData:[AWLinkHelper getBaseInfoCommand] Tag:0];
    //获取传感器状态
    [self.udp sendData:[AWLinkHelper getSensorStatus] Tag:0];
    //获取传感器校准状态
    [self.udp sendData:[AWLinkHelper getSensorCorrectStatus] Tag:0];
}

//一键起飞
-(void)takeoff
{
     [self.udp sendData:[AWLinkHelper sendFlyModelCommand:FlyControlModeTyeTakeoff] Tag:0];
}

//一键降落
-(void)land
{
    [self.udp sendData:[AWLinkHelper sendFlyModelCommand:FlyControlModeTyeLand] Tag:0];
}

//紧急降落
-(void)emergency
{
    //紧急降落
    [self.udp sendData:[AWLinkHelper sendFlyModelCommand:FlyControlModeTyeStop] Tag:0];
}


//发送360本地旋转
-(void)Rotate360
{
    [self.udp sendData:[AWLinkHelper sendFlyModelCommand:FlyControlModeTyeLocal360] Tag:0];
}


//发送零偏控制命令
-(void)lingPian
{
    //发送零偏控制命令
    [self.udp sendData:[AWLinkHelper sendLingPianControlCommand:[self getOffsetModel]] Tag:0];
}

//校准控制
-(void)accCorrect
{
    //发送零偏控制命令
    [self.udp sendData:[AWLinkHelper sendCorrectCommand:[self getAccCorrectModel]] Tag:0];
}

#pragma mark -获取acc校准控制命令
-(CorrectControlModel*)getAccCorrectModel
{
    CorrectControlModel * correctModel = [[CorrectControlModel alloc]init];
    correctModel.type = ControlCorrectTypeAcc;
    correctModel.command = ControlCorrectCommandStart;
    return correctModel;
}

#pragma mark -获取零偏控制命令
-(OffsetControlModel*)getOffsetModel
{
    OffsetControlModel * offset = [[OffsetControlModel alloc]init];
    offset.att_offset = @[@(self.controller.fuyilingpian),@(self.controller.shengjianglingpian),@(0)];
    return offset;
}

#pragma mark -获取遥感控制命令
-(RemoteControlModel*)getRemoteModel
{
    RemoteControlModel * remoteModel = [[RemoteControlModel alloc]init];
    remoteModel.throttle = self.controller.youmen;
    remoteModel.yaw = self.controller.fangxiang;
    remoteModel.roll = self.controller.fuyi;
    remoteModel.pitch = self.controller.shengjiang;
    return remoteModel;
}


-(void)stopUploadData
{
    if (_controlTimer) {
        [_controlTimer invalidate];
        _controlTimer = nil;
    }

    if (_baseInfoTimer) {
        [_baseInfoTimer invalidate];
        _baseInfoTimer = nil;
    }
}

-(void)disconnectDevice
{
    [self.udp disConnectUdp];
}

#pragma mark - tcp delegate

-(void)deatchData:(NSData *)responseData
{
    if (!self.response) {

        return;
    }
    [_response deatchData:responseData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
