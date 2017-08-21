//
//  AWTools.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/21.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWTools : NSObject

//当前设备可用内存(单位：MB)
+(double)availableMemory;

//cpu占有率
+(float)cpu_usage;

@end
