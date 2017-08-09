//
//  CorrectControlModel.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/1.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWLinkConstant.h"

@interface CorrectControlModel : NSObject

/**
 *  type(0:acc,1:mag,2:姿态)
 */
@property (nonatomic,assign) ControlCorrectType  type;
/**
 *  command(0:开始校准,1:中止校准)
 */
@property (nonatomic,assign) ControlCorrectCommand  command;

@end
