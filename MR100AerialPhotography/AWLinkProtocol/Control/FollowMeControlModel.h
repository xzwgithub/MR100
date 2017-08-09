//
//  FollowMeControlModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FollowMeControlModel : NSObject

/**
 *  纬度
 */
@property (nonatomic,assign) double  lat;
/**
 *  经度
 */
@property (nonatomic,assign) double  lon;
/**
 *  朝向 yaw的取值范围为0-3600,为罗盘的方向
 */
@property (nonatomic,assign) double  yaw;

/**
 *  高度米
 */
@property (nonatomic,assign) float  alt;

/**
 *  精度，精度为经纬度的定位精度,单位为米
 */
@property (nonatomic,assign) float  accuracy;

/**
 *  vel为gps的速度
 */
@property (nonatomic,strong) NSArray * vel;

/**
 *  gps_valid为GPS有效性
 */
@property (nonatomic,assign) BOOL  gps_valid;

/**
 *  mag_valid为罗盘有效性
 */
@property (nonatomic,assign) BOOL  mag_valid;

@end
