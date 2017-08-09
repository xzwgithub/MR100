//
//  ZWHSdView.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWHSdView : UIView
@property(atomic,assign,readonly)int memoQuantity;//内存信息要求为0到100的整数
- (void)setMemoQuantity:(NSInteger)memoQuantity Out:(int)state;
@end
