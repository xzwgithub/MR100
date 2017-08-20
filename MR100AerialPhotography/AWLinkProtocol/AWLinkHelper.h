//
//  AWLinkHelper.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RemoteControlModel;
@class OffsetControlModel;
@class CorrectControlModel;

typedef enum{
    FlyControlModeTypeStabilize = 0,//自稳
    FlyControlModeTyeAlthold,//定高
    FlyControlModeTyePoshold,//定点
    FlyControlModeTyeTakeoff,//一键起飞
    FlyControlModeTyeLand,//降落
    FlyControlModeTyeFollowMe,//跟随
    FlyControlModeTyeAuto,//航点
    FlyControlModeTyeCircle,//热点环绕
    FlyControlModeTyeFlip,//空翻
    FlyControlModeTyeRTL,//返航
    FlyControlModeTyeStop,//停止
    FlyControlModeTyeLocal360,//本地旋转
    FlyControlModeTyeFindme,//param1为手机罗盘的角度
} FlyControlModeTye;

@interface AWLinkHelper : NSObject

//发送心跳
+(NSData*)getHeartBeatCommand:(uint8_t)heart;

//获取基本信息
+(NSData*)getBaseInfoCommand;

//获取传感器状态
+(NSData*)getSensorStatus;

//获取传感器校准状态
+(NSData*)getSensorCorrectStatus;

//模式控制
+(NSData*)sendFlyModelCommand:(FlyControlModeTye)modeType;

//遥感控制
+(NSData*)sendRemoteControlCommand:(RemoteControlModel*)remoteModel;

//零偏控制
+(NSData*)sendLingPianControlCommand:(OffsetControlModel*)offsetModel;

//校准控制 type(0:acc,1:mag,2:姿态) command(0:开始校准,1:中止校准)
+(NSData*)sendCorrectCommand:(CorrectControlModel*)correctModel;

@end
