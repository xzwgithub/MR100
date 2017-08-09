//
//  ZWHButton.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/1.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHButton.h"

@implementation ZWHButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    if (kIsIpad) {
        return CGRectMake(10 + kIpadCellHeight * 0.8 + 10, 0, contentRect.size.width - 10 + kIpadCellHeight * 0.8 + 10 - 10, kIpadCellHeight);
    }
    else {
        return CGRectMake(10 + kSettingCellHeight * 0.8 + 10, 0, contentRect.size.width - 10 + kSettingCellHeight * 0.8 + 10 - 10, kSettingCellHeight);
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if (kIsIpad) {
        return CGRectMake(10, kIpadCellHeight * 0.2, kIpadCellHeight * 0.6, kIpadCellHeight * 0.6);
    }
    else {
        return CGRectMake(10, kSettingCellHeight * 0.2, kSettingCellHeight * 0.6, kSettingCellHeight * 0.6);
    }
}

- (void)setHighlighted:(BOOL)highlighted {

}

@end
