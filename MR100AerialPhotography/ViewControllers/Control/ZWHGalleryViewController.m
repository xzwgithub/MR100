//
//  ZWHGalleryViewController.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/7.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHGalleryViewController.h"
#import "ZWHAssetCell.h"
#import "ZWHVideoCell.h"
#import "Masonry.h"
#import "UICollectionView+Convenience.h"
#import "AAPLAssetViewController.h"

@import PhotosUI;
static NSString * const PhotoReuseIdentifier = @"Photo";
static NSString * const VideoReuseIdentifier = @"Video";
@interface ZWHGalleryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>

@property(nonatomic, weak) UIView *topBarView;          //上部导航栏

@property(nonatomic, weak) UICollectionView *collectionView;          //瀑布流视图

@property(nonatomic, strong) NSMutableArray<ZWHAssetModel *> *assetArr;     //资源数组模型
@property(nonatomic, strong) PHFetchResult *assetsFetchResults;             //获取的系统相册的资源

@property(nonatomic, weak) UIButton *removeBtn;//删除按钮
@property(nonatomic, weak) UIButton *shareBtn; //分享按钮
@property(nonatomic, weak) UIButton *cancelBtn;//取消按钮
@property(nonatomic, assign) NSInteger index;          //记录响应长按手势的那个cell的下标
@property(nonatomic, strong) AAPLAssetViewController *assetVC;          //

@property (nonatomic, strong) PHCachingImageManager *imageManager;//图片缓存管理器
@property(nonatomic, assign) CGRect previousPreheatRect;          //

@end

@implementation ZWHGalleryViewController
static CGSize AssetGridThumbnailSize;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self collectionView];
    [self assetsFetchResults];
    [self imageManager];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (PHFetchResult *)assetsFetchResults {

    if (_assetsFetchResults == nil) {
        _assetsFetchResults = [[FZJPhotoTool sharedFZJPhotoTool] getAssetsInCustomeAssetCollection];
    }
    return _assetsFetchResults;
}

- (PHCachingImageManager *)imageManager {
    
    if (_imageManager == nil) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (void)dealloc {
    [_assetArr removeAllObjects];
    _assetArr = nil;
    self.assetsFetchResults = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor lightGrayColor];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cellSize = ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).itemSize;
    AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
    if (kIsIpad) {
        [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cancelBtn.mas_left).with.offset(-75);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topBarView.mas_left).with.offset(75 + 75);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topBarView).with.offset(-10);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(75, 75));
        }];
    }
    else {
        [self.removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cancelBtn.mas_left).with.offset(-kGalleryTopBtnGap);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topBarView.mas_left).with.offset(kGalleryTopBtnGap + 60);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topBarView).with.offset(-10);
            make.centerY.equalTo(self.topBarView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assetArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWHAssetModel *model = self.assetArr[indexPath.row];
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
        
        ZWHAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoReuseIdentifier forIndexPath:indexPath];
        model.representedAssetIdentifier = model.asset.localIdentifier;
        
        [self.imageManager requestImageForAsset:model.asset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      
                                      // Set the cell's thumbnail image if it's still showing the same asset.
                                      if ([model.representedAssetIdentifier isEqualToString:model.asset.localIdentifier]) {
                                          model.thumbnailImage = result;
                                      }
                                  }];

        for (id obj in cell.gestureRecognizers) {
            
            if ([obj isKindOfClass:[UILongPressGestureRecognizer class]]) {
                cell.model = model;
                return cell;
            }
        }
    
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        longPress.minimumPressDuration = 1;
        cell.contentView.tag = indexPath.row;
        [cell.contentView addGestureRecognizer:longPress];
        
        cell.model = model;
        
        return cell;
    }
    
    ZWHVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoReuseIdentifier forIndexPath:indexPath];
    model.representedAssetIdentifier = model.asset.localIdentifier;
    
    [self.imageManager requestImageForAsset:model.asset
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:nil
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  // Set the cell's thumbnail image if it's still showing the same asset.
                                  if ([model.representedAssetIdentifier isEqualToString:model.asset.localIdentifier]) {
                                      model.thumbnailImage = result;
                                  }
                              }];
    

    for (id obj in cell.gestureRecognizers) {
        
        if ([obj isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [cell.contentView removeGestureRecognizer:obj];
        }
    }
    cell.contentView.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [cell.contentView addGestureRecognizer:longPress];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZWHAssetModel *model = [self.assetArr objectAtIndex:indexPath.item];
    if (model.btnHidden == NO) {
        model.selected = !model.selected;
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        return;
    }
    if (_assetVC != nil) {
        return;
    }

    self.assetVC.assetCollection = [[FZJPhotoTool sharedFZJPhotoTool] createdCollection];
    self.assetVC.assets = self.assetArr;
    self.assetVC.model = model;
    
    __weak typeof(self) weakSelf = self;
    self.assetVC.block = ^ {
        weakSelf.assetVC = nil;
    };
    
    [UIView animateWithDuration:0.5 animations:^{
        self.assetVC.view.transform = CGAffineTransformScale(self.view.transform, 1, 1);
    }];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)ges {
    
    self.shareBtn.hidden = NO;
    self.cancelBtn.hidden = NO;
    self.removeBtn.hidden = NO;
    
    if (ges.state == UIGestureRecognizerStateEnded) {
        [self.assetArr enumerateObjectsUsingBlock:^(ZWHAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            obj.btnHidden = NO;
            obj.selected = NO;
            if (idx == ges.view.tag) {
                obj.selected = YES;
            }
        }];
        [self.collectionView reloadData];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        [self.assetArr removeAllObjects];
        _assetArr = nil;
        
        [self.collectionView reloadData];
    
        [self resetCachedAssets];
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        
        UICollectionView *view = nil;
        if (kIsIpad) {
            UICollectionViewFlowLayout *flowLay = [[UICollectionViewFlowLayout alloc] init];
            flowLay.minimumLineSpacing = 15;
            flowLay.minimumInteritemSpacing = 15;
            flowLay.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
            flowLay.itemSize = CGSizeMake((kWidth - 85)/4, (kWidth - 85)*kHeight/4/kWidth);
            view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 75, kWidth, kHeight - 75) collectionViewLayout:flowLay];
        }
        else {
            UICollectionViewFlowLayout *flowLay = [[UICollectionViewFlowLayout alloc] init];
            flowLay.minimumLineSpacing = 10;
            flowLay.minimumInteritemSpacing = 10;
            flowLay.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
            flowLay.itemSize = CGSizeMake((kWidth - 60)/4, (kWidth - 60)*kHeight/4/kWidth);
            view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50) collectionViewLayout:flowLay];
        }
        
        view.backgroundColor = [UIColor lightGrayColor];
        view.delegate = self;
        view.dataSource = self;
        [view registerClass:[ZWHAssetCell class] forCellWithReuseIdentifier:PhotoReuseIdentifier];
        [view registerClass:[ZWHVideoCell class] forCellWithReuseIdentifier:VideoReuseIdentifier];
        [self.view addSubview:view];
        _collectionView = view;
    }
    return _collectionView;
}

- (UIView *)topBarView {
    
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UIImageView *setImaView = [[UIImageView alloc] init];
        setImaView.contentMode = UIViewContentModeCenter;
        [view addSubview:setImaView];
        
        [self.view addSubview:view];
        if (kIsIpad) {
            view.frame = CGRectMake(0, 0, kWidth, 75);
            [btn setImage:[UIImage imageNamed:@"jt-ipad"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 75, 75);
            setImaView.image = [UIImage imageNamed:@"picture-ipad"];
            setImaView.frame = CGRectMake(kWidth / 2 - 37.5, 0, 75, 75);
        }
        else {
            view.frame = CGRectMake(0, 0, kWidth, 50);
            [btn setImage:[UIImage imageNamed:@"jt-0"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(0, 0, 50, 50);
            setImaView.image = [UIImage imageNamed:@"picture"];
            setImaView.frame = CGRectMake(kWidth / 2 - 25, 0, 50, 50);
        }
        
        _topBarView = view;
    }
    return _topBarView;
}

- (NSMutableArray<ZWHAssetModel *> *)assetArr {
    if (_assetArr == nil) {
        _assetArr = [NSMutableArray new];
#warning 直接从系统相册获取的数组是逆序排的，先把它正过来
        
        NSMutableArray *arr = [NSMutableArray array];
        [self.assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject:obj];
        }];
        NSArray *arrResult = [self reverseAssetArr:arr];
        [arrResult enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZWHAssetModel *model = [[ZWHAssetModel alloc] init];
            model.asset = obj;
            model.btnHidden = YES;
            model.selected = NO;
            [_assetArr addObject:model];
        }];
    }
    return _assetArr;
}

- (NSArray<PHAsset *> *)reverseAssetArr:(NSArray *)array {
    
    NSMutableArray *arrM = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < arrM.count/2.0; i++) {
        
        [arrM exchangeObjectAtIndex:i withObjectAtIndex:arrM.count-1-i];
    }
    return arrM;
}

//删除按钮
- (UIButton *)removeBtn {
    if (_removeBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"bucket-ipad"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"bucket"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(removeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _removeBtn = btn;
    }
    return _removeBtn;
}

- (void)removeBtnClickAction:(UIButton *)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *arrIndex = [NSMutableArray array];
    [self.assetArr enumerateObjectsUsingBlock:^(ZWHAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.selected == YES) {
            
            [arr addObject:obj.asset.localIdentifier];
            [arrIndex addObject:[NSNumber numberWithUnsignedInteger:idx]];
        }
    }];
    
    [[FZJPhotoTool sharedFZJPhotoTool] removeVideoOrPhotoAtIndexs:arr resultBlock:^(NSError *error) {
        if (error) {//删除失败
            [self.assetArr enumerateObjectsUsingBlock:^(ZWHAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                obj.btnHidden = YES;
                obj.selected = NO;
            }];
            [self.collectionView reloadData];
        }
        
        self.cancelBtn.hidden = YES;
        self.removeBtn.hidden = YES;
        self.shareBtn.hidden = YES;
    }];
}

//分享按钮
- (UIButton *)shareBtn {
    if (_shareBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"Forward-ipad"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"Forward"] forState:UIControlStateNormal];
        }
       
        [btn addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _shareBtn = btn;
    }
    return _shareBtn;
}

- (void)shareBtnClickAction:(UIButton *)sender {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"resources in processing, please later...", @"资源处理中，请稍后...") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:nil];

    
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *indexArr = [NSMutableArray array];
    
    dispatch_queue_t queue = dispatch_queue_create("GetData", DISPATCH_QUEUE_CONCURRENT);
    //选出选中的资源
    dispatch_apply(self.assetArr.count, queue, ^(size_t index) {
        ZWHAssetModel *model = self.assetArr[index];
        if (model.selected == YES) {
            [indexArr addObject:model];
        }
    });
    
    //处理选中的资源，得到URL
    dispatch_barrier_async(queue, ^{
        [indexArr enumerateObjectsUsingBlock:^(ZWHAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [FZJPhotoTool getDataFromPHAsset:obj.asset Complete:^(NSURL *url) {
                [arr addObject:url];
                if (arr.count == indexArr.count) {
                    //处理完毕，得到所有的URL
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:^{
                            UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:arr applicationActivities:nil];
                            vc.completionWithItemsHandler = ^(NSString *__nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
                                
                                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                                    //清除缓存
                                    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                    for (NSString *fileName in enumerator) {
                                        [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                    }
                                });
                            };
                            if (kIsIpad) {
                                UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
                                [popover presentPopoverFromRect:CGRectMake(20, 100, 0, 337) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                            }
                            else {
                                [self presentViewController:vc animated:YES completion:nil];
                            }
                            
                        }];
                    });
                }
            }];
        }];
    });
}

//取消按钮
- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        if (kIsIpad) {
            [btn setImage:[UIImage imageNamed:@"withdraw-ipad"] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[UIImage imageNamed:@"withdraw"] forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(cancelBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topBarView addSubview:btn];
        
        _cancelBtn = btn;
    }
    return _cancelBtn;
}

- (void)cancelBtnClickAction:(UIButton *)sender {
    
    [self.assetArr enumerateObjectsUsingBlock:^(ZWHAssetModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.btnHidden = YES;
        obj.selected = NO;
    }];
    
    [self.collectionView reloadData];
    self.cancelBtn.hidden = YES;
    self.removeBtn.hidden = YES;
    self.shareBtn.hidden = YES;
}

- (AAPLAssetViewController *)assetVC {
    if (_assetVC == nil) {
        _assetVC = [[AAPLAssetViewController alloc] init];
        [self addChildViewController:_assetVC];
        [self.view addSubview:_assetVC.view];
    }
    return _assetVC;
}

@end
