//
//  CameraSyncSetting.h
//  DVDemo
//
//  Created by luo雨思 on 16/7/14.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CameraSyncSetting : NSObject

+(CameraSyncSetting *)cameraSetting;

//恢复出厂设置
- (void)reset;

-(void)sync:(NSDictionary *)param;

@property(atomic,strong)NSMutableDictionary *cardCapcity;  //卡容量 freeSpace  usedSpace   totalSpace

@property(atomic,assign)MENU_LIST_VID_REC_RESOLUTION_SET_ITEM_IDX resolution; //分辨率

@property(atomic,assign)MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX white_balance; //白平衡

@property(atomic,assign)MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX expousure;  //曝光

@property(atomic,strong)NSString *version; //固件版本softVersion

@property(atomic,strong)NSMutableDictionary *WifiInfo;

@property(atomic,assign)M_CTS cts;  //对比度

@property(atomic,assign)BRIGHTNESS brightness;  //明亮度

@property(atomic,assign)FLASH_STATE flash_state;

@property(atomic,assign)BOOL isCharging; // 充电状态 1充电中

@end
