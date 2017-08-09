//
//  ZWHModifyPasswordViewController.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ModifiedWifiNameAndPasswordBlock)(NSString *wifiName,NSString *wifiPassword);
@interface ZWHModifyPasswordViewController : UIViewController

@property(nonatomic, copy) ModifiedWifiNameAndPasswordBlock block;          //

@property(nonatomic, strong) NSString *userName;          //
@end
