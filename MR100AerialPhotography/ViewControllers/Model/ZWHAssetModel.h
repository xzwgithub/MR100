//
//  ZWHAssetModel.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/8.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZWHAssetModel : NSObject

@property(nonatomic, assign) BOOL selected;          //选中按钮的状态

@property(nonatomic, assign) BOOL btnHidden;          //选中按钮是否隐藏

@property(nonatomic, strong) PHAsset *asset;          // 照片或视频

@property (nonatomic, strong) UIImage *thumbnailImage; //缩略图

@property (nonatomic, copy) NSString *representedAssetIdentifier;
@end
