//
//  ZWHPlayerViewController.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/12/6.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayerItem;
@interface ZWHPlayerViewController : UIViewController
- (instancetype)initWithPlayItem:(AVPlayerItem *)item;
@end
