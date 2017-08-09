//
//  ZWHFlashLedButton.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/20.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZWHFlashLedButtonState) {
    ZWHFlashLedButtonStateOpen,
    ZWHFlashLedButtonStateClose,
    ZWHFlashLedButtonStateAuto
};

typedef void(^LightButtonBlock)(ZWHFlashLedButtonState state);
@interface ZWHFlashLedButton : UIView

@property(nonatomic, copy) LightButtonBlock block;          //内部按钮点击事件的回调
-(void)setFlashImgWithState:(unsigned int)tag;
@end
