//
//  ZWHSdView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/5.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHSdView.h"

@interface ZWHSdView()

@property(nonatomic, strong) UILabel *quantityLable;          //

@property(nonatomic, strong) UIImageView *sdImageView;          //

@property(nonatomic, strong) NSTimer *timer;          //

@end

@implementation ZWHSdView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kClearColor;
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
         [self addSubview:imgView];
        _sdImageView = imgView;
        
        if (kIsIpad) {
            _quantityLable = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, kIpadMainBottomBtnWidth - 70, 60)];
            _quantityLable.font = FontSize(15);
        }
        else {
            _quantityLable = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, kMainBottomBtnWidth - 47, 40)];
            _quantityLable.font = FontSize(11);
        }
        
        _quantityLable.hidden = YES;
        _quantityLable.textColor = kWhiteColor;
        _quantityLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_quantityLable];
    }
    
    return self;
}

- (void)setMemoQuantity:(NSInteger)memoQuantity Out:(int)state{
    
    _memoQuantity = memoQuantity;
    self.sdImageView.hidden = NO;
    _quantityLable.text = [NSString stringWithFormat:@"%ld%%",(long)memoQuantity];
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (state == 0) {
        self.quantityLable.hidden = YES;
        self.sdImageView.image = [UIImage imageNamed:@"SD-card-shut"];
        self.sdImageView.contentMode = UIViewContentModeCenter;
        self.sdImageView.frame = CGRectMake(0, 0, kMainBottomBtnWidth, 40);
    }
    else if (state == 1)
    {
        if (kIsIpad) {
            if (memoQuantity > 10 && memoQuantity <= 100) {
                self.quantityLable.hidden = NO;
                self.sdImageView.image = ImageNamed(@"SD-card-ipad");
                self.sdImageView.frame = CGRectMake(25, 20, 32, 20);
            }
            else if (memoQuantity > 0 && memoQuantity < 10) {
                self.quantityLable.hidden = NO;
                self.sdImageView.image = ImageNamed(@"SD(Twinkle)-clike-ipad");
                self.sdImageView.frame = CGRectMake(25, 20, 32, 20);
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                [self.timer fire];
            }
            else if (memoQuantity == 0) {
                self.quantityLable.hidden = YES;
                self.sdImageView.image = [UIImage imageNamed:@"SD-card-(no-card)-ipad"];
                self.sdImageView.contentMode = UIViewContentModeCenter;
                self.sdImageView.frame = CGRectMake(0, 0, kIpadMainBottomBtnWidth, 60);
            }
            
        }
        else {
            if (memoQuantity > 10 && memoQuantity <= 100) {
                self.quantityLable.hidden = NO;
                self.sdImageView.image = ImageNamed(@"SD-card");
                self.sdImageView.frame = CGRectMake(20, 13.5, 21, 13);
            }
            else if (memoQuantity >= 0 && memoQuantity < 10) {
                self.quantityLable.hidden = NO;
                self.sdImageView.image = ImageNamed(@"SD(Twinkle)");
                self.sdImageView.frame = CGRectMake(20, 13.5, 21, 13);
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
                [self.timer fire];
            }
        }
    }
}

- (void)timerAction:(NSTimer *)timer {
    
    self.sdImageView.hidden = !self.sdImageView.hidden;
}

- (void)dealloc {
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end

