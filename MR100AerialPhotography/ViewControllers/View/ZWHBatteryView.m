//
//  ZWHBatteryView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHBatteryView.h"
#import "UIFont+MyFontSize.h"
@interface ZWHBatteryView ()

@property(nonatomic, strong) UIImageView *batteryImageView;          //

@property (nonatomic,strong) UILabel * electricLab;

@property(nonatomic, strong) UIView *insideView;          //

@property(nonatomic, strong) NSTimer *timer;          //

@end

@implementation ZWHBatteryView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kClearColor;
        UIImageView *imgView;
        UILabel * elecLab;
        if (kIsIpad) {
            imgView = [[UIImageView alloc] initWithImage:ImageNamed(@"Battery-ipad")];
            imgView.frame = CGRectMake(kIpadMainBottomBtnWidth/3 - 19.5, 20, 39, 20);
        }
        else {
            imgView = [[UIImageView alloc] initWithImage:ImageNamed(@"battery")];
            imgView.frame = CGRectMake(kMainBottomBtnWidth/3 - 25, 14, 25, 12);
            
            elecLab = [[UILabel alloc]init];
            elecLab.frame = CGRectMake(kMainBottomBtnWidth/3, 14, 30, 12);
            elecLab.font = [UIFont systemFontOfSize:10];
            elecLab.textAlignment = NSTextAlignmentCenter;
            elecLab.textColor = [UIColor whiteColor];
            elecLab.backgroundColor = [UIColor clearColor];
            self.electricLab.text = @"0%";
        }
        
        [self addSubview:imgView];
        [self addSubview:elecLab];
        _insideView = [[UIView alloc] init];
        [imgView addSubview:_insideView];
        [imgView bringSubviewToFront:_insideView];
        
        _batteryImageView = imgView;
        _electricLab = elecLab;
    }

    return self;
}

- (void)setElecQuantity:(NSInteger)elecQuantity {
    
    if (elecQuantity == -1) {
        _isCharging = YES;
    }
    else{
    
        _isCharging = NO;
        self.electricLab.text = [NSString stringWithFormat:@"%ld%%",elecQuantity];
    }
    
//    if (_elecQuantity == elecQuantity) {
//        return;
//    }
    self.insideView.hidden = NO;

    _elecQuantity = elecQuantity;
    if (kIsIpad)
    {
        if (elecQuantity > 40 && elecQuantity <= 100) {
            self.insideView.frame = CGRectMake(1, 1, 34 * elecQuantity / 100, 18);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kWhiteColor;
            [self removeTimer];
            
        }
        else if (elecQuantity <= 40 && elecQuantity >= 25) {
            self.insideView.frame = CGRectMake(1, 1, 34 * elecQuantity / 100, 18);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kRedColor;
            [self removeTimer];
            
        }
        else if (elecQuantity > 0 && elecQuantity < 25) {
            self.insideView.frame = CGRectMake(1, 1, 34 * elecQuantity / 100.0, 18);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kRedColor;
            [self timer];
        }
        else if (elecQuantity == 0) {
            [self removeTimer];
        }
        else if (elecQuantity == -1) {
            self.insideView.hidden = YES;
            self.batteryImageView.image = [UIImage imageNamed:@"SD-card-Charge-ipad"];
            self.batteryImageView.contentMode = UIViewContentModeCenter;
            [self removeTimer];
        }
    }
    else
    {
        if (elecQuantity > 40 && elecQuantity <= 100)
        {
            self.insideView.frame = CGRectMake(1, 1, 21 * elecQuantity / 100, 10);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kWhiteColor;
            [self removeTimer];
        }
        else if (elecQuantity <= 40 && elecQuantity >= 25) {
            self.insideView.frame = CGRectMake(1, 1, 21 * elecQuantity / 100, 10);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kRedColor;
            [self removeTimer];
        }
        else if (elecQuantity > 0 && elecQuantity < 25) {
            self.insideView.frame = CGRectMake(1, 1, 21 * elecQuantity / 100.0, 10);
            self.insideView.hidden = NO;
            self.insideView.backgroundColor = kRedColor;
            
            if (!_timer) {
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                [_timer fire];
            }
        }
        else if (elecQuantity == 0) {
            self.batteryImageView.image = [UIImage imageNamed:@"battery"];
            [self removeTimer];
        }
        else if (elecQuantity == -1) {
            self.insideView.hidden = YES;
            self.batteryImageView.image = [UIImage imageNamed:@"Battery-(rechargeable)"];
            self.batteryImageView.contentMode = UIViewContentModeCenter;
            [self removeTimer];
        }

    }
}

- (void)timerAction:(NSTimer *)timer {

    self.insideView.hidden = !self.insideView.hidden;
}

- (void)dealloc {
   
    [self removeTimer];
}


//移除定时器
-(void)removeTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

