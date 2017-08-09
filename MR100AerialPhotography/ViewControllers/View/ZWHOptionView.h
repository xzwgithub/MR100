//
//  ZWHOptionView.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/1.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WhiteBgButtonDidClick)(NSInteger index);
typedef void(^GrayBgButtonDidClick)(BOOL hidden);

typedef NS_ENUM(NSInteger,ZWHOptionViewPlatformType) {
    ZWHOptionViewPlatformTypeShare1,
    ZWHOptionViewPlatformTypeShare2
};

@interface ZWHOptionView : UIView

- (instancetype)initWithFrame:(CGRect)frame andButtonImageName:(NSString *)imageName dropDownListTitleArray:(NSArray<NSString *> *)titleArr platformType:(ZWHOptionViewPlatformType)type;

- (void)handleClickEventsWhiteBlock:(WhiteBgButtonDidClick)whiteBlock andGrayBlock:(GrayBgButtonDidClick)grayBlock;

- (void)refresh;

@end
