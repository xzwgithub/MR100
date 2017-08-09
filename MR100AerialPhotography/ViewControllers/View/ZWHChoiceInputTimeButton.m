//
//  ZWHChoiceInputTimeButton.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHChoiceInputTimeButton.h"

@implementation ZWHChoiceInputTimeButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width;
    CGFloat h = contentRect.size.height;

    return CGRectMake(0, h / 2, w, h / 2);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat w = contentRect.size.width;
    if (kIsIpad) {
        return CGRectMake(w*0.5 - 14, 10, 28, 28);
    }
    else {
        return CGRectMake(w*0.5 - 10, 5, 20, 20);
    }
}
@end
