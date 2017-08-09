//
//  ZWHAssetCell.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/7.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHAssetCell.h"
@interface ZWHAssetCell ()

@property(nonatomic, strong) UIButton *choiceBtn;          //选中按钮

@end

@implementation ZWHAssetCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = kBlackColor.CGColor;
        self.layer.borderWidth = 1;
        
        //背景图片
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imageView];
        
        //选中按钮
        _choiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _choiceBtn.hidden = YES;
        if (kIsIpad) {
            _choiceBtn.frame = CGRectMake(5, 5, 36, 36);
            [_choiceBtn setImage:[UIImage imageNamed:@"Unchecked-ipad"] forState:UIControlStateNormal];
            [_choiceBtn setImage:[UIImage imageNamed:@"Select-(click)-ipad"] forState:UIControlStateSelected];
        }
        else {
            _choiceBtn.frame = CGRectMake(2, 2, 18, 18);
            [_choiceBtn setImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
            [_choiceBtn setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        }
        
        [self.contentView addSubview:_choiceBtn];
        [self.contentView bringSubviewToFront:_choiceBtn];
    }
    return self;
}


- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.choiceBtn.selected = NO;
}

- (void)setModel:(ZWHAssetModel *)model {
    
    _model = model;
    
    _choiceBtn.hidden = model.btnHidden;
    _choiceBtn.selected = model.selected;
    _imageView.image = model.thumbnailImage;
   
}

@end
