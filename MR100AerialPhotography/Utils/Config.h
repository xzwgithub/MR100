//
//  Config.h
//  DVF_iOS
//
//  Created by luo雨思 on 16/6/29.
//  Copyright © 2016年 RP. All rights reserved.
//

#ifndef Config_h
#define Config_h


#endif /* Config_h */

/*!
 * 所有接口的枚举
 */
typedef enum{
    
    //client->server： CMD_REQ_XXX
    CMD_REQ_WIFI_DISPATCHER_SYS_PARAM_GET= 0,
    CMD_REQ_STATE_SET,          /********** 页面状态更改设置 1*********/
    CMD_REQ_VID_ENC_PREVIEW_ON,     /********** 图传开启接口 2*********/
    CMD_REQ_VID_ENC_PREVIEW_OFF,    /********** 图传关闭接口 3*********/
    CMD_REQ_VID_ENC_START,          /********** 录像开启 4*********/
    CMD_REQ_VID_ENC_STOP,           /********** 录像关闭 5*********/
    CMD_REQ_VID_ENC_PAUSE,          /********** 录像暂停6（预留） *********/
    CMD_REQ_VID_ENC_RESUME,         /********** 录像恢复 7(预留)*********/
    
    CMD_REQ_VID_ENC_DURATION_SET,   /********** 录像视频时长设置 8*********/
    CMD_REQ_VID_ENC_TIME_LAPSE_SET, /********** 缩时录影 9*********/
    CMD_REQ_VID_ENC_SLOW_SET,       /********** 慢摄影(预留) 10*********/
    
    CMD_REQ_VID_ENC_CAPTURE,        /********** 拍照 11*********/
    CMD_REQ_AUD_ENC_VOLUME_SET, /********** 拍照声音(预留) 12*********/
    
    CMD_REQ_VID_ENC_CAPTURE_TIMER_SHOT_SET,/********** 定时拍照 13*********/
    CMD_REQ_VID_ENC_CAPTURE_AUTO_SHOT_SET,/********** 自动拍照 14*********/
    CMD_REQ_VID_ENC_CAPTURE_SPORT_ORBIT_SHOT_SET,/********** 运动轨迹拍照 15*********/
    
    CMD_REQ_RESOLUTION_SET,/********** 分辨率设置 16*********/
    CMD_REQ_AUTO_AWB_SET,/********** 自动白平衡 17*********/
    CMD_REQ_AE_SET,/********** 自动曝光设置 18*********/
    CMD_REQ_AG_SET,/********** 自动增益(预留) 19*********/
    CMD_REQ_HUE_SET,/********** 色彩设置(预留) 20*********/
    CMD_REQ_SATURATION_SET,/********** 饱和度(预留) 21*********/
    CMD_REQ_BRIGHTNESS_SET,/********** 亮度(预留) 22*********/
    CMD_REQ_CONTRAST_SET,/********** 对比度(预留) 23*********/
    CMD_REQ_SHAPNESS_SET,/********** 锐利度(预留) 24*********/
    CMD_REQ_ISO_SET,/********** 感光度(预留) 25*********/
    CMD_REQ_FLIP_SET,/********** 翻转(预留) 26*********/
    CMD_REQ_AUTO_FOCUS_SET,/********** 自动聚焦(预留) 27*********/
    CMD_REQ_FRM_RATE_SET,/********** 帧率(预留) 28*********/
    
    CMD_REQ_DATE_TIME_SET,/********** 日期时间 29*********/
    CMD_REQ_GSENSOR_SET,/********** 重力感应灵敏度(预留) 30*********/
    CMD_REQ_TIME_WATER_MARK_SET,/********** 时间水印 31*********/
    CMD_REQ_LED_IND_SET,/********** LED指示灯(预留) 32*********/
    CMD_REQ_LIGHT_FREQ_SET,/********** 光源频率 33*********/
    CMD_REQ_SCREEN_FLIP_SET,/********** 图像旋转 34*********/
    CMD_REQ_VEHICLE_MODE_SET,/********** 车载模式(预留) 35*********/
    CMD_REQ_AUTO_PWR_OFF_SET,/********** 自动关机时间设置 36*********/
    CMD_REQ_AUTO_SCREEN_SAVER_SET,/********** 自动屏保时间设置 37*********/
    
    CMD_REQ_FACTORY_RESTORE_SET,/********** 恢复出厂设置 38*********/
    CMD_REQ_FIRMWARE_VERSION_GET,/********** 固件版本 39*********/
    CMD_REQ_PWR_OFF,/********** 手动关机 40*********/
    
    CMD_REQ_DISP_JPG_THUMB_LIST_DEC,/********** 显示图片缩略图列表 41*********/
    CMD_REQ_DISP_JPG,/********** 全景预览图片 42*********/
    CMD_REQ_DISP_VID_THUMB_LIST_DEC,/********** 显示视频缩略图列表 43*********/
    
    CMD_REQ_VID_DEC_START,/********** 全景播放视频 44*********/
    CMD_REQ_VID_DEC_STOP,/********** 停止全景播放视频 45*********/
    CMD_REQ_VID_DEC_PAUSE,/********** 暂停全景播放视频 46*********/
    CMD_REQ_VID_DEC_RESUME,/********** 恢复全景播放视频 47*********/
    CMD_REQ_VID_DEC_SEEK,/********** 跳播全景播放视频(预留) 48*********/
    
    CMD_REQ_AUD_DEC_START,/********** 播放声音(预留) 49*********/
    CMD_REQ_AUD_DEC_STOP,/********** 停止播放声音(预留) 50*********/
    CMD_REQ_AUD_DEC_PAUSE,/********** 暂停播放声音(预留) 51*********/
    CMD_REQ_AUD_DEC_RESUME,/********** 恢复播放声音(预留) 52*********/
    CMD_REQ_AUD_DEC_VOLUME_SET,/********** 播放音量开关(预留) 53*********/
    CMD_REQ_AUD_DEC_FF,/********** 音频快进(预留) 54*********/
    CMD_REQ_AUD_DEC_FB,/********** 音频快退(预留) 55*********/
    
    CMD_REQ_DEL_FILE,/********** 删除文件列表 56*********/
    CMD_REQ_DEL_ALL_FILE,/********** 删除所有文件 57*********/
    CMD_REQ_LOCK_FILE,/********** 加锁文件列表 58*********/
    CMD_REQ_LOCK_ALL_FILE,/********** 加锁所有文件 59*********/
    CMD_REQ_UNLOCK_FILE,/********** 解锁文件列表 60*********/
    CMD_REQ_UNLOCK_ALL_FILE,/********** 解锁所有文件 61*********/
    CMD_REQ_FORMAT,/********** 格式化 62*********/
    CMD_REQ_CARD_INFO_GET,/********** 获取卡容量信息 63*********/
    
    CMD_REQ_MANUAL_LOCK, //64  手动加锁视频  (没用，暂留)
    
    CMD_REQ_RECORDING_TIME_GET,   //65录制时长请求
    CMD_REQ_PLAYING_TIME_GET,     //66在线播放时长请求
    CMD_REQ_NET_DISCONN,    //67断开设备连接
    
    CMD_REQ_WIFI_DISPATCHER_NET_SSID,  //68
    CMD_REQ_WIFI_DISPATCHER_NET_PASSWORD,  //69
    CMD_REQ_WIFI_DISPATCHER_ENC_CAPTURE_SET_NUM,//连拍 70
    CMD_REQ_WIFI_DISPATCHER_FIRMWARE_UPDATE,//更新固件  71
    CMD_REQ_WIFI_DISPATCHER_X_Y_UPDATE,   //图像跟踪  72
}SEQ_CMD;


typedef enum {
    //server->client：CMD_CFM_XXX
    
    CMD_CFM_WIFI_DISPATCHER_SYS_PARAM_GET = 0,
    CMD_CFM_STATE_SET,          /********** 页面状态更改设置 *********/
    CMD_CFM_VID_ENC_PREVIEW_ON,     /********** 图传开启接口 *********/
    CMD_CFM_VID_ENC_PREVIEW_OFF,    /********** 图传关闭接口 *********/
    CMD_CFM_VID_ENC_START,          /********** 录像开启 *********/
    CMD_CFM_VID_ENC_STOP,           /********** 录像关闭 *********/
    CMD_CFM_VID_ENC_PAUSE,          /********** 录像暂停（预留） *********/
    CMD_CFM_VID_ENC_RESUME,         /********** 录像恢复 (预留)*********/
    
    CMD_CFM_VID_ENC_DURATION_SET,   /********** 录像视频时长设置 *********/
    CMD_CFM_VID_ENC_TIME_LAPSE_SET, /********** 缩时录影 *********/
    CMD_CFM_VID_ENC_SLOW_SET,       /********** 慢摄影(预留) *********/
    
    CMD_CFM_VID_ENC_CAPTURE,        /********** 拍照 *********/
    CMD_CFM_AUD_ENC_VOLUME_SET, /********** 拍照声音(预留) *********/
    
    CMD_CFM_VID_ENC_CAPTURE_TIMER_SHOT_SET,/********** 定时拍照 *********/
    CMD_CFM_VID_ENC_CAPTURE_AUTO_SHOT_SET,/********** 自动拍照 *********/
    CMD_CFM_VID_ENC_CAPTURE_SPORT_ORBIT_SHOT_SET,/********** 运动轨迹拍照 *********/
    
    CMD_CFM_RESOLUTION_SET,/********** 分辨率设置 *********/
    CMD_CFM_AUTO_AWB_SET,/********** 自动白平衡 *********/
    CMD_CFM_AE_SET,/********** 自动曝光设置 *********/
    CMD_CFM_AG_SET,/********** 自动增益(预留) *********/
    CMD_CFM_HUE_SET,/********** 色彩设置(预留) *********/
    CMD_CFM_SATURATION_SET,/********** 饱和度(预留) *********/
    CMD_CFM_BRIGHTNESS_SET,/********** 亮度(预留) *********/
    CMD_CFM_CONTRAST_SET,/********** 对比度(预留) *********/
    CMD_CFM_SHAPNESS_SET,/********** 锐利度(预留) *********/
    CMD_CFM_ISO_SET,/********** 感光度(预留) *********/
    CMD_CFM_FLIP_SET,/********** 翻转(预留) *********/
    CMD_CFM_AUTO_FOCUS_SET,/********** 自动聚焦(预留) *********/
    CMD_CFM_FRM_RATE_SET,/********** 帧率(预留) *********/
    
    CMD_CFM_DATE_TIME_SET,/********** 日期时间 *********/
    CMD_CFM_GSENSOR_SET,/********** 重力感应灵敏度(预留) *********/
    CMD_CFM_TIME_WATER_MARK_SET,/********** 时间水印 *********/
    CMD_CFM_LED_IND_SET,/********** LED指示灯(预留) *********/
    CMD_CFM_LIGHT_FREQ_SET,/********** 光源频率 *********/
    CMD_CFM_SCREEN_FLIP_SET,/********** 图像旋转 *********/
    CMD_CFM_VEHICLE_MODE_SET,/********** 车载模式(预留) *********/
    CMD_CFM_AUTO_PWR_OFF_SET,/********** 自动关机时间设置 *********/
    CMD_CFM_AUTO_SCREEN_SAVER_SET,/********** 自动屏保时间设置 *********/
    
    CMD_CFM_FACTORY_RESTORE_SET,/********** 恢复出厂设置 *********/
    CMD_CFM_FIRMWARE_VERSION_GET,/********** 固件版本 *********/
    CMD_CFM_PWR_OFF,/********** 手动关机 *********/
    
    CMD_CFM_DISP_JPG_THUMB_LIST_DEC,/********** 显示图片缩略图列表 *********/
    CMD_CFM_DISP_JPG,/********** 全景预览图片 *********/
    CMD_CFM_DISP_VID_THUMB_LIST_DEC,/********** 显示视频缩略图列表 *********/
    
    CMD_CFM_VID_DEC_START,/********** 全景播放视频 *********/
    CMD_CFM_VID_DEC_STOP,/********** 停止全景播放视频 *********/
    CMD_CFM_VID_DEC_PAUSE,/********** 暂停全景播放视频 *********/
    CMD_CFM_VID_DEC_RESUME,/********** 恢复全景播放视频 *********/
    CMD_CFM_VID_DEC_SEEK,/********** 跳播全景播放视频(预留) *********/
    
    CMD_CFM_AUD_DEC_START,/********** 播放声音(预留) *********/
    CMD_CFM_AUD_DEC_STOP,/********** 停止播放声音(预留) *********/
    CMD_CFM_AUD_DEC_PAUSE,/********** 暂停播放声音(预留) *********/
    CMD_CFM_AUD_DEC_RESUME,/********** 恢复播放声音(预留) *********/
    CMD_CFM_AUD_DEC_VOLUME_SET,/********** 播放音量开关(预留) *********/
    CMD_CFM_AUD_DEC_FF,/********** 音频快进(预留) *********/
    CMD_CFM_AUD_DEC_FB,/********** 音频快退(预留) *********/
    
    CMD_CFM_DEL_FILE,/********** 删除文件列表 *********/
    CMD_CFM_DEL_ALL_FILE,/********** 删除所有文件 *********/
    CMD_CFM_LOCK_FILE,/********** 加锁文件列表 *********/
    CMD_CFM_LOCK_ALL_FILE,/********** 加锁所有文件 *********/
    CMD_CFM_UNLOCK_FILE,/********** 解锁文件列表 *********/
    CMD_CFM_UNLOCK_ALL_FILE,/********** 解锁所有文件 *********/
    CMD_CFM_FORMAT,/********** 格式化 *********/
    CMD_CFM_CARD_INFO_GET,/********** 获取卡容量信息 *********/
    
    CMD_CFM_MANUAL_LOCK,
    CMD_CFM_SCREEN_SAVER_ON,
    CMD_CFM_RECORDING_TIME_GET,
    CMD_CFM_PLAYING_TIME_GET,
    
    CMD_CFM_WIFI_DISPATCHER_NET_SSID,
    CMD_CFM_WIFI_DISPATCHER_NET_PASSWORD,
    CMD_CFM_WIFI_DISPATCHER_ENC_CAPTURE_SET_NUM,
    CMD_CFM_WIFI_DISPATCHER_FIRMWARE_UPDATE,//更新固件  71
    CMD_CFM_WIFI_DISPATCHER_X_Y_UPDATE,  //图像跟踪
    
    CMD_CFM_MAX,
    
    CMD_IND_WIFI_DISPATCHER_SD_STS_UPDATE,        //卡插拔状态  0代表拔出
    CMD_IND_WIFI_DISPATCHER_CARD_NEED_FORMAT,     //提示卡需要格式化
    CMD_IND_WIFI_DISPATCHER_COLLISION_LOCK,       //g-sensor碰撞加锁
    CMD_IND_WIFI_DISPATCHER_VID_DEC_CMPL          //在线视频播放完成

    
}CFM_CMD;

//参数枚举选项 ----- 参考，开发完后去掉
/*
typedef enum {
    // Video Recording Set Menu List
    MENU_LIST_VID_REC_SET_ITEM_IDX_RESOLUTION,
    MENU_LIST_VID_REC_SET_ITEM_IDX_DURATION,
    MENU_LIST_VID_REC_SET_ITEM_IDX_TIME_LAPSE, //缩时录影
    MENU_LIST_VID_REC_SET_ITEM_IDX_SLOW,    //慢摄影
    MENU_LIST_VID_REC_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_VID_ENC_SET_ITEM_IDX;
 */



typedef enum {
    // Video Time-Lapse Recording Menu List
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_OFF,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_1_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_2_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_5_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_10_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_30_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_60_SEC,
    MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX_MAX,
}MENU_LIST_VID_REC_TIME_LAPSE_SET_ITEM_IDX; //缩时录影

typedef enum {
    // Capture Timer Set Menu List
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_OFF,
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_3_SEC,
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_5_SEC,
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_10_SEC,
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_20_SEC,
    MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_CAPTURE_TIMER_SET_ITEM_IDX;  //定时拍照

typedef enum {
    // Capture Auto Set Menu List
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_OFF,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_3_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_10_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_15_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_20_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_30_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_60_SEC,
    MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_CAPTURE_AUTO_SET_ITEM_IDX; //自动拍照间隔时长


typedef enum {
    // Capture Sport Orbit Set Menu List
    MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX_OFF,
    MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX_3_TIMES,
    MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX_5_TIMES,
    MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX_10_TIMES,
    MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_CAPTURE_SPORT_ORBIT_SET_ITEM_IDX; //运动轨迹拍照间隔


typedef enum {
    // Video Recording Resolution Menu List
    MENU_LIST_VID_REC_DURATION_SET_ITEM_IDX_10_SEC,
    MENU_LIST_VID_REC_DURATION_SET_ITEM_IDX_30_SEC,
    MENU_LIST_VID_REC_DURATION_SET_ITEM_IDX_60_SEC,
    MENU_LIST_VID_REC_DURATION_SET_ITEM_IDX_MAX,
}MENU_LIST_VID_REC_DURATION_SET_ITEM_IDX; //录制时长

typedef enum {
    // Video Recording Resolution Menu List
    MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX_720P_30FPS,
    MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX_XGA_30FPS,
    MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX_VGA_60FPS,
    MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX_QVGA_120FPS,
    MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX_MAX,
}MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX;  //分辨率设置


typedef enum {
    // LCD FLIP
    IMAGE_FLIP_MODE_OFF,
    IMAGE_FLIP_MODE_ON,
    IMAGE_FLIP_MODE_MAX,
}IMAGE_FLIP_MODE;  //图片旋转

typedef enum {
    // Date Time Water Mark Disp off
    DATE_TIME_WATER_MARK_NO = 0,
    DATE_TIME_WATER_MARK_YES,
    DATE_TIME_WATER_MARK_MAX,
}DATE_TIME_WATER_MARK;//时间水印


typedef enum {
    STS_WIFI_OFF,
    STS_WIFI_ON,
    STS_WIFI_MAX,
}STS_WIFI;  //wifi开关

typedef enum {
    // System White BALANCE Set Menu List
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_AUTO,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_SUNNY,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_OVERCAST,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_DAYNIGHT,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_INCANDESCENCE,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_FLUORESCENCE,
    MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_MAX,
}MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX; //白平衡


typedef enum {
    // System EXPOSURE Set Menu List
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_NEGATIVE_1 = -4,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_NEGATIVE_2,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_NEGATIVE_3,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_NEGATIVE_4,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_0,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_POSITIVE_4,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_POSITIVE_3,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_POSITIVE_2,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_POSITIVE_1,
    MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_MAX,
}MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX;  //曝光


typedef enum {
    // System Light Frequency Set Menu List
    MENU_LIST_SYS_SET_LIGHT_FREQ_ITEM_IDX_AUTO,
    MENU_LIST_SYS_SET_LIGHT_FREQ_ITEM_IDX_50_HZ,
    MENU_LIST_SYS_SET_LIGHT_FREQ_ITEM_IDX_60_HZ,
    MENU_LIST_SYS_SET_LIGHT_FREQ_ITEM_IDX_MAX,
}MENU_LIST_SYS_SET_LIGHT_FREQ_ITEM_IDX;  //光源频率

typedef enum {
    // System Light Frequency Set Menu List
    M_CTS_0 = -4,
    M_CTS_1,
    M_CTS_2,
    M_CTS_3,
    M_CTS_4,
    M_CTS_5,
    M_CTS_6,
    M_CTS_7,
    M_CTS_8,
}M_CTS;  //对比度

typedef enum {
    // System Light Frequency Set Menu List
    BRIGHTNESS_0 = -4,
    BRIGHTNESS_1,
    BRIGHTNESS_2,
    BRIGHTNESS_3,
    BRIGHTNESS_4,
    BRIGHTNESS_5,
    BRIGHTNESS_6,
    BRIGHTNESS_7,
    BRIGHTNESS_8,
}BRIGHTNESS;  //明亮度

typedef enum {
    // System Light Frequency Set Menu List
    FLASH_STATE_CLOSED = 0,
    FLASH_STATE_OPEN,
    FLASH_STATE_AUTO,
}FLASH_STATE;  //flash灯状态

typedef enum {
    // System Auto Power Off Set Menu List
    MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX_1_MININUTE,
    MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX_3_MININUTE,
    MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX_5_MININUTE,
    MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX_OFF,
    MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX_MAX,
}MENU_LIST_SYS_SET_AUTO_PWR_OFF_ITEM_IDX; //自动关机关机时间设置


typedef enum {
    // System Auto Screen Saver Set Menu List
    MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX_10_SEC,
    MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX_20_SEC,
    MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX_30_SEC,
    MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX_OFF,
    MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX_MAX,
}MENU_LIST_SYS_SET_AUTO_SCREEN_SAVER_ITEM_IDX;  //自动屏保

//拍照
/*
typedef enum {
    // Capture Set Menu List
    MENU_LIST_CAPTURE_SET_ITEM_IDX_PIXEL_SET,
    MENU_LIST_CAPTURE_SET_ITEM_IDX_TIMER_SHOT, //定时
    MENU_LIST_CAPTURE_SET_ITEM_IDX_AUTO_SHOT,  //自动周期性拍照
    MENU_LIST_CAPTURE_SET_ITEM_IDX_SPORT_ORBIT_SHOT,//运动轨迹拍照
    MENU_LIST_CAPTURE_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_CAPTURE_SET_ITEM_IDX;
 */

typedef enum {
    // Capture Pixel Set Menu List
    MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX_2M,
    MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX_5M,
    MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX_8M,
    MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX_12M,
    MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX_ID_MAX,
}MENU_LIST_CAPTURE_PIXEL_SET_ITEM_IDX; //拍照像素设置 (运动DV不需要)

typedef enum {
    // Video Slow Recording Menu List
    MENU_LIST_VID_REC_SLOW_SET_ITEM_IDX_OFF,
    MENU_LIST_VID_REC_SLOW_SET_ITEM_IDX_VGA_60FPS,
    MENU_LIST_VID_REC_SLOW_SET_ITEM_IDX_QVGA_120FPS,
    MENU_LIST_VID_REC_SLOW_SET_ITEM_IDX_MAX,
}MENU_LIST_VID_REC_SLOW_SET_ITEM_IDX; //慢摄影   （暂留，运动DV不需要）


typedef enum{
    WIFI_MGR_STATE_CAMCORDER,
    WIFI_MGR_STATE_FILE_MANAGE,    
}WIFI_MGR_STATE; //所在页面状态



typedef struct {
    unsigned int m_freeSpace;
    unsigned int m_usedSpace;
    unsigned int m_totalSpace;
}CARD_CAPCITY;  //卡容量


typedef enum{
    FileTypePic,
    FileTypeVid,
    FileTypeIni
}FileType;  //文件类型

typedef enum{
    SUCCESS,
    FAILED,
    TIMEOUT,
    BUSY,
    MSG_RESPONSE_RESULT_PARAM_ERROR, //参数错误，如播放视频时，参数类型错误等
    MSG_RESPONSE_RESULT_SD_LESS_SPACE, //暂不会上报
    MSG_RESPONSE_RESULT_SD_FULL_SPACE, //SD卡满
    MSG_RESPONSE_RESULT_SD_IS_PLUG_OUT, //SD卡没插或拔出
    MSG_RESPONSE_RESULT_NO_FILE, //文件管理中没有文件
}CFM_RESULT;  //返回结果

