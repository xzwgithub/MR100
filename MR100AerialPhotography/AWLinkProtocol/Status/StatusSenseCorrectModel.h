//
//  StatusSenseCorrectModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ACC @"acc"
#define MAG @"mag"

@interface StatusSenseCorrectModel : NSObject

/**
 *  加速度 (0-100表示校准进度,100为完成)
 */
@property (nonatomic,assign) uint8_t  acc;
/**
 *  罗盘 (0-100表示校准进度,100为完成)
 */
@property (nonatomic,assign) uint8_t  mag;

@end
