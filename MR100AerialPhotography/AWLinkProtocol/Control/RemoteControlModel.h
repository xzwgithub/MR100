//
//  RemoteControlModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  roll pitch yaw取值范围为-1000-1000
 摄像头的视场角为alpha
 yaw的取值范围为(-alpha,alpha)
 */

@interface RemoteControlModel : NSObject

/**
 *  左右移动
 */
@property (nonatomic,assign) int16_t roll;

/**
 *  前后移动
 */
@property (nonatomic,assign) int16_t pitch;

/**
 *  偏航(方向舵)
 */
@property (nonatomic,assign) int16_t yaw;

/**
 *  油门
 */
@property (nonatomic,assign) int16_t throttle;



@end
