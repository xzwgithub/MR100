//
//  TcpManager.m
//  DVDemo
//
//  Created by luo雨思 on 16/7/4.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "TcpManager.h"
#import "AsyncSocket.h"

@implementation BlockModel
- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}
@end

@interface TcpManager ()
{
    AsyncSocket *asyncTcp;
    
    NSMutableArray *blockArr;
}
@end
@implementation TcpManager

#define Host_IP @"192.168.100.1"
#define PORT 4646
#define TIME_OUT 1

#define CMD_WAITING_TIME 5

#pragma mark - TCP About

-(BOOL)tcpConnected
{
    if (asyncTcp&&[asyncTcp isConnected]) {
        return YES;
    }
    else return NO;
}

-(void)tcpConnect{
    
    if ([asyncTcp isConnected]) {
        return;
    }
    asyncTcp = [[AsyncSocket alloc] initWithDelegate:self];
    
    NSError *err;
    [asyncTcp connectToHost:Host_IP onPort:PORT withTimeout:TIME_OUT error:&err];
    if (err) {
        NSLog(@"%@",err.debugDescription);
        return;
    }
}


-(void)reConnect
{
    if ([asyncTcp isConnected]) {
        [asyncTcp disconnect];
    }
    [self tcpConnect];
}

-(void)disConnectTcp
{
    if ([asyncTcp isConnected]) {
        [asyncTcp disconnect];
    }
}

-(BOOL)onSocketWillConnect:(AsyncSocket *)sock
{
    return YES;
}

-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock readDataWithTimeout:-1 tag:0];
    
    NSString *resultStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"resultStr: %@",resultStr);
    
    data = [self cleanStr:data];
    
    //检测是否是上报消息
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([[resultDic allKeys] containsObject:@"REPORT"]) {
        //卡插拔上报
        
        if (_delegate && [_delegate respondsToSelector:@selector(SDCardReport:)]) {
            [_delegate performSelector:@selector(SDCardReport:) withObject:resultDic];
        }
        
        return;
    }
    
    if (!blockArr.count) {
        return;
    }
    BlockModel *blockModel = [blockArr[0] copy];
    [blockArr removeObjectAtIndex:0];
    blockModel.block(data);
    
}

-(void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    
}

-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    
    [asyncTcp readDataWithTimeout:-1 tag:0];
    
    SEL action = @selector(connectSuccess);
    if ([_delegate respondsToSelector:action]) {
        [_delegate performSelector:action];
    }
}

-(void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
    
}

-(void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if (blockArr) {
        [blockArr removeAllObjects];
    }
    
    SEL action = @selector(connectFailed);
    if ([_delegate respondsToSelector:action]) {
        [_delegate performSelector:action];
    }
}

#pragma mark - APIS

-(void)sendData:(NSData *)data Response:(ResponseBlock)res Tag:(int)tag
{
    NSString *sendData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"sendData:    %@",sendData);

    if (blockArr.count!=0) {
        
        BlockModel *blockModel = blockArr[0];
        if (fabs([blockModel.addStamp timeIntervalSinceNow])<CMD_WAITING_TIME) {
            
            return;
        }
        else [blockArr removeAllObjects];
    }
    
    if (![asyncTcp isConnected]) {
        NSLog(@"没有连接tcp");
        return;
    }
    
    [asyncTcp writeData:data withTimeout:TIME_OUT tag:tag];
    if (!res) {
        return;
    }
    if (!blockArr) {
        blockArr = [[NSMutableArray alloc] init];
    }
    BlockModel *blockModel = [[BlockModel alloc] init];
    blockModel.addStamp = [NSDate date];
    blockModel.block = res;
    [blockArr addObject:blockModel];
}


-(NSData *)cleanStr:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [str stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}


@end
