//
//  ModeControlModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModeControlModel : NSObject

/**
 * 
 0:Stabilize:自稳
 1:althold:定高
 2:poshold:定点
 3:takeoff:一键起飞（详见模式控制）
 4:land:降落
 5:followme:跟随
 6:auto:航点
 7:circle:热点环绕
 8:flip:空翻
 9:RTL:返航
 10:STOP:停止
 11:LOCAL360:本地旋转
 12:Findme: param1为手机罗盘的角度
 */
@property (nonatomic,assign) int8_t  model;
/**
 *  为各模式的参数,空则传0
 */
@property (nonatomic,assign) float  param1;
/**
 *  为各模式的参数,空则传0
 */
@property (nonatomic,assign) float  param2;


@end
