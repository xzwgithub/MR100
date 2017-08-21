//
//  ZWDebugInfoView.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/21.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DebugInfoModel;
@interface ZWDebugInfoView : UIView

/**
 *  调试信息
 */
@property (nonatomic,strong) DebugInfoModel * debugInfo;

+(instancetype)creatDebugInfoView;

@end
