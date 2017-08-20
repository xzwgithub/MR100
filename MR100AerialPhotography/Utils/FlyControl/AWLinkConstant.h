//
//  AWLinkConstant.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#ifndef AWLinkConstant_h
#define AWLinkConstant_h


#endif /* AWLinkConstant_h */

//注册lingPian通知
#define kNotice_lingPian   @"Notice_lingPian"

//acc校准控制
#define kNotice_correct_acc  @"Notice_correct_acc"

//acc校准进度
#define kProgress_correct_acc @"kProgress_correct_acc"

//360本地旋转
#define kNotice360   @"kNotice360"

//紧急降落
#define kEmergency   @"kEmergency"

//一键起飞
#define ktakeoff   @"ktakeoff"

//一键降落
#define kland   @"kland"

//获取基本信息和状态信息
#define kbaseInfoAndStatus   @"kbaseInfoAndStatus"

//停止获取基本信息定时器
#define kstopBaseInfoTimer   @"kstopBaseInfoTimer"

#define kUpdateUI @"kUpdateUI"



/**
 * 室内起飞悬停高度(单位为米)
 */
#define  TAKE_OFF_HOVER_HEIGHT_INDOOR  1
/**
 * 室外起飞悬停高度(单位为米)
 */
#define  TAKE_OFF_HOVER_HEIGHT_OUTDOOR  1
/**
 * 定位精度(单位为米)
 */
#define  FOLLOW_ME_POSITION_ACCURACY  1
/**
 * 跟踪距离(单位为米)
 */
#define FOLLOW_ME_FOLLOW_RANGE  3

/**
 * 电量不足以飞行
 */
#define CAPACITY_LOW_FOR_FLY  10

/**
 * 电量不足以录像，此值应小于CAPACITY_LOW_FOR_FLY
 */
#define CAPACITY_LOW_FOR_RECORD  10
/**
 * roll最小值
 */
#define ROLL_MIN_VALUE   -1000 
/**
 * roll最大值
 */
#define ROLL_MAX_VALUE  1000
/**
 * pitch最小值
 */
#define PITCH_MIN_VALUE  -1000
/**
 * pitch最大值
 */
#define PITCH_MAX_VALUE  1000
/**
 * yaw最小值
 */
#define  YAW_MIN_VALUE  -1000
/**
 * yaw最大值
 */
#define  YAW_MAX_VALUE  1000
/**
 * throttle最小值
 */
#define THROTTLE_MIN_VALUE  -1000
/**
 * throttle最大值
 */
#define THROTTLE_MAX_VALUE  1000

/**
 * 获取基础信息的频率【单位：赫兹】
 */
#define  RATE_OF_GET_BASIC_INFO  10
/**
 * 获取GPS信息的频率【单位：赫兹】
 */
#define  RATE_OF_GET_GPS_INFO   10
/**
 * 获取光流信息的频率【单位：赫兹】
 */
#define RATE_OF_GET_OPTICAL_FLOW_INFO  10
/**
 * 获取传感器信息的频率【单位：赫兹】
 */
#define RATE_OF_GET_SENSOR_INFO  10
/**
 * 获取传感器校准信息的频率【单位：赫兹】
 */
#define RATE_OF_GET_SENSOR_CHECK_INFO   10

/**
 * 摇杆控制发送间隔时间【单位：毫秒】
 */
#define REMOTE_SENSE_SEND_INTERVAL  10

/**
 * 摇杆控制发送间隔时间【单位：毫秒】
 */
#define ZERO_OFFSET_DEFAULT_VALUE  64




//主项编号
typedef enum{
    
    ITEM_ID_SYSTEM = 1,//系统配置
    ITEM_ID_STATUS,//飞行器状态
    ITEM_ID_CONTROL,//飞行器控制
    ITEM_ID_MISSION,//航点管理
    ITEM_ID_PARAMETER,//参数管理
    
}ITEM_ID_TYPE;


//主项0号对应的子项编号
typedef enum{

    ITEM_ID_SYSTEM_SUBITEM_ID_RESPONSE = 0,//应答
    ITEM_ID_SYSTEM_SUBITEM_ID_AWLINK_VERSION,//AWLINK版本号
    ITEM_ID_SYSTEM_SUBITEM_ID_AWPILOT_VERSION,//AWPILOT版本号
    ITEM_ID_SYSTEM_SUBITEM_ID_HEARTBIT,//心跳
    ITEM_ID_SYSTEM_SUBITEM_ID_INFO,//信息


}ITEM_ID_SYSTEM_SUBITEM_ID_TYPE;


//主项1号对应的子项编号
typedef enum{
    
    ITEM_ID_SYSTEM_SUBITEM_ID_BASE_INFO = 0,//基本信息
    ITEM_ID_SYSTEM_SUBITEM_ID_GPS_INFO,//GPS信息
    ITEM_ID_SYSTEM_SUBITEM_ID_OPTICAL_FLOW_INFO,//光流信息
    ITEM_ID_SYSTEM_SUBITEM_ID_SENSOR_STAUS,//传感器状态
    ITEM_ID_SYSTEM_SUBITEM_ID_SENSOR_CHECK_STAUS,//传感器校准状态
    
    
}ITEM_ID_STATUS_SUBITEM_ID_TYPE;

//主项2号对应的子项编号
typedef enum{
    
    ITEM_ID_CONTROL_SUBITEM_ID_REMOTE_SENSE = 0,//摇杆控制
    ITEM_ID_CONTROL_SUBITEM_ID_STATUS_INFO,//状态信息控制
    ITEM_ID_CONTROL_SUBITEM_ID_CHECK,//校准控制
    ITEM_ID_CONTROL_SUBITEM_ID_MODE,//模式控制
    ITEM_ID_CONTROL_SUBITEM_ID_FOLLOWME,//followMe控制
    ITEM_ID_CONTROL_SUBITEM_ID_OFFSET,//零偏控制
    
}ITEM_ID_CONTROL_SUBITEM_ID_TYPE;

//主项3号对应的子项编号
typedef enum{
    
    ITEM_ID_MISSION_SUBITEM_ID_CLEAR_TASK = 0,//清除任务
    ITEM_ID_MISSION_SUBITEM_ID_GET_TASK,//获取任务
    ITEM_ID_MISSION_SUBITEM_ID_TASK,//任务
    
}ITEM_ID_MISSION_SUBITEM_ID_TYPE;


//主项4号对应的子项编号
typedef enum{
    
    ITEM_ID_PARAMETER_SUBITEM_ID_RESET_PARAMETER = 0,//重置参数
    ITEM_ID_PARAMETER_SUBITEM_ID_GET_PARAMETER,//获取参数
    ITEM_ID_PARAMETER_SUBITEM_ID_PARAMETER,//参数
    ITEM_ID_PARAMETER_SUBITEM_ID_STOREGE_PARAMETER,//存储参数
    
}ITEM_ID_PARAMETER_SUBITEM_ID_TYPE;


//type(0:acc,1:mag,2:姿态)
typedef enum{
    
    ControlCorrectTypeAcc = 0,  //acc
    ControlCorrectTypeMag,   //mag
    ControlCorrectTypeZiTai    //姿态

} ControlCorrectType;


//command(0:开始校准,1:中止校准)
typedef enum{
    
    ControlCorrectCommandStart,//开始校准
    ControlCorrectCommandStop   //中止校准

} ControlCorrectCommand;






