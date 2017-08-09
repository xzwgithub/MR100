//
//  AppDelegate.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/8/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkReachabilityManager.h"
#import "ZWHFirstLaunchViewController.h"
#import "ViewController.h"
#import <Photos/Photos.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientID = @"555408402165-l92t3rmsa56d5kljdhmg6fsfjb9rpl67.apps.googleusercontent.com";

@interface AppDelegate ()
@property (assign , nonatomic) BOOL isForceLandscape;
@property (assign , nonatomic) BOOL isForcePortrait;
@property(nonatomic, strong) NSDate *currentDate;          //
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    //初次启动，初始化设置
    if (![kUserDefaults objectForKey:kShare1Platform]) {
        ZWHFirstLaunchViewController *vc = [[ZWHFirstLaunchViewController alloc] init];
        self.window.rootViewController = vc;
    }
    else {
        ViewController *vc = [ViewController sharedViewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:{
     
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:{

                break;
                
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                break;
            }
                
            default:
                
                break;
        }
        
    }];
    
    //相册请求权限
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                   
                    break;
                }
                    
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    
                    NSLog(@"提醒用户打开相册的访问开关");
                    break;
                }
                    
                case PHAuthorizationStatusRestricted: {
                    NSLog(@"因系统原因，无法访问相册！");
                    break;
                }
                    
                default:
                    break;
            }
        });
    }];
    
    [Fabric with:@[[Twitter class]]];
    [FBSDKLoginButton class];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];

    [GPPSignIn sharedInstance].clientID = kClientID;
    [GPPSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/plus.login",@"profile", @"email",@"https://www.googleapis.com/auth/youtube"];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([GPPURLHandler handleURL:url
               sourceApplication:sourceApplication
                      annotation:annotation]) {
        return YES;
    }
    
    if ([[FBSDKApplicationDelegate sharedInstance] application:application
                                                       openURL:url
                                             sourceApplication:sourceApplication
                                                    annotation:annotation]) {
        return YES;
    }
    
    return NO;
}

- (void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (![[kUserDefaults objectForKey:kClearScreen] boolValue]) {
        return;
    }
    self.currentDate = [NSDate date];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([[kUserDefaults objectForKey:kClearScreen] boolValue]) {
            NSDate *date = [NSDate date];
            NSTimeInterval value = [date timeIntervalSinceDate:self.currentDate];
            if (value >= 8) {
                [[ViewController sharedViewController] makeScreenFull];
            }
        }
    });
}

@end
