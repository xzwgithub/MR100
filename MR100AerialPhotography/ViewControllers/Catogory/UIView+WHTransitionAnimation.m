//
//  UIView+WHTransitionAnimation.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/23.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "UIView+WHTransitionAnimation.h"

@implementation UIView (WHTransitionAnimation)

- (void)setAnimationWithType:(AnimationType)animation
                    duration:(float)durationTime
            directionSubtype:(Direction)subtype
{
    //CATransition实体
    CATransition* ani=[CATransition animation];
    //动画时间:
    ani.duration = durationTime;
    //选择动画过渡方向:
    switch (subtype) {
        case WHleft:
            ani.subtype = kCATransitionFromLeft;
            break;
        case WHright:
            ani.subtype = kCATransitionFromRight;
            break;
        case WHtop:
            ani.subtype = kCATransitionFromTop;
            break;
        case WHbottom:
            ani.subtype = kCATransitionFromBottom;
            break;
        case WHmiddle:
            ani.subtype = kCATruncationMiddle;
            break;
        default:
            break;
    }
    //选择动画效果：
    switch (animation)
    {
        case WHpageCurl:
        {
            ani.type = @"pageCurl";
        }
            break;
        case WHpageUnCurl:
        {
            ani.type = @"pageUnCurl";
        }
            break;
        case WHrippleEffect:
        {
            ani.type = @"rippleEffect";
        }
            break;
        case WHsuckEffect:
        {
            ani.type = @"suckEffect";
        }
            break;
        case WHcube:
        {
            ani.type = @"cube";
        }
            break;
        case WHcameraIrisHollowOpen:
        {
            ani.type = @"cameraIrisHollowOpen";
        }
            break;
        case WHoglFlip:
        {
            ani.type = @"oglFlip";
        }
            break;
        case WHcameraIrisHollowClose:
        {
            ani.type = @"cameraIrisHollowClose";
        }
            break;
        case WHmovein:
            ani.type = kCATransitionMoveIn;
            break;
        case WHpush:
            ani.type = kCATransitionPush;
            break;
        case WHfade:
            ani.type = kCATransitionFade;
            break;
        default:
            break;
    }
    //动画加到图层上
    [self.layer addAnimation:ani forKey:nil];
}
@end
