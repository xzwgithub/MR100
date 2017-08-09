//
//  ZWHCaptionView.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/11/14.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CancelBlock)(void);
typedef void(^IssueBlock)(NSString *description);
@interface ZWHCaptionView : UIView
+(instancetype)viewWithPlatformTitle:(NSString *)title image:(UIImage *)image cancelCallBack:(CancelBlock)blo1 issueCallBack:(IssueBlock)blo2;
@end
