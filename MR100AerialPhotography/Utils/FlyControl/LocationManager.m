//
//  LocationManager.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/27.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "LocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationManager ()<CLLocationManagerDelegate>
{
    Byte message[14];
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (atomic,assign)CLLocationCoordinate2D coordinate;
@property (atomic,assign)float heading;
@property (atomic,assign)BOOL isValid;  //定位数据是否可用
@end
@implementation LocationManager

-(BOOL)isValidate
{
    return _isValid;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _isValid = NO;
    }
    return self;
}

-(int)startUpdateLocation
{

    if (![CLLocationManager locationServicesEnabled])  //确定用户的位置服务启用
    {
        NSLog(@"定位服务未打开，提示用户打开");
        return -1;
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
        NSLog(@"用户禁止该应用使用定位服务");
        return -2;
    }
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.distanceFilter=kCLDistanceFilterNone;//任何移动
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
    _isValid = YES;
    return 0;
}

-(void)stopUpdateLocation
{
    if (_locationManager) {
        _isValid = NO;
        [_locationManager stopUpdatingLocation];
        [_locationManager stopUpdatingHeading];
    }
}

-(NSData *)getCoordinateData
{
    if (!_isValid) {
        return nil;
    }
    int32_t latitude = (int32_t) (_coordinate.latitude *10000000);
    int32_t longitude = (int32_t) (_coordinate.longitude *10000000);
    message[0] = 0x66;
    message[1] = 0x0a;
    message[2] = latitude & 0xff;
    message[3] = (latitude>>8) &0xff;
    message[4] = (latitude>>16) &0xff;
    message[5] = (latitude>>24) &0xff;
    
    message[6] = longitude &0xff;
    message[7] = (longitude>>8) &0xff;
    message[8] = (longitude>>16) &0xff;
    message[9] = (longitude>>24) &0xff;
    
    int16_t heading = _heading;
    message[10] = heading &0xff;
    message[11] = (heading >> 8) &0xff;
    
    message[12] = (message[2]^message[3]^message[4]^message[5]^message[6]^message[7]^message[8]^message[9] ^message[10]^message[11])&0xff;
    message[13] = 0x99;
    
//    NSLog(@"%x-%x-%x-%x-%x-%x-%x-%x-%x-%x",message[2],message[3],message[4],message[5],message[6],message[7],message[8],message[9],message[10],message[11]);
    
    NSData *data = [[NSData alloc] initWithBytes:message length:14];
    return data;
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）

//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法,除了提供定位功能，CLLocationManager还可以调用startMonitoringForRegion:方法对指定区域进行监控。
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location=[locations lastObject];//取出 最后一个位置
    _coordinate = location.coordinate;
    
}
//return YES:是当在室内、地下、有磁场干扰或者很久没有用指南针时系统发现方向不够准确时自动弹出校准;return NO地图定位使用方向时取消指南针校准
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //    获取的航向  与north的夹角
    _heading = newHeading.magneticHeading;
    
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    _isValid = NO;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
    
}

@end
