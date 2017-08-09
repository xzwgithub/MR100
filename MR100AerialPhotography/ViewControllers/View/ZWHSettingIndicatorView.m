//
//  ZWHSettingIndicatorView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/3.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHSettingIndicatorView.h"

@implementation ZWHSettingIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //1.获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.3] set];
    CGMutablePathRef path=CGPathCreateMutable();
    
    if (kIsIpad) {
        CGFloat w = rect.size.width;
        CGFloat t = 25;
        //2.2把绘图信息添加到路径里
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, w, 0);
        CGPathAddLineToPoint(path, NULL, w - t, 45);
        CGPathAddLineToPoint(path, NULL, t, 45);
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }
    else {
        CGFloat w = rect.size.width;
        CGFloat t = 15;
        //2.2把绘图信息添加到路径里
        CGPathMoveToPoint(path, NULL, 0, 0);
        CGPathAddLineToPoint(path, NULL, w, 0);
        CGPathAddLineToPoint(path, NULL, w - t, 30);
        CGPathAddLineToPoint(path, NULL, t, 30);
        CGPathAddLineToPoint(path, NULL, 0, 0);
    }
    
    //2.3把路径添加到上下文中
    //把绘制直线的绘图信息保存到图形上下文中
    CGContextAddPath(ctx, path);
    //3.渲染
    CGContextFillPath(ctx);
    //4.释放路径
    CGPathRelease(path);
}

@end
