//
//  SystemInfoModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemInfoModel : NSObject

/**
 *  evel为信息等级(0:ERR 1:INFO)
 */
@property (nonatomic,assign) int8_t  level;

/**
 *  data为信息内容,长度可变,最大为64
 */
@property (nonatomic,strong) NSArray * data;

@end
