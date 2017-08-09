//
//  StatusGpsInfoModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusGpsInfoModel : NSObject
/**
 *  纬度
 */
@property (nonatomic,assign) double  lat;
/**
 *  经度
 */
@property (nonatomic,assign) double  lon;
/**
 *  定位精度
 */
@property (nonatomic,assign) int8_t  eph;
/**
 *  搜星数量
 */
@property (nonatomic,assign) int8_t  satellites;
/**
 *  锁定类型
 */
@property (nonatomic,assign) int8_t  fix_type;


@end
