//
//  Decoder.h
//  H264Demo
//
//  Created by luo雨思 on 16/10/27.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGQCAEAGLLayer.h"
typedef void (^CollectImageComplete)(NSArray<UIImage *> *arrImg);
@interface Decoder : NSObject

@property(nonatomic,strong)PGQCAEAGLLayer *showLayer;
@property(atomic,assign) NSInteger takePhotosNum;
-(void)clearH264Deocder;
-(void) decodeNalu:(uint8_t *)frame withSize:(uint32_t)frameSize;
- (void)gotSpsPps:(uint8_t*)sps pps:(uint8_t*)pps SpsSize:(int)spsSize PpsSize:(int)ppsSize;
- (void)startShareAndCollectImageDataWithBlock:(CollectImageComplete)block;
- (void)closeShare;
@end
