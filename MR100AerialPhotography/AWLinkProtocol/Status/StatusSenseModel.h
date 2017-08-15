//
//  StatusSenseModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    STATUS_SENSOR_NORMAL = 0,//正常
    STATUS_SENSOR_ERROR,//异常
    STATUS_SENSOR_SELF_CHECK,//自检
    STATUS_SENSOR_WILL_CORRECT,//待校准
    STATUS_SENSOR_CORRECT_ING,//校准中
    STATUS_SENSOR_Not_EQUIPPED,//未配备
    
}STATUS_SENSOR_TYPE;

@interface StatusSenseModel : NSObject
/**
 *  加速度
 */
@property (nonatomic,assign) uint8_t  acc;
/**
 *  陀螺仪
 */
@property (nonatomic,assign) uint8_t  gyro;
/**
 *  罗盘
 */
@property (nonatomic,assign) uint8_t  mag;
/**
 *  气压计
 */
@property (nonatomic,assign) uint8_t  baro;
/**
 *  gps
 */
@property (nonatomic,assign) uint8_t  gps;
/**
 *  光流
 */
@property (nonatomic,assign) uint8_t  flow;

@end
