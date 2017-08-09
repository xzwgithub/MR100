//
//  ZWHSettingCell.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/12/21.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHSettingCell.h"

@interface ZWHSettingCell ()
@property(nonatomic, strong) UIView *view;          //
@property(nonatomic, strong) UIImageView *imageV;          //
@end

@implementation ZWHSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    if (_lable) {
        return;
    }
    _lable = [[UILabel alloc] init];
    _view = [[UIView alloc] init];
    _view.backgroundColor = kGrayColor;
    _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jt"]];
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    _imageV.hidden = YES;
    [self.contentView addSubview:_imageV];
    [self.contentView addSubview:_view];
    [self.contentView addSubview:_lable];
    [self.contentView sendSubviewToBack:_lable];
    [self.contentView sendSubviewToBack:_view];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lable.frame = CGRectMake(15, 0, self.frame.size.width - 15, self.frame.size.height - 1);
    self.view.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    self.imageV.frame = CGRectMake(self.frame.size.width - 30, self.frame.size.height*0.5 - 9, 12, 18);
}

- (void)setAppearIndicator:(BOOL)appearIndicator {
    _appearIndicator = appearIndicator;
    self.imageV.hidden = !appearIndicator;
}

@end
