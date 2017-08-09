/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A view controller displaying an asset full screen.
 */

@import UIKit;
@import Photos;
@class ZWHAssetModel;
typedef void(^SelfRempveFromSuperViewBlock)(void);
@interface AAPLAssetViewController : UIViewController

@property(nonatomic, strong) ZWHAssetModel *model;          //
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property(nonatomic, strong) NSArray<ZWHAssetModel *> *assets;     //资源数组模型
@property(nonatomic, copy) SelfRempveFromSuperViewBlock block;          //

@end
