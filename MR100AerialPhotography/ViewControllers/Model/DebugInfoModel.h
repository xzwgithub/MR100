//
//  DebugInfoModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/21.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DebugInfoModel : NSObject
/**
 *  cpu使用率
 */
@property (nonatomic,assign) NSInteger  cpuUseRate;
/**
 *  可用内存
 */
@property (nonatomic,copy) NSString*  unUsedMemory;
/**
 *  飞机模式
 */
@property (nonatomic,copy) NSString * flyMode;
/**
 *  飞机高度
 */
@property (nonatomic,assign) float flyHeight;
/**
 *  起飞时长
 */
@property (nonatomic,assign) long flyTime;


@end
