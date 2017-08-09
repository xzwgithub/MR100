//
//  LocationManager.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/27.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

-(int)startUpdateLocation;  //-1  未开启定位服务   -2用户进制该应用使用定位服务  0正常

-(void)stopUpdateLocation;

-(NSData *)getCoordinateData;

-(BOOL)isValidate;
@end
