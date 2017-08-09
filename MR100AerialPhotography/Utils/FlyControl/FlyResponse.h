//
//  FlyResponse.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatusBaseInfoModel;
@class StatusSenseCorrectModel;

@protocol responseBlockDelegate <NSObject>

@required

-(void)emergencyResponse:(int)ret;

-(void)updateInfo;
@end

#define DataLength 7
typedef struct
{
    unsigned int batteryV : 10;          //电压值    - u
    unsigned int lowBattery : 1;        //是否      - w
    unsigned int armed :2;              //0代表着陆，1代表准备起飞，2代表飞行中  电机状态
    unsigned int rote360 :1;            //1代表360旋转中 u
    unsigned int comeOn :1;             //代表返航  -w
    unsigned int takeoff :1;            //代表起飞成功 -1
    unsigned int autoLanding :1;        //自动着陆中 -w
    unsigned int landed :1;             //已经着陆 -u
    unsigned int tempOver :1;           //温度过高  -w
    unsigned int currOver :1;           //电机堵转    油门打到0，会解除堵转为0 -w 电机运转异常
    unsigned int gpsNum :5;             //gps星数,起飞前判断  -u
    unsigned int gpsFine :1;            //gps是否可用  -w
    unsigned int gpsInit :1;            //gps初始化  硬件有问题(带init的参数，为0是硬件有问题)  -e
    unsigned int magInit :1;            //mag初始化 -e
    unsigned int insInit :1;            //acc  -e
    unsigned int baroInit :1;           //气压计  -e
    unsigned int insCalib :1;           //表示acc正在校准 -u
    unsigned int magXYCalib :1;         //magxy正在校准  -u
    unsigned int magZCalib :1;          //magz正在校准   -u
    unsigned int calibProgress :7;      //进度  -u
    uint8_t altitude;                   //高度 误差1m左右
    uint8_t distance;                   //水平距离
    
}ReturnInfo;

typedef union {
    ReturnInfo info;
    uint8_t recievedData[DataLength];
}ResponseUnion;

@interface FlyResponse : NSObject
{
    dispatch_queue_t response_data_queue;
}
@property(nonatomic,assign,readonly)ResponseUnion responseUnion;
@property(nonatomic,assign)id <responseBlockDelegate>deleagte;
/**
 *  获取基本信息
 */
@property (nonatomic,strong) StatusBaseInfoModel * infoModel;
/**
 *  获取传感器校准状态
 */
@property (nonatomic,strong) StatusSenseCorrectModel * correctModel;

-(int)device_is_ok;

-(void)deatchData:(NSData *)responseData;

-(BOOL)gpsFine;

-(BOOL)getFlyingState;

@end
