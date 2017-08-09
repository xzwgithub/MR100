//
//  CameraSyncSetting.m
//  DVDemo
//
//  Created by luo雨思 on 16/7/14.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "CameraSyncSetting.h"
@implementation CameraSyncSetting

+(CameraSyncSetting *)cameraSetting
{
    static CameraSyncSetting *cameraSetting = nil;
    if (!cameraSetting) {
        cameraSetting = [[CameraSyncSetting alloc] init];
    }
    return cameraSetting;
}

- (void)reset {
    _white_balance = MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX_AUTO;
    _cts = M_CTS_0;
    _expousure = MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX_0;
    _brightness = BRIGHTNESS_4;
}

-(void)sync:(NSDictionary *)param
{
    //卡容量
    _cardCapcity = [[NSMutableDictionary alloc] initWithDictionary:[param objectForKey:@"M_CARD"]];
    
    //白平衡
    int whiteBalance = [[[NSString alloc] initWithFormat:@"%@",[param objectForKey:@"M_AWB"]] intValue];
    _white_balance = (MENU_LIST_SYS_SET_WHITE_BALANCE_ITEM_IDX)whiteBalance;
    
    //曝光
    int expose = [[[NSString alloc] initWithFormat:@"%@",[param objectForKey:@"M_AE"]] intValue];
    _expousure = (MENU_LIST_SYS_SET_EXPOSURE_ITEM_IDX)expose;
    
    //固件版本
    _version = [param objectForKey:@"FirmWare"];
    
    //wifi信息
    _WifiInfo = [param objectForKey:@"Wifi_Param"];
    
    //对比度
    _cts = (M_CTS) [[param objectForKey:@"M_CTS"] intValue];
    
    //明亮度
    _brightness = (BRIGHTNESS) [[param objectForKey:@"M_BHT"] intValue];
    
    //flash灯状态
    _flash_state = (FLASH_STATE) [[param objectForKey:@"M_LED_MODE"] intValue];
    
    //充电状态
    _isCharging = [[param objectForKey:@"M_BATTERY"] intValue];
}

@end
