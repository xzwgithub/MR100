//
//  UIFont+MyFontSize.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/19.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "UIFont+MyFontSize.h"

@implementation UIFont (MyFontSize)

+ (UIFont *)fontSizeWithOriginSize:(NSInteger)size fontName:(NSString *)name{
    
    if ([UIScreen mainScreen].bounds.size.height == 320 || [UIScreen mainScreen].bounds.size.width == 320) {
        return [UIFont fontWithName:name size:size - 2];
    }
    
    else if ([UIScreen mainScreen].bounds.size.height == 375 || [UIScreen mainScreen].bounds.size.width == 375) {
        return [UIFont fontWithName:name size:size];
    }
    
    return [UIFont fontWithName:name size:size + 2];
}
@end
