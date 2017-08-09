//
//  ZWHAssetCell.h
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/7.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZJPhotoTool.h"
#import "ZWHAssetModel.h"

@interface ZWHAssetCell : UICollectionViewCell

@property(nonatomic, strong) ZWHAssetModel *model;

@property(nonatomic, strong) UIImageView *imageView;          //

@end
