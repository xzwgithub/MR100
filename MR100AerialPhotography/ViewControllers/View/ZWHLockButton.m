//
//  ZWHLockButton.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/14.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHLockButton.h"

@implementation ZWHLockButton

- (void)setHighlighted:(BOOL)highlighted{}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGRect rect;
    if (kIsIpad) {
        rect = CGRectMake(contentRect.size.width / 2 - 19, contentRect.size.height - 40, 38, 38);
    }
    else {
        rect = CGRectMake(contentRect.size.width / 2 - 11, contentRect.size.height - 26, 22, 25);
    }
    return rect;
}

- (void)drawRect:(CGRect)rect {
    
    if (kIsIpad) {
        UIImage *image = [UIImage imageNamed:@"Lower-echelon-ipad"];
        [image drawInRect:CGRectMake(5.5, rect.size.height - 42, 222.5, 42)];
    }
    else {
        UIImage *image = [UIImage imageNamed:@"Lower-echelon"];
        [image drawInRect:CGRectMake(0, rect.size.height - 28, rect.size.width, 28)];
    }
}
@end
