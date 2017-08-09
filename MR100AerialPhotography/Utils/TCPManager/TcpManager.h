//
//  TcpManager.h
//  DVDemo
//
//  Created by luo雨思 on 16/7/4.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(NSData *responseData);
@interface TcpManager : NSObject

@property(nonatomic,weak)id delegate;  //需要处理上报消息
-(void)tcpConnect;
-(void)disConnectTcp;
-(void)reConnect;
-(void)sendData:(NSData *)data Response:(ResponseBlock)res Tag:(int)tag;
-(BOOL)tcpConnected;
@end

@interface BlockModel : NSObject<NSCopying>
@property(nonatomic,strong)NSDate *addStamp;
@property(nonatomic,copy)ResponseBlock block;

@end
