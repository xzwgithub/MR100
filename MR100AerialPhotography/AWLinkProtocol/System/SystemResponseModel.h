//
//  SystemResponseModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemResponseModel : NSObject

/**
 *  ack为对应项目的执行结果，0:成功 1:失败
 */
@property (nonatomic,assign) boolean_t isSuccess;
/**
 *  item_id 为对应项目的主项编号
 */
@property (nonatomic,assign) int8_t item_id;
/**
 *  subitem_id为对应项目的子项编号
 */
@property (nonatomic,assign) int8_t  subitem_id;


@end
