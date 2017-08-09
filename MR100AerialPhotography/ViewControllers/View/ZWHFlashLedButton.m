//
//  ZWHFlashLedButton.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/20.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHFlashLedButton.h"

@interface ZWHFlashLedButton ()

@property(nonatomic, strong) UIButton *btn;          //
@property(nonatomic, assign) unsigned int state;
@end

@implementation ZWHFlashLedButton

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (kIsIpad) {
            [_btn setImage:[UIImage imageNamed:@"Flash-(open)-ipad"] forState:UIControlStateNormal];
        }
        else {
            [_btn setImage:[UIImage imageNamed:@"Flash lamp"] forState:UIControlStateNormal];
        }
        
        [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btn];
        _state = 0;
    }
    return self;
}
-(void)setFlashImgWithState:(unsigned int)tag
{
    _state = tag%3;
    [self updateUI];
}

- (void)btnAction:(UIButton *)sender {
    _state = (_state + 1)%3;
    if (self.block) {
        self.block(_state);
    }
    [self updateUI];
}

-(void)updateUI
{
    if (kIsIpad) {
        switch (_state) {
            case 1:
                [self.btn setImage:[UIImage imageNamed:@"Flash-(open)-ipad"] forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.btn setImage:[UIImage imageNamed:@"Flash-(automatic)-ipad"] forState:UIControlStateNormal];
                break;
                
            case 0:
                [self.btn setImage:[UIImage imageNamed:@"Flash-(off)-ipad"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
    else {
        switch (_state) {
            case 1:
                [self.btn setImage:[UIImage imageNamed:@"Flash lamp"] forState:UIControlStateNormal];
                break;
                
            case 2:
                [self.btn setImage:[UIImage imageNamed:@"Flash-flash"] forState:UIControlStateNormal];
                break;
                
            case 0:
                [self.btn setImage:[UIImage imageNamed:@"Flashclose"] forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.btn.frame = self.bounds;
}
@end
