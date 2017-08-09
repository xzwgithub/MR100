//
//  Controller.m
//  MR100AerialPhotography
//
//  Created by luo雨思 on 16/11/23.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "Controller.h"
#import "AWLinkHelper.h"
#import "AWLinkConstant.h"

static int delayClearTime = 2;

@interface Controller ()
{
    Byte message[11];
}

@property(atomic,assign)Boolean followMe;
@property(atomic,assign)Boolean magY;
@property(atomic,assign)Boolean magX;
@property(atomic,assign)Boolean circle;
@property(atomic,assign)Boolean reserveBit;
@end

@implementation Controller

-(instancetype)init
{
    self = [super init];
    if (self) {
        _fuyi = 0;
        _shengjiang = 0;
        _youmen = 0x00;
        _fangxiang = 0;
        _onekeyfly = false;
        _onekeyland = false;
        _emergency = false;
        _followMe = false;
        _magX = false;
        _magY = false;
        _circle = false;
        _reserveBit = false;

        [self cacheStore];
    }
    
    return self;
}

-(void)cacheStore
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _fuyilingpian = [[userDefaults objectForKey:@"fuyilingpian"] intValue];
    _shengjianglingpian = [[userDefaults objectForKey:@"shengjianglingpian"] intValue];
    _flyModel = [[userDefaults objectForKey:@"flyModel"] intValue];
    if (_fuyilingpian == '\0') {
        _fuyilingpian = 0.0;
    }
    if (_shengjianglingpian == '\0') {
        _shengjianglingpian = 0.0;
    }
    if (_flyModel == '\0') {
        _flyModel = false;
    }
    
}

-(FlyControlModeTye)getControlMessage
{
    
    if (_onekeyfly) {
        return FlyControlModeTyeTakeoff;
    }
    if (_onekeyland) {
        
         return FlyControlModeTyeLand;
    }
    if (_emergency) {
        return FlyControlModeTyeStop;
    }
    
    return FlyControlModeTyeUnknow;
    
}

-(void)takeoffAction
{
    if (_onekeyfly) {
        return;
    }
    _onekeyfly = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:0] afterDelay:delayClearTime];
}

-(void)landAction
{
    if (_onekeyland) {
        return;
    }
    _onekeyland = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:8] afterDelay:delayClearTime];
}

-(void)reserveBitControl
{
    if (_reserveBit) {
        
        return;
    }
    
    _reserveBit = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:1] afterDelay:delayClearTime];
}

-(void)followMe_action:(BOOL)state
{
    _followMe = state;
}

-(void)emergency_action
{
    if (_emergency) {
        return;
    }
    
    _emergency = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:3] afterDelay:delayClearTime];
}


-(void)circle360_action:(BOOL)state
{
    _circle = state;
}

-(void)magXAdapt_action
{
    if (_magX) {
        
        return;
    }
    
    _magX = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:5] afterDelay:delayClearTime];
}

-(void)magYAdapt_action
{
    if (_magY) {
        
        return;
    }
    
    _magY = true;
    [self performSelector:@selector(resetValue:) withObject:[NSNumber numberWithInt:6] afterDelay:delayClearTime];
}

//开始校准
-(void)accAdapt_action
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotice_correct_acc object:nil];
}


-(void)resetValue:(NSNumber *)obj
{
    int tag = obj.intValue;
    switch (tag) {
        case 0:
        {
            _onekeyfly= 0;
        }
            break;
        case 1:
        {
            _reserveBit = 0;
        }
            break;
        case 2:
        {
            _followMe = 0;
        }
            break;
        case 3:
        {
            _emergency = 0;
        }
            break;
        case 4:
        {
            _circle = 0;
        }
            break;
        case 5:
        {
            _magX = 0;
        }
            break;
        case 6:
        {
            _magY = 0;
        }
            break;
        case 8:
        {
            _onekeyland = 0;
        }
            break;
        default:
            break;
    }
}


@end
