//
//  ZWHSatelliteView.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/10/8.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHSatelliteView.h"
@interface ZWHSatelliteView()

@property(nonatomic, strong) UIImageView *imageView;          //
@end

@implementation ZWHSatelliteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_imageView];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.textAlignment = NSTextAlignmentCenter;
        
        lb.textColor = [UIColor whiteColor];
        [self addSubview:lb];
        if (kIsIpad) {
            lb.font = [UIFont boldSystemFontOfSize:14];
            _imageView.image = [UIImage imageNamed:@"satellite-ipad"];
        }
        else {
            lb.font = [UIFont boldSystemFontOfSize:11];
            _imageView.image = [UIImage imageNamed:@"satellite"];
        }
        _badgeLable = lb;
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    if (kIsIpad) {
        self.imageView.frame = CGRectMake(-5, 0, self.frame.size.width, self.frame.size.height);
        self.badgeLable.frame = CGRectMake(self.frame.size.width / 2, 0, 20, 20);
    }
    else {
        self.imageView.frame = CGRectMake(-5, 0, self.frame.size.width, self.frame.size.height);
        self.badgeLable.frame = CGRectMake(self.frame.size.width / 2, 0, 15, 15);
    }
}

@end
