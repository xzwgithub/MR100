//
//  FlyControlUdp.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/12/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "FlyControlUdp.h"
#import "AsyncUdpSocket.h"

#define Port 9696
#define Ip @"192.168.100.1"
#define Timeout 1

@interface FlyControlUdp ()
{
    AsyncUdpSocket *flyUdp;
}
@end
@implementation FlyControlUdp

-(void)udpConnect{

    flyUdp = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSError *err;
   [flyUdp connectToHost:Ip onPort:Port error:&err];
    if (!err) {
        [flyUdp receiveWithTimeout:-1 tag:0];
    }
}
-(void)disConnectUdp{

    if ([flyUdp isConnected]) {
        [flyUdp close];
    }
}
-(BOOL)udpConnected{

    if (flyUdp) {
        return [flyUdp isConnected];
    }
    else return NO;
}
-(void)sendData:(NSData *)data Tag:(int)tag{

    if ([flyUdp isConnected]) {
        @synchronized (self) {
            [flyUdp sendData:data withTimeout:Timeout tag:tag];
        }
    }
}

#pragma mark - udp_socket



- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    
    NSLog(@"udp_socket----%@",error.description);
}


- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    
}


- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    
    [sock receiveWithTimeout:-1 tag:0];
    if (_delegate) {
        [_delegate deatchData:data];
    }
    
    return YES;
}



- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    
    
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock
{
    NSLog(@"已经关闭udp socket");
}


@end
