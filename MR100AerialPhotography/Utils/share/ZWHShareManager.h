//
//  ZWHShareManager.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/11/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZWHShareManager : NSObject
singleton_interface(ZWHShareManager)

-(void)shareImageForOneWithImageArr:(NSArray<UIImage *> *)arr;
-(void)shareVideoForOneWithFilePath:(NSString *)path thubImage:(UIImage *)image;

-(void)shareImageForTwoWithImageArr:(NSArray<UIImage *> *)arr;
-(void)shareVideoForTwoWithFilePath:(NSString *)path thubImage:(UIImage *)image;

@end
