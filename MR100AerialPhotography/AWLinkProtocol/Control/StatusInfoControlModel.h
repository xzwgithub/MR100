//
//  StatusInfoControlModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusInfoControlModel : NSObject

/**
 *  sub_id为主项编号1（status）中的子项编号
 */
@property (nonatomic,assign) int8_t  sub_id;

/**
 *  用于控制状态信息的发送频率 rate为频率,20代表发送频率为20Hz
 */
@property (nonatomic,assign) int8_t  rate;


@end
