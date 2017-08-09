//
//  ZWHBatteryView.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWHBatteryView : UIView

@property(atomic, assign) NSInteger elecQuantity;          //电量信息要求为0到100的整数
@property(atomic, assign) BOOL isCharging;
@end
