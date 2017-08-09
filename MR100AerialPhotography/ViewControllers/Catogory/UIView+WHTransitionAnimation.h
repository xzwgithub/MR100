//
//  UIView+WHTransitionAnimation.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/23.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画类型
 */
typedef enum{
    
    WHpageCurl,               // 向上翻一页
    WHpageUnCurl,              //向下翻一页
    WHrippleEffect,            //波纹
    WHsuckEffect,              //吸收
    WHcube,                    //立方体
    WHoglFlip,                 //翻转
    WHcameraIrisHollowOpen,    //镜头开
    WHcameraIrisHollowClose,   //镜头关
    WHfade,                    //翻页
    WHmovein,                  //弹出
    WHpush                     //推出
    
}AnimationType;

/**
 *  动画方向
 */
typedef enum{
    WHleft,                 //左
    WHright,                //右
    WHtop,                  //顶部
    WHbottom,               //底部
    WHmiddle
    
}Direction;

@interface UIView (WHTransitionAnimation)

/**
 *  动画设置
 *
 *  @param animation    动画
 *  @param durationTime 动画时间
 *  @param subtype      过渡方向
 */
- (void)setAnimationWithType:(AnimationType)animation
                    duration:(float)durationTime
            directionSubtype:(Direction)subtype;

@end
