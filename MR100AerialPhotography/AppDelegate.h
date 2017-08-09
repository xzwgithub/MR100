//
//  AppDelegate.h
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/8/29.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

//#import <UIKit/UIKit.h>

//@interface AppDelegate : UIResponder <UIApplicationDelegate>


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface AppDelegate : UIApplication <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

