//
//  ZWHShareManager.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/11/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHShareManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterKit/TwitterKit.h>
#import "ZWHCaptionView.h"
#import "SocialVideoHelper.h"
#import "ViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "GTLRYouTube.h"

typedef void(^GoogleShareFinishedBlock)(void);
@interface ZWHShareManager ()<GPPSignInDelegate,GPPShareDelegate,FBSDKSharingDelegate>

@property(nonatomic, strong) GPPSignIn *manager;//
@property (nonatomic, readonly) GTLRYouTubeService *youTubeService;
@property(nonatomic, strong) GoogleShareFinishedBlock block;          //
@end

@implementation ZWHShareManager
singleton_implementation(ZWHShareManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [GPPSignIn sharedInstance] ;
        self.manager.delegate = self;
    }
    return self;
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {

    self.youTubeService.authorizer = auth;
}

- (GTLRYouTubeService *)youTubeService {
    static GTLRYouTubeService *service;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[GTLRYouTubeService alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them.
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically.
        service.retryEnabled = YES;
    });
    return service;
}

#pragma mark - 分享一   
/*
    ZWHShareCaptionModeNever = 1 << 0,
    ZWHShareCaptionModeAfter = 1 << 1,
    ZWHShareCaptionModeBefore = 1 << 2,

    ZWHSharePlatformFacebook = 1 << 4,
    ZWHSharePlatformTwitter = 1 << 5,
    ZWHSharePlatformGoolePlus = 1 << 6,
    ZWHSharePlatformYoutube = 1 << 7,
*/

- (void)shareImageForOneWithImageArr:(NSArray<UIImage *> *)arr {

    NSInteger index = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
    NSInteger index1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
    
    switch (index) {
        case ZWHSharePlatformFacebook:
            [self facebookAuth];
            if (arr == nil) {
                return;
            }
            [self facebookShareImageWithImageArr:arr inputTimeMode:index1];
       
            break;
        case ZWHSharePlatformTwitter:
            [self twitterAuth];
            if (arr == nil) {
                return;
            }
            [self twitterShareImageWithImageArr:arr inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformGoolePlus:
        
            [self googleAuth];
            if (arr == nil) {
                return;
            }
            [self googleShareImageWithImageArr:arr inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformYoutube:
            [self googleAuth];
            break;
            
        default:
            break;
    }
}

- (void)shareVideoForOneWithFilePath:(NSString *)path thubImage:(UIImage *)image{
    
    NSInteger index = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0xf0;
    NSInteger index1 = [[kUserDefaults objectForKey:kShare1Platform] integerValue] & 0x0f;
    switch (index) {
        case ZWHSharePlatformFacebook:
            [self facebookAuth];
            [self facebookShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformTwitter:
       
            [self twitterAuth];
            [self twitterShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            break;
        case ZWHSharePlatformGoolePlus:
            [self googleAuth];
            [self googleShareVideoWithFilePath:path inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformYoutube:
            [self googleAuth];
            [self youtubeShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - 分享二      @[@"FaceBook",@"Twitter",@"Google +",@"YouTube"]

- (void)shareImageForTwoWithImageArr:(NSArray<UIImage *> *)arr {

    NSInteger index = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
    NSInteger index1 = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0x0f;
    
    switch (index) {
        case ZWHSharePlatformFacebook:
            [self facebookAuth];
            if (arr == nil) {
                return;
            }
            [self facebookShareImageWithImageArr:arr inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformTwitter:
            [self twitterAuth];
            if (arr == nil) {
                return;
            }
            [self twitterShareImageWithImageArr:arr inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformGoolePlus:
            [self googleAuth];
            if (arr == nil) {
                return;
            }
            [self googleShareImageWithImageArr:arr inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformYoutube:
            [self googleAuth];
            break;
        default:
            break;
    }
}

- (void)shareVideoForTwoWithFilePath:(NSString *)path thubImage:(UIImage *)image{
    
    NSInteger index = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0xf0;
    
    NSInteger index1 = [[kUserDefaults objectForKey:kShare2Platform] integerValue] & 0x0f;
    switch (index) {
        case ZWHSharePlatformFacebook:
            [self facebookAuth];
            [self facebookShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformTwitter:
            
            [self twitterAuth];
            [self twitterShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            break;
        case ZWHSharePlatformGoolePlus:
            [self googleAuth];
            [self googleShareVideoWithFilePath:path inputTimeMode:index1];
            
            break;
        case ZWHSharePlatformYoutube:
            [self googleAuth];
            [self youtubeShareVideoWithFilePath:path thubImage:image inputTimeMode:index1];
            
            break;
            
        default:
            break;
    }
}

#pragma mark - facebook
- (void)facebookAuth {
    //获取授权
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        //,@"manage_pages"
        [login logInWithPublishPermissions:@[@"publish_actions",@"publish_pages"] fromViewController:[ViewController sharedViewController] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                NSLog(@"Process error");
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                
                NSLog(@"Logged in");
            }
        }];
    }
}
- (void)facebookShareImageWithImageArr:(NSArray<UIImage *> *)arrImg inputTimeMode:(NSInteger)index{
    
    switch (index) {
        case ZWHShareCaptionModeNever:
        {
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            NSMutableArray *arr = [NSMutableArray array];
            for (UIImage *image in arrImg) {
                FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:YES];
                [arr addObject: photo];
            }
            
            if (arr.count > 5) {
                content.photos = @[arr[0],arr[1],arr[2],arr[3],arr[4]];
            }
            else {
                content.photos = arr;
            }
            
            [FBSDKShareAPI shareWithContent:content delegate:self];
        }
            
            break;
        case ZWHShareCaptionModeAfter:
        {
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            NSMutableArray *arr = [NSMutableArray array];
            for (UIImage *image in arrImg) {
                FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:image userGenerated:YES];
                [arr addObject: photo];
            }
            
            if (arr.count > 5) {
                content.photos = @[arr[0],arr[1],arr[2],arr[3],arr[4]];
            }
            else {
                content.photos = arr;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [FBSDKShareDialog showFromViewController:[ViewController sharedViewController] withContent:content delegate:self];
            });
            
        }
            
            break;
        case ZWHShareCaptionModeBefore:
        {
            FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
            FBSDKSharePhoto *photo = [FBSDKSharePhoto photoWithImage:[arrImg lastObject] userGenerated:YES];
            photo.caption = [kUserDefaults objectForKey:kShareCaption];
            content.photos = @[photo];
            
            [FBSDKShareAPI shareWithContent:content delegate:self];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [view show];
    });
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [view show];
    });
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {

}

- (void)facebookShareVideoWithFilePath:(NSString *)filepath thubImage:(UIImage *)image inputTimeMode:(NSInteger)index{
    switch (index) {
        case ZWHShareCaptionModeNever:
        {
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               data, [filepath lastPathComponent],
                                               @"video/quicktime", @"contentType", nil];
                                               
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"] && data.length) {
                    FBSDKGraphRequest *requset = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
                    [requset startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        
                        //清除缓存
                        NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                        for (NSString *fileName in enumerator) {
                            [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                        }
                        
                        if (error == nil) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [view show];
                            });
                        }
                    }];
                }
            });
        }
            
            break;
        case ZWHShareCaptionModeAfter:
        {
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ZWHCaptionView *view = [ZWHCaptionView viewWithPlatformTitle:@"Facebook" image:image cancelCallBack:^{
                    //清除缓存
                    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                    }
                    
                } issueCallBack:^(NSString *description) {
                    
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                       data, [filepath lastPathComponent],
                                                       @"video/quicktime", @"contentType",
                                                       description, @"description",
                                                       nil];
                        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"] && data.length) {
                            FBSDKGraphRequest *requset = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
                            [requset startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                
                                //清除缓存
                                NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                for (NSString *fileName in enumerator) {
                                    [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                }
                                
                                if (error == nil) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [view show];
                                    });
                                }
                            }];
                        }
                    });
                }];
                [[ViewController sharedViewController].view addSubview:view];
            });
        }
            
            break;
        case ZWHShareCaptionModeBefore:
        {
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               data, [filepath lastPathComponent],
                                               @"video/quicktime", @"contentType", [kUserDefaults objectForKey:kShareCaption], @"description",nil];
                
                if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"] && data.length) {
                    FBSDKGraphRequest *requset = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
                    [requset startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                        
                        //清除缓存
                        NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                        for (NSString *fileName in enumerator) {
                            [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                        }
                        
                        if (error == nil) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                [view show];
                            });
                        }
                    }];
                }
            });
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark - twitter
- (void)twitterAuth {

    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}
- (void)twitterShareImageWithImageArr:(NSArray<UIImage *> *)arrImg inputTimeMode:(NSInteger)index{
    switch (index) {
        case ZWHShareCaptionModeNever:
        {
            NSData *data = UIImageJPEGRepresentation([arrImg firstObject], 1);
            [[TWTRAPIClient clientWithCurrentUser] uploadMedia:data contentType:@"image/jpeg" completion:^(NSString * _Nullable mediaID, NSError * _Nullable error) {
                if (error == nil) {
                    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                    
                    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                        if (granted) {
                            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                            
                            if (accounts.count > 0)
                            {
                                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                                
                                [SocialVideoHelper tweetVideoStage4:nil mediaID:mediaID comment:nil account:twitterAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                                    if (success) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                            [view show];
                                        });
                                    }
                                }];
                            }
                        }
                    }];
                }
            }];
            
        }
            
            break;
        case ZWHShareCaptionModeAfter:
        {
             TWTRComposer *composer = [[TWTRComposer alloc] init];
             [composer setText:@"写写心情吧"];
             [composer setImage:[arrImg firstObject]];
             
             [composer showFromViewController:[ViewController sharedViewController] completion:^(TWTRComposerResult result) {
             if (result == TWTRComposerResultCancelled) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布失败" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [view show];
                 });
             }
             else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [view show];
                 });
             }
             }];
        }
            
            break;
        case ZWHShareCaptionModeBefore:
        {
            NSData *data = UIImageJPEGRepresentation([arrImg firstObject], 1);
            [[TWTRAPIClient clientWithCurrentUser] uploadMedia:data contentType:@"image/jpeg" completion:^(NSString * _Nullable mediaID, NSError * _Nullable error) {
                if (error == nil) {
                    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                    
                    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                        if (granted) {
                            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                            
                            if (accounts.count > 0)
                            {
                                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                                
                                [SocialVideoHelper tweetVideoStage4:nil mediaID:mediaID comment:[kUserDefaults objectForKey:kShareCaption] account:twitterAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                                    if (success) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                            [view show];
                                        });
                                    }
                                }];
                            }
                        }
                    }];
                }
            }];
            
        }
            
            break;
            
        default:
            break;
    }
}
- (void)twitterShareVideoWithFilePath:(NSString *)filepath thubImage:(UIImage *)image inputTimeMode:(NSInteger)index{
    switch (index) {
        case ZWHShareCaptionModeNever:
        {
            //video
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                if (granted) {
                    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                    
                    if (accounts.count > 0)
                    {
                        ACAccount *twitterAccount = [accounts objectAtIndex:0];
                        
                        [SocialVideoHelper uploadTwitterVideo:data comment:nil account:twitterAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                            //清除缓存
                            NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                            for (NSString *fileName in enumerator) {
                                [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                            }
                            
                            if (success) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [view show];
                                });
                            }
                        }];
                    }
                }
            }];
            
        }
            
            break;
        case ZWHShareCaptionModeAfter:
        {
            //video
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                ZWHCaptionView *view = [ZWHCaptionView viewWithPlatformTitle:@"Twitter" image:image cancelCallBack:^{
                    //清除缓存
                    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                    }
                    
                } issueCallBack:^(NSString *description) {
                    
                    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
                    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                    
                    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                        if (granted) {
                            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                            
                            if (accounts.count > 0)
                            {
                                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                                
                                [SocialVideoHelper uploadTwitterVideo:data comment:description account:twitterAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                                    //清除缓存
                                    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                    for (NSString *fileName in enumerator) {
                                        [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                    }
                                    
                                    if (success) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                            [view show];
                                        });
                                    }
                                }];
                            }
                        }
                    }];
                    
                }];
                [[ViewController sharedViewController].view addSubview:view];
            });
        }
            
            break;
        case ZWHShareCaptionModeBefore:
        {
            //video
            NSData *data = [NSData dataWithContentsOfFile:filepath];
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
                if (granted) {
                    NSArray *accounts = [accountStore accountsWithAccountType:accountType];
                    
                    if (accounts.count > 0)
                    {
                        ACAccount *twitterAccount = [accounts objectAtIndex:0];
                        
                        [SocialVideoHelper uploadTwitterVideo:data comment:[kUserDefaults objectForKey:kShareCaption] account:twitterAccount withCompletion:^(BOOL success, NSString *errorMessage) {
                            //清除缓存
                            NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                            NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                            for (NSString *fileName in enumerator) {
                                [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                            }
                            
                            if (success) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                    [view show];
                                });
                            }
                        }];
                    }
                }
            }];
        }
            
            break;
            
        default:
            break;
    }

}

#pragma mark - google + youtube
- (void)googleAuth {
    [self.manager authenticate];
}
- (void)googleShareImageWithImageArr:(NSArray<UIImage *> *)arrImg inputTimeMode:(NSInteger)index{
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [arrImg enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 5) {
            *stop = YES;
        }
        [(id<GPPNativeShareBuilder>)shareBuilder attachImage:obj];
    }];
    
    [shareBuilder open];
}
- (void)googleShareVideoWithFilePath:(NSString *)filepath inputTimeMode:(NSInteger)index{
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [GPPShare sharedInstance].delegate = self;
    [(id<GPPNativeShareBuilder>)shareBuilder attachVideoURL:[NSURL fileURLWithPath:filepath]];
    [shareBuilder open];
    self.block = ^ {
        //清除缓存
        NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
        for (NSString *fileName in enumerator) {
            [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
        }
    };
}

- (void)finishedSharingWithError:(NSError *)error {
    
    if (self.block) {
        self.block();
    }
}

- (void)finishedSharing:(BOOL)shared {
    if (self.block) {
        self.block();
    }
}
- (void)youtubeShareVideoWithFilePath:(NSString *)filepath thubImage:(UIImage *)image inputTimeMode:(NSInteger)index{
    switch (index) {
        case ZWHShareCaptionModeNever:
        {
            GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
            status.privacyStatus = @"public";
            
            // Snippet.
            GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
            snippet.descriptionProperty = nil;
            
            GTLRYouTube_Video *video = [GTLRYouTube_Video object];
            video.status = status;
            video.snippet = snippet;
            
            NSString *mimeType = @"video/mp4";
            
            GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:[NSData dataWithContentsOfFile:filepath] MIMEType:mimeType];
            
            GTLRYouTubeQuery_VideosInsert *query = [GTLRYouTubeQuery_VideosInsert queryWithObject:video part:@"snippet,status"
                                                                                 uploadParameters:uploadParameters];
            
            query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                              unsigned long long numberOfBytesRead,
                                                              unsigned long long dataLength) {
            };
            
            [self.youTubeService executeQuery:query
                            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                GTLRYouTube_Video *uploadedVideo,
                                                NSError *callbackError) {
                                //清除缓存
                                NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                for (NSString *fileName in enumerator) {
                                    [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                }
                                
                                if (callbackError == nil) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [view show];
                                    });
                                }
                            }];
            
        }
            
            break;
        case ZWHShareCaptionModeAfter:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                ZWHCaptionView *view = [ZWHCaptionView viewWithPlatformTitle:@"Youtube" image:image cancelCallBack:^{
                    //清除缓存
                    NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                    for (NSString *fileName in enumerator) {
                        [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                    }
                    
                } issueCallBack:^(NSString *description) {
                    GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
                    status.privacyStatus = @"public";
                    
                    // Snippet.
                    GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
                    snippet.descriptionProperty = description;
                    
                    GTLRYouTube_Video *video = [GTLRYouTube_Video object];
                    video.status = status;
                    video.snippet = snippet;
                    
                    NSString *mimeType = @"video/mp4";
                    
                    GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:[NSData dataWithContentsOfFile:filepath] MIMEType:mimeType];
                    
                    GTLRYouTubeQuery_VideosInsert *query = [GTLRYouTubeQuery_VideosInsert queryWithObject:video part:@"snippet,status"
                                                                                         uploadParameters:uploadParameters];
                    
                    query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                                      unsigned long long numberOfBytesRead,
                                                                      unsigned long long dataLength) {
                    };
                    
                    [self.youTubeService executeQuery:query
                                    completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                        GTLRYouTube_Video *uploadedVideo,
                                                        NSError *callbackError) {
                                        //清除缓存
                                        NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                        for (NSString *fileName in enumerator) {
                                            [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                        }
                                        
                                        if (callbackError == nil) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                                [view show];
                                            });
                                        }
                                    }];
                    
                }];
                [[ViewController sharedViewController].view addSubview:view];
            });
        }
            
            break;
        case ZWHShareCaptionModeBefore:
        {
            GTLRYouTube_VideoStatus *status = [GTLRYouTube_VideoStatus object];
            status.privacyStatus = @"public";
            
            // Snippet.
            GTLRYouTube_VideoSnippet *snippet = [GTLRYouTube_VideoSnippet object];
            snippet.descriptionProperty = [kUserDefaults objectForKey:kShareCaption];
            
            GTLRYouTube_Video *video = [GTLRYouTube_Video object];
            video.status = status;
            video.snippet = snippet;
            
            NSString *mimeType = @"video/mp4";
            
            GTLRUploadParameters *uploadParameters = [GTLRUploadParameters uploadParametersWithData:[NSData dataWithContentsOfFile:filepath] MIMEType:mimeType];
            
            GTLRYouTubeQuery_VideosInsert *query = [GTLRYouTubeQuery_VideosInsert queryWithObject:video part:@"snippet,status"
                                                                                 uploadParameters:uploadParameters];
            
            query.executionParameters.uploadProgressBlock = ^(GTLRServiceTicket *ticket,
                                                              unsigned long long numberOfBytesRead,
                                                              unsigned long long dataLength) {
            };
            
            [self.youTubeService executeQuery:query
                            completionHandler:^(GTLRServiceTicket *callbackTicket,
                                                GTLRYouTube_Video *uploadedVideo,
                                                NSError *callbackError) {
                                //清除缓存
                                NSString *pathCache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) firstObject];
                                NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:pathCache];
                                for (NSString *fileName in enumerator) {
                                    [[NSFileManager defaultManager] removeItemAtPath:[pathCache stringByAppendingPathComponent:fileName] error:nil];
                                }
                                
                                if (callbackError == nil) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"发布成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                                        [view show];
                                    });
                                }
                            }];
            
        }
            
            break;
            
        default:
            break;
    }
}

@end
