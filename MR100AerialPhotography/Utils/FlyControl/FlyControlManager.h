//
//  FlyControlManager.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/24.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Controller.h"
#import "FlyControlUdp.h"
#import "LocationManager.h"
#import "FlyResponse.h"

@interface FlyControlManager : NSObject
@property(nonatomic,strong)FlyControlUdp *udp;
@property(nonatomic,strong)Controller *controller;
@property(nonatomic,strong)LocationManager *location;
@property(nonatomic,strong)FlyResponse *response;
-(BOOL)isConnected;

-(void)connectToDevice;

-(void)startUploadData;

-(void)stopUploadData;

-(void)disconnectDevice;
@end
