//
//  StatusOpticalFlowModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatusOpticalFlowModel : NSObject
/**
 *  位置
 */
@property (nonatomic,strong) NSArray * pos;
/**
 *  速度
 */
@property (nonatomic,strong) NSArray * vel;
/**
 *  质量
 */
@property (nonatomic,assign) int8_t  quality;

@end
