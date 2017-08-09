//
//  FlyControlModel.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/24.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlyControlModel : NSObject


@property(nonatomic,assign)uint8_t voltage;  //(uint8_t  0~200	乘5以后对应0~10.00V)
@property(nonatomic,assign)BOOL voltage_state;
@property(nonatomic,assign)uint8_t signal_num;
@property(nonatomic,assign)uint8_t error_state;
@property(nonatomic,assign)BOOL circle_state;
@property(nonatomic,assign)uint8_t calibration_process;

@end
