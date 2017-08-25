/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 A view controller displaying an asset full screen.
 */

#import "AAPLAssetViewController.h"
#import "FZJPhotoTool.h"
#import "ZWHAssetModel.h"
#import "UIView+WHTransitionAnimation.h"
#import "ZWHPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AAPLAssetViewController ()
{
    boolean_t _isClickPicture;
}
@property(nonatomic, weak) UIView *topBarView;        //上部导航栏
@property(nonatomic, weak) UILabel *titleLable;       //资源名称
@property(nonatomic, weak) UIImageView *imageViewCurr;//资源图片
@property(nonatomic, weak) UIButton *playBtn;         //播放按钮
@property(nonatomic, strong) UIPanGestureRecognizer *pan;       //加在view上的拖动手势，非播放界面有效

@property (nonatomic,strong) UITapGestureRecognizer * tap;
@property(nonatomic, assign) NSUInteger index;          //当前资源在数组的下标

@property (nonatomic, assign) CGSize lastTargetSize;
@property (nonatomic, strong) PHAsset *asset;
//@property(nonatomic, assign) BOOL canPresent;                 //
@property(nonatomic, strong) NSMutableArray *assetArrM;          //

@end

@implementation AAPLAssetViewController

#pragma mark - View Lifecycle Methods.

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.transform = CGAffineTransformScale(self.view.transform, 0, 0);
    self.view.backgroundColor = kLightGrayColor;
    [self topBarView];
    [self imageViewCurr];
    [self playBtn];
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [self.view addGestureRecognizer:_pan];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_model.asset.mediaType == PHAssetMediaTypeImage) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNav:)];
        [self.view addGestureRecognizer:_tap];
        
    }

}

- (void)dealloc {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)setModel:(ZWHAssetModel *)model {
    _model = model;
    self.asset = model.asset;
    self.index = [self.assetArrM indexOfObject:model];
    self.titleLable.text = [self getOriFileNameFromModel:self.model];
    if (model.asset.mediaType == PHAssetMediaTypeImage) {
        self.playBtn.hidden = YES;
        [self updateImage];
    }
    
    else if (model.asset.mediaType == PHAssetMediaTypeVideo) {
        self.playBtn.hidden = NO;
        [self updateImage];
        
    }
}

- (void)setAssets:(NSArray<ZWHAssetModel *> *)assets {
    
    _assets = assets;
    self.assetArrM = [[NSMutableArray alloc] initWithArray:assets];
}

- (UIView *)topBarView {
    if (_topBarView == nil) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor darkGrayColor];
        
        UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnBack addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnBack];
        
        UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnShare addTarget:self action:@selector(shareBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btnShare];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(handleTrashButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = kWhiteColor;
        lb.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lb];
        _titleLable = lb;

        [self.view addSubview:view];
        if (kIsIpad) {
            view.frame = CGRectMake(0, 0, kWidth, 75);
            [btnBack setImage:[UIImage imageNamed:@"jt-ipad"] forState:UIControlStateNormal];
            btnBack.frame = CGRectMake(0, 0, 75, 75);
            btnShare.frame = CGRectMake(kWidth - 225, 0, 75, 75);
            [btnShare setImage:[UIImage imageNamed:@"Forward-ipad"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(kWidth - 85, 0, 75, 75);
            [btn setImage:[UIImage imageNamed:@"bucket-ipad"] forState:UIControlStateNormal];
            lb.frame = CGRectMake(kWidth / 2 - 150, 0, 300, 75);
            lb.font = FontSize(19);
        }
        else {
            view.frame = CGRectMake(0, 0, kWidth, 50);
            [btnBack setImage:[UIImage imageNamed:@"jt-0"] forState:UIControlStateNormal];
            btnBack.frame = CGRectMake(0, 0, 50, 50);
            btnShare.frame = CGRectMake(kWidth - 130, 0, 50, 50);
            [btnShare setImage:[UIImage imageNamed:@"Forward"] forState:UIControlStateNormal];
            btn.frame = CGRectMake(kWidth - 60, 0, 50, 50);
            [btn setImage:[UIImage imageNamed:@"bucket"] forState:UIControlStateNormal];
            lb.frame = CGRectMake(kWidth / 2 - 100, 0, 200, 50);
            lb.font = FontSize(15);
        }
        
        _topBarView = view;
    }
    return _topBarView;
}

- (UIImageView *)imageViewCurr {
    
    if (_imageViewCurr == nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        [self.view  addSubview:imgView];
        [self.view sendSubviewToBack:imgView];
        imgView.userInteractionEnabled = YES;
        _imageViewCurr = imgView;
    }
    return _imageViewCurr;
}

- (UIButton *)playBtn {

    if (_playBtn == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.hidden = YES;
        [btn setImage:ImageNamed(@"play") forState:UIControlStateNormal];
        btn.bounds = CGRectMake(0, 0, 50, 50);
        btn.center = self.imageViewCurr.center;
        [btn addTarget:self action:@selector(handlePlayButtonItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [self.view bringSubviewToFront:btn];
        
        _playBtn = btn;
    }
    return _playBtn;
}

- (void)backAction {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (self.block) {
        self.block();
    }
}

- (void)shareBtnClickAction:(UIButton *)sender {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"resources in processing, please later...",@"资源处理中，请稍后") message:nil preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:controller animated:YES completion:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FZJPhotoTool getDataFromPHAsset:self.asset Complete:^(NSURL *url) {
            //处理完毕，得到所有的URL
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
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
                        [popover presentPopoverFromRect:CGRectMake(kWidth - 500, 100, 0, 337) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    }
                    else {
                        [self presentViewController:vc animated:YES completion:nil];
                    }
                }];
            });
        }];
    });
    
}

//删除按钮
- (void)handleTrashButtonItem:(id)sender {
    
    [[FZJPhotoTool sharedFZJPhotoTool] removeVideoOrPhotoAtIndexs:@[self.asset.localIdentifier] resultBlock:^(NSError *error) {
        
        if (error == nil) {
            ZWHAssetModel *model;
            if (self.index == (self.assetArrM.count-1)) {
                [self.assetArrM removeObjectAtIndex:_index];
                model = [self.assetArrM lastObject];
                if (model == nil) {
                    [self backAction];
                    return;
                }
                self.model = model;
                
                return;
            }
            
            [self.assetArrM removeObjectAtIndex:_index];
            
            model = [self.assetArrM objectAtIndex:_index];
            if (model == nil) {
                [self backAction];
                return;
            }
            
            self.model = model;
            
        }
    }];
}

-(void)hideNav:(UITapGestureRecognizer*)tap
{
    _isClickPicture = !_isClickPicture;
    self.topBarView.hidden = _isClickPicture;
}


- (void)panAction:(UIPanGestureRecognizer *)ges {
    
    if (ges.state == UIGestureRecognizerStateBegan) {
        
    }
    else if (ges.state == UIGestureRecognizerStateEnded){
    
        CGPoint pEnd = [ges translationInView:self.imageViewCurr];
        
        //右滑，显示前一张图片
        if (pEnd.x > 20) {
            self.index--;
            if (self.index == -1) {
                self.index = self.assetArrM.count - 1;
            }
            ZWHAssetModel *model = [self.assetArrM objectAtIndex:self.index];
            self.model = model;
            [self.imageViewCurr setAnimationWithType:WHpush duration:0.5 directionSubtype:WHleft];
        }
        //左滑，显示后一张图片
        else if (pEnd.x < -20){
            self.index++;
            if (self.index == self.assetArrM.count) {
                self.index = 0;
            }
            ZWHAssetModel *model = [self.assetArrM objectAtIndex:self.index];
            self.model = model;
            [self.imageViewCurr setAnimationWithType:WHpush duration:0.5 directionSubtype:WHright];

        }
    }
}

//播放按钮
- (void)handlePlayButtonItem:(id)sender {
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:self.asset options:nil resultHandler:^(AVAsset *avAsset, AVAudioMix *audioMix, NSDictionary *info) {
        
        ZWHPlayerViewController *videoVC = [[ZWHPlayerViewController alloc] initWithPlayItem:[AVPlayerItem playerItemWithAsset:avAsset]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoVC];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
//    if (self.canPresent) {
//        self.canPresent = NO;
//            }
}

- (NSString *)getOriFileNameFromModel:(ZWHAssetModel *)model {
    if (model == nil) {
        return nil;
    }
    PHAssetResource *resource = [[PHAssetResource assetResourcesForAsset:model.asset] firstObject];
    
    return resource.originalFilename;
}

#pragma mark - ImageView/LivePhotoView Image Setting methods.

- (CGSize)targetSize {
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize targetSize = CGSizeMake(CGRectGetWidth(self.imageViewCurr.bounds) * scale, CGRectGetHeight(self.imageViewCurr.bounds) * scale);
    return targetSize;
}

- (void)updateImage {
    self.lastTargetSize = [self targetSize];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = YES;
    
    [[PHImageManager defaultManager] requestImageForAsset:self.asset targetSize:[self targetSize] contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {

        if (!result) {
            return;
        }
        self.imageViewCurr.image = result;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

};

@end
