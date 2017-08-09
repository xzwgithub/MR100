//
//  FTPManager.h
//  DVDemo
//
//  Created by luo雨思 on 16/7/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^ResultBlock)(BOOL success);

@interface FTPManager : NSObject
/** 文件传输结果的block */
@property(copy,nonatomic)ResultBlock resultBlock;

-(void)startSendFirmware:(NSString *)filePath;

@end
