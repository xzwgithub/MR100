//
//  StatusBaseInfoModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLY_MODE_STATUS @"Fly_model_STATUS"
#define ELECTRIC_NUM @"electric_num"


typedef enum{
    
    BASE_INFO_STATUS_NORMAL = 0,//正常
    BASE_INFO_STATUS_SELF_CHECK,//自检
    BASE_INFO_STATUS_ERROR //异常

}BASE_INFO_STATUS_TYPE;

typedef enum{
    
    BASE_INFO_MODEL_STABILIZE = 0,
    BASE_INFO_MODEL_ALTHOLD,
    BASE_INFO_MODEL_POSHOLD,
    BASE_INFO_MODEL_TAKEOFF,
    BASE_INFO_MODEL_LAND,
    BASE_INFO_MODEL_FOLLOWME,
    BASE_INFO_MODEL_AUTO,
    BASE_INFO_MODEL_CIRCLE,
    BASE_INFO_MODEL_FLIP,
    BASE_INFO_MODEL_RTL,
    BASE_INFO_FLY_MODEL_STOP,
    BASE_INFO_FLY_MODEL_LOCAL360,
    BASE_INFO_FLY_MODEL_FINDME
    
}BASE_INFO_MODEL_TYPE;


typedef enum{
    
   BASE_INFO_FLY_MODEL_TYPE_OVERGROUND,//地上
   BASE_INFO_FLY_MODEL_TYPE_SKY,//天上
   BASE_INFO_FLY_MODEL_TYPE_UnKnow //未知
    
}BASE_INFO_FLY_MODEL_TYPE;


@interface StatusBaseInfoModel : NSObject


/**
 *  姿态
 */
@property (nonatomic,strong) NSArray * att;
/**
 *  速度
 */
@property (nonatomic,strong) NSArray * vel;
/**
 *  位置
 */
@property (nonatomic,strong) NSArray * pos;

/**
 *  状态
 */
@property (nonatomic,assign) BASE_INFO_STATUS_TYPE  status;
/**
 *  模式（做过处理）
 */
@property (nonatomic,assign) BASE_INFO_FLY_MODEL_TYPE  mode;

/**
 *  模式（原始）
 */
@property (nonatomic,assign) NSInteger  flyMode;

/**
 *  电量
 */
@property (nonatomic,assign) int8_t  capacity;
/**
 *  电压
 */
@property (nonatomic,assign) int8_t  Voltage;
/**
 *  是否充电
 */
@property (nonatomic,assign) BOOL  charge;
/**
 *  是否高温检测
 */
@property (nonatomic,assign) BOOL  temp;
/**
 *  是否解锁
 */
@property (nonatomic,assign) BOOL  armed;

@end
