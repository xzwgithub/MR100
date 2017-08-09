//
//  FlyControlUdp.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/12/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol flyUdpDelegate <NSObject>

-(void)deatchData:(NSData *)responseData;

@end
@interface FlyControlUdp : NSObject
-(void)udpConnect;
-(void)disConnectUdp;
-(BOOL)udpConnected;
-(void)sendData:(NSData *)data Tag:(int)tag;
@property(nonatomic,assign)id <flyUdpDelegate> delegate;

@end
