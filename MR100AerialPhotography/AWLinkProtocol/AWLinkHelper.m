//
//  AWLinkHelper.m
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import "AWLinkHelper.h"
#import "NSData+CRC16.h"
#import "NSString+StatusTransform.h"
#import "RemoteControlModel.h"
#import "OffsetControlModel.h"
#import "CorrectControlModel.h"



#define START_CODE 0xfa  //起始码
#define ID_SRC 0x00      //主机

@implementation AWLinkHelper

//获取基本信息
+(NSData*)getBaseInfoCommand
{
    int length = 9;
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x02;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x01;
    message[5] = 0x00;
    message[6] = 0x14;//发送频率20hz
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[7] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[8] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    NSLog(@"获取基本信息命令：%@",data);
    return data;
}

//获取传感器状态
+(NSData*)getSensorStatus
{
    int length = 9;
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x02;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x01;
    message[5] = 0x03;//传感器状态
    message[6] = 0x14;//发送频率20hz
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[7] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[8] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    NSLog(@"获取传感器状态命令：%@",data);
    return data;

}

//获取传感器校准状态
+(NSData*)getSensorCorrectStatus
{
    
    int length = 9;
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x02;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x01;
    message[5] = 0x04;//传感器校准
    message[6] = 0x14;//20代表发送频率
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[length-2] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[length-1] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    NSLog(@"获取传感器校准状态命令：%@",data);
    return data;

}

//模式控制
+(NSData*)sendFlyModelCommand:(FlyControlModeTye)modeType
{
    int length = 16;//数据位16个字节
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x09;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x03;
    message[5] = strtoul([[NSString getHexByDecimal:modeType] UTF8String], 0, 16);
    message[6] = message[7] = message[8] = message[10] = message[11] = message[12] = 0x00;
    message[9] = (modeType == FlyControlModeTyeTakeoff || modeType == FlyControlModeTyeLocal360)? 0x01:0x00;
    message[13] = (modeType == FlyControlModeTyeTakeoff || modeType == FlyControlModeTyeLocal360)? 0x01:0x00;;
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[14] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[15] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    if (![[NSString flyModelTransform:modeType] isEqualToString:@"other"]) {
        
       NSLog(@"发送-%@-模式控制命令：%@",[NSString flyModelTransform:modeType],data);
    }
    return data;

}

//遥感控制
+(NSData*)sendRemoteControlCommand:(RemoteControlModel*)remoteModel
{
    int length = 15;//数据位八个字节
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x08;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x00;
    
    //左右
    message[5] = strtoul([[NSString getHexByDecimal:remoteModel.roll&0xff] UTF8String],0,16);//低位
    message[6] = strtoul([[NSString getHexByDecimal:remoteModel.roll>>8] UTF8String],0,16);//高位
    
    //前后
    message[7] = strtoul([[NSString getHexByDecimal:remoteModel.pitch&0xff] UTF8String],0,16);//低位
    message[8] = strtoul([[NSString getHexByDecimal:remoteModel.pitch>>8] UTF8String],0,16);
    //偏航
    message[9] = strtoul([[NSString getHexByDecimal:remoteModel.yaw&0xff] UTF8String],0,16);//低位
    message[10] =strtoul([[NSString getHexByDecimal:remoteModel.yaw>>8] UTF8String],0,16);
    //油门
    message[11] = strtoul([[NSString getHexByDecimal:remoteModel.throttle&0xff] UTF8String],0,16);//低位
    message[12] = strtoul([[NSString getHexByDecimal:remoteModel.throttle>>8] UTF8String],0,16);
    
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[13] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[14] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    
    NSLog(@"发送摇杆控制命令：(%hd,%hd,%hd,%hd)---%@",remoteModel.roll,remoteModel.pitch,remoteModel.yaw,remoteModel.throttle,data);
    return data;

}

//零偏控制
+(NSData*)sendLingPianControlCommand:(OffsetControlModel*)offsetModel
{
    int length = 19;//数据位16个字节
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x0c;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x05;
    
    //x
    float x = [offsetModel.att_offset[0] floatValue];
    unsigned char * xChar = (unsigned char*)&x;
    message[5] = xChar[0];
    message[6] = xChar[1];
    message[7] = xChar[2];
    message[8] = xChar[3];
    
    //y
    float y = [offsetModel.att_offset[1] floatValue];
    unsigned char * yChar = (unsigned char*)&y;
    message[9] = yChar[0];
    message[10] = yChar[1];
    message[11] = yChar[2];
    message[12] = yChar[3];
    
    
    //z
    float z = [offsetModel.att_offset[2] floatValue];
    unsigned char * zChar = (unsigned char*)&z;
    message[13] = zChar[0];
    message[14] = zChar[1];
    message[15] = zChar[2];
    message[16] = zChar[3];

    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[17] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[18] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
   
    NSLog(@"发送零偏控制命令：(%@,%@,%@)---%@",offsetModel.att_offset[0],offsetModel.att_offset[1],offsetModel.att_offset[2],data);
    return data;
}

//校准控制
+(NSData*)sendCorrectCommand:(CorrectControlModel*)correctModel
{
    int length = 9;//数据位八个字节
    Byte message[length];
    message[0] = START_CODE;
    message[1] = 0x02;
    message[2] = ID_SRC;
    message[3] = 0x02;
    message[4] = 0x02;
    message[5] = strtoul([[NSString getHexByDecimal:correctModel.type] UTF8String],0,16);
    message[6] = strtoul([[NSString getHexByDecimal:correctModel.command] UTF8String],0,16);
    
    //crc16校验和
    Byte crc16[length-3];
    for (int i = 0; i < length-3; i++) {
        crc16[i] = message[i+1];
    }
    NSData * crc16Data = [NSData dataWithBytes:crc16 length:sizeof(crc16)/sizeof(crc16[0])];
    uint16_t crc16_int = [crc16Data crc16];
    int high = crc16_int>>8;
    int low = crc16_int&0xff;
    message[7] =  strtoul([[NSString getHexByDecimal:low] UTF8String],0,16); //0x29
    message[8] = strtoul([[NSString getHexByDecimal:high] UTF8String],0,16);
    NSData *data = [[NSData alloc] initWithBytes:message length:length];
    
    NSLog(@"发送校准控制命令：(%u,%u)---%@",correctModel.type,correctModel.command,data);
    return data;
}



@end
