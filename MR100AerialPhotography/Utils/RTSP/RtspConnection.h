//
//  RtspConnection.h
//  WRJ_RTSP
//
//  Created by luo雨思 on 15/10/27.
//  Copyright (c) 2015年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define h264_add @"rtsp://192.168.100.1:7070/H264VideoSMS"
#define online_play @"rtsp://192.168.100.1:7070/VideoFileLive"

@protocol rtspDeleagte <NSObject>

@required

//解码一帧数据，frame为帧数据，size为帧数据大小。
-(void)decodeNalu:(uint8_t *)buffer Size:(int)size;

//获取h264编码的sps、pps信息。
-(void)gotSps:(uint8_t *)sps SpsSize:(int)spsSize Pps:(uint8_t *)pps PpsSize:(int)ppsSize;

@end

@interface RtspConnection : NSObject
singleton_interface(RtspConnection)

//开启rtsp通道，传输视频流数据，online参数填no即可 yes no 决定用h264_add还是online_play
-(void)start_rtsp_session:(BOOL)online;
//关闭rtsp通道
-(void)close_rtsp_client;

+(RtspConnection *)shareStore;

//判断rtsp连接状态
-(BOOL)isConnecting;

@property(assign,nonatomic)id <rtspDeleagte> delegate;

@end
