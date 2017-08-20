//
//  FlyResponse.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "FlyResponse.h"
#import "FlyControlUdp.h"
#import "AWLinkConstant.h"
#import "SystemResponseModel.h"
#import "StatusSenseCorrectModel.h"
#import "NSData+CRC16.h"
#import "StatusBaseInfoModel.h"
#import "NSString+Reverse.h"
#import "AWLinkConstant.h"
#import "StatusSenseCorrectModel.h"
#import "StatusSenseModel.h"

@interface FlyResponse ()
/**
 *  心跳个数累计
 */
@property (nonatomic,assign) NSInteger  heartCount;
/**
 *  心跳暂停累计
 */
@property (nonatomic,assign) NSInteger  heartStopNum;

/**
 *  常驻线程
 */
@property (nonatomic,strong) NSThread * thread;

/**
 *  定时器
 */
@property (nonatomic,strong) NSTimer * timer;

/**
 *  弹框
 */
@property (nonatomic,strong) UIAlertView * alertView;

/**
 *  标志位
 */
@property (nonatomic,assign) boolean_t  isCheckHeart;

@end


@implementation FlyResponse

-(NSThread *)thread
{
    if (!_thread) {
        
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(runThread) object:nil];
        [_thread start];
    }
    return _thread;
}

//开启子线程
-(void)runThread
{
    @autoreleasepool {
        //1、添加一个input source
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        
    }
    
}

-(void)creatTimer
{
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(checkHeartCount) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
        _isCheckHeart = NO;
    }
    
}

-(void)checkHeartCount
{
    if (self.heartCount < 5 && !_isCheckHeart ) {
        
        self.heartStopNum++;
        
        if (self.heartStopNum == 5) {
            
            self.heartStopNum = 0;
            _isCheckHeart = YES;

            //弹框提示,关闭定时器
            if (_thread) {
                [_thread cancel];
                _thread = nil;
            }
            
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSInteger  FlyModel = [[[NSUserDefaults standardUserDefaults] objectForKey:FLY_MODE_STATUS] integerValue];
                
                if (FlyModel == BASE_INFO_FLY_MODEL_TYPE_SKY)
                {
                    
                    UIAlertView * view = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tip", @"提示") message:NSLocalizedString(@"The signal is not good, automatic return", @"信号不好，自动返航")  delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"确定") otherButtonTitles:nil, nil];
                    [view show];

                }
                    
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUI object:nil];
                
            });
            
            
        }
    }
    else
    {
        self.heartStopNum = 0;
    }
    @synchronized (self) {
        
        self.heartCount = 0;
    }
    
}



-(instancetype)init
{
    self = [super init];
    if (self) {
        response_data_queue = dispatch_queue_create("response_queue", NULL);
        _heartCount = 0;
    }
    return self;
}

-(void)deatchData:(NSData *)responseData
{
    NSLog(@"硬件返回数据:%@",responseData);
    [self getInfo:responseData];
}

#pragma mark - 硬件返回数据解析
-(void)getInfo:(NSData *)data
{
   
    uint8_t *resData = (uint8_t *)[data bytes];
    
    if (resData != NULL && resData[0] == 0xfa && resData[2] == 0x01) {
        
        if ([self crc16CheckIsOk:resData]) {
            
            switch (resData[3]) {//主项号
                case 0 : //系统
                    if (resData[4] == 3) {
                        
                        [self performSelector:@selector(creatTimer) onThread:self.thread withObject:nil waitUntilDone:NO ];
                        
                        _isCheckHeart = NO;
                        
                        @synchronized (self) {
                            //心跳包个数
                            self.heartCount++;
                        }

                    }
                    
                    break;
                    
                case 1: //状态
                    
                    //子项号
                    if (resData[4] == 0) {
                        //基本信息
                        self.infoModel = [self getBaseInfo:data];
                        [self updateInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kstopBaseInfoTimer object:nil];
                        
                    }else if (resData[4] == 4)
                    {
                        //传感器校准状态
                        self.correctModel = [self getSensorCorrectStatus:data];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kProgress_correct_acc object:self.correctModel];
                        
                    }else if (resData[4] == 3)
                    {
                        //传感器状态
                        self.senseStatusModel = [self getSensorStatus:data];
                       
                    }
                    
                    break;
                    
                default:
                    break;
            }
            
        }
  }
    
}

//传感器状态
-(StatusSenseModel*)getSensorStatus:(NSData*)data
{
    StatusSenseModel * senseModel = [[StatusSenseModel alloc]init];
    //加速度
    senseModel.acc = [self subNSData:data FromIndex:5];
    //陀螺仪
    senseModel.gyro = [self subNSData:data FromIndex:6];
    //罗盘
    senseModel.mag = [self subNSData:data FromIndex:7];
    //气压计
    senseModel.baro = [self subNSData:data FromIndex:8];
    //gps
    senseModel.gps = [self subNSData:data FromIndex:9];
    //光流
    senseModel.flow = [self subNSData:data FromIndex:10];
    
    return senseModel;
}

//传感器校准状态
-(StatusSenseCorrectModel*)getSensorCorrectStatus:(NSData*)data
{
    StatusSenseCorrectModel * correctInfo = [[StatusSenseCorrectModel alloc]init];
    //acc加速度
    correctInfo.acc = [self subNSData:data FromIndex:5];
    //mag罗盘
    correctInfo.mag = [self subNSData:data FromIndex:6];
    
    NSLog(@"传感器校准状态--acc:%hhu----mag:%hhu",correctInfo.acc,correctInfo.mag);
    
    return correctInfo;
}


//获取基本信息
-(StatusBaseInfoModel*)getBaseInfo:(NSData*)data
{
    StatusBaseInfoModel * info = [[StatusBaseInfoModel alloc]init];
    //姿态 x,y,z
    float zX = [self subNSData:data FromIndex:5 length:4];
    float zY = [self subNSData:data FromIndex:9 length:4];
    float zZ = [self subNSData:data FromIndex:13 length:4];;
    info.att = @[@(zX),@(zY),@(zZ)];
    
    //速度x,y,z
    float sX = [self subNSData:data FromIndex:17 length:4];
    float sY = [self subNSData:data FromIndex:21 length:4];
    float sZ = [self subNSData:data FromIndex:25 length:4];;
    info.att = @[@(sX),@(sY),@(sZ)];
    
    //位置x,y,z
    float pX = [self subNSData:data FromIndex:29 length:4];
    float pY = [self subNSData:data FromIndex:33 length:4];
    float pZ = [self subNSData:data FromIndex:37 length:4];;
    info.att = @[@(pX),@(pY),@(pZ)];
    
    //状态，模式，电量，电压
    info.status = [self subNSData:data FromIndex:41];
    info.mode = [self flyModelWithInt: [self subNSData:data FromIndex:42]];
    NSLog(@"无人机返回飞行状态：%hhu", [self subNSData:data FromIndex:42]);
    
    //飞行模式保存
    [[NSUserDefaults standardUserDefaults] setObject:@(info.mode) forKey:FLY_MODE_STATUS];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    info.capacity = [self subNSData:data FromIndex:43];
    //电量保存
    [[NSUserDefaults standardUserDefaults] setObject:@(info.capacity) forKey:ELECTRIC_NUM];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    info.Voltage = [self subNSData:data FromIndex:44];
    //充电，高温监测，解锁
    info.charge = [self subNSData:data FromIndex:45];
    info.temp = [self subNSData:data FromIndex:46];
    info.armed = [self subNSData:data FromIndex:47];
    
    return info;
}


//判断飞机飞行模式(天上，地下)
-(BASE_INFO_FLY_MODEL_TYPE)flyModelWithInt:(uint8_t)model
{
    if (model==BASE_INFO_MODEL_LAND || model == BASE_INFO_FLY_MODEL_STOP || model == BASE_INFO_MODEL_RTL) {
        
        return BASE_INFO_FLY_MODEL_TYPE_OVERGROUND;
        
    }else
    {
        return BASE_INFO_FLY_MODEL_TYPE_SKY;
    }
    
    return BASE_INFO_FLY_MODEL_TYPE_UnKnow;
}


//指定位置截取指定长度的nsdata转成float数据
-(float)subNSData:(NSData*)data FromIndex:(NSInteger)index length:(NSInteger)length
{
    NSData * ZTData = [data subdataWithRange:NSMakeRange(index, length)];
    NSString * ZTStr = [self convertDataToHexStr:ZTData];
    NSString * ZTReverStr = [ZTStr twoBitReverse];
    float x = strtoul([ZTReverStr UTF8String], 0, 16);
    return x;
}

//指定位置截取1个长度的nsdata转成int数据
-(uint8_t)subNSData:(NSData*)data FromIndex:(NSInteger)index
{
    NSData * ZTData = [data subdataWithRange:NSMakeRange(index, 1)];
    NSString * ZTStr = [self convertDataToHexStr:ZTData];
    NSString * ZTReverStr = [ZTStr twoBitReverse];
    uint8_t x = strtoul([ZTReverStr UTF8String], 0, 16);
    return x;
}


//二进制转换成字符串
- (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}


#pragma mark - crc16校验是否正确
-(BOOL)crc16CheckIsOk:(uint8_t*)resData
{
    //crc16校验和
    int length = resData[1];
    Byte crc16Byte[length+4];
    for (int i=1 ; i<= length + 4 ; i++) {
        crc16Byte[i-1] = resData[i];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16Byte length:sizeof(crc16Byte)/sizeof(crc16Byte[0])];
    uint16_t crc16CheckSum = [crc16Data crc16];
    uint16_t crc16ResposeSum = resData[length+6]<<8 | resData[length+5];
    BOOL isSuccess = (crc16CheckSum == crc16ResposeSum);
    return isSuccess;
}


//应答消息
-(SystemResponseModel*)getResponseInfo:(uint8_t *)resData{
 
    SystemResponseModel * response = [[SystemResponseModel alloc]init];
    int start = 5;
    response.isSuccess = resData[start] == (Byte)0;
    response.item_id = resData[start+1];
    response.subitem_id = resData[start+2];
    return response;
}


-(void)checkResponse
{
    int ret = 0;
    
    ret = [self emergencyTip];
    if (ret != 0) {
        if (_deleagte) {
            [_deleagte emergencyResponse:ret];
        }
    }
    
    [self updateInfo];
}


-(int)device_is_ok
{
    if (_responseUnion.info.gpsInit && _responseUnion.info.insInit && _responseUnion.info.baroInit && _responseUnion.info.magInit) {
        return 0; //硬件正常
    }
    else if (!_responseUnion.info.gpsInit) return 1;
    else if (!_responseUnion.info.insInit) return 2;
    else if (!_responseUnion.info.baroInit) return 3;
    else if (!_responseUnion.info.magInit) return 4;
    else return -1;
}

-(int)emergencyTip
{
    if (!_responseUnion.info.tempOver && !_responseUnion.info.currOver && !_responseUnion.info.lowBattery && !_responseUnion.info.gpsFine) {
        return 0; //正常
    }
    else if (_responseUnion.info.tempOver) return 1; //高温
    else if (_responseUnion.info.currOver) return 2; //电机堵转
    else if (_responseUnion.info.lowBattery) return 3; //低电
    else return -1;
}

-(void)updateInfo
{
    //电压、gps星数、校准、校准进度
    dispatch_async(dispatch_get_main_queue(), ^{
    
        if (_deleagte) {
            [_deleagte updateInfo];
        }
    });
}


-(BOOL)gpsFine
{
    return _responseUnion.info.gpsFine;
}

-(BOOL)getFlyingState
{
    return _responseUnion.info.takeoff;
}
@end
