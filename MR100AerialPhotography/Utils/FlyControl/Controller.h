//
//  Controller.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/23.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWLinkHelper.h"

@interface Controller : NSObject
//@property(atomic,assign)Boolean onekeyfly;  //一键起飞
//@property(atomic,assign)Boolean onekeyland;  //降落
//@property(atomic,assign)Boolean emergency;  //紧急停止
@property(atomic,assign)int16_t youmen;            //-1000-1000
@property(atomic,assign)int16_t fangxiang;    //偏航，方向舵                   // -1000 - 1000
@property(atomic,assign)int16_t fuyi;                            // -1000 - 1000
@property(atomic,assign)int16_t shengjiang;                      // -1000 - 1000
@property(atomic,assign)float_t fuyilingpian;                    // 默认0，加减0.1
@property(atomic,assign)float_t shengjianglingpian;// 默认0，加减0.1

//控制器

//@property(atomic,assign)int8_t fuyi;                            // -127 - 127
//@property(atomic,assign)int8_t shengjiang;                      // -127 - 127
//@property(atomic,assign)int16_t youmen;            //-1000-1000             // 0 - 255 平时置中间
//@property(atomic,assign)int8_t fangxiang;                       // -127 - 127
//@property(atomic,assign)int8_t fuyilingpian;                    // 0 - 64 - 127
//@property(atomic,assign)int8_t shengjianglingpian;              // 0 - 64 - 127
@property(atomic,assign)Boolean flyModel;  //0表示关闭室内模式，1表示打开室内模式
-(void)takeoffAction;
-(void)landAction;

-(void)reserveBitControl;
-(void)followMe_action:(BOOL)state;
-(void)emergency_action;
-(void)circle360_action:(BOOL)state;
-(void)magXAdapt_action;
-(void)magYAdapt_action;

//开始acc校准
-(void)accAdapt_action;
//-(FlyControlModeTye )getControlMessage;
@end
