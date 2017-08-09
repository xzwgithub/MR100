//
//  HeartBitModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemHeartBitModel : NSObject
/**
 *  heart为序列号,不连贯表示丢包
 */
@property (nonatomic,assign) int8_t  heart;

@end
