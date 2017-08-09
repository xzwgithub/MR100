//
//  ZWHVideoCell.m
//  MR100AerialPhotography
//
//  Created by 赵文华 on 16/9/8.
//  Copyright © 2016年 AllWinner. All rights reserved.
//

#import "ZWHVideoCell.h"

@interface ZWHVideoCell ()

@property(nonatomic, strong) UIImageView *imageView;          //

@property(nonatomic, strong) UIView *bottomBar;          //视频黑条

@property(nonatomic, strong) UIButton *choiceBtn;          //选中按钮

@property(nonatomic, strong) UILabel *timeLable;          //

@end

@implementation ZWHVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = kBlackColor.CGColor;
        
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
        
        //播放图标
        UIImageView *imgVPlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_18x18"]];
        if (kIsIpad) {
            imgVPlay.frame = CGRectMake(self.contentView.frame.size.width / 2 - 15, self.contentView.frame.size.height / 2 - 15, 30, 30);
        }
        else {
            imgVPlay.frame = CGRectMake(self.contentView.frame.size.width / 2 - 10, self.contentView.frame.size.height / 2 - 10, 20, 20);
        }
        [self.contentView addSubview:imgVPlay];
        
        //小黑条
        if (kIsIpad) {
            _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 30, self.contentView.frame.size.width, 30)];
            _bottomBar.backgroundColor = kRGBAColorFloat(0.2, 0.2, 0.2, 0.5);
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
            imgV.contentMode = UIViewContentModeCenter;
            imgV.image = [UIImage imageNamed:@"Video-recorder"];
            [_bottomBar addSubview:imgV];
            
            _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, self.contentView.frame.size.width - 70, 30)];
            _timeLable.textColor = kWhiteColor;
            _timeLable.textAlignment = NSTextAlignmentRight;
            _timeLable.font = FontSize(16);
            
            [_bottomBar addSubview:_timeLable];
        }
        else {
            _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 20, self.contentView.frame.size.width, 20)];
            _bottomBar.backgroundColor = kRGBAColorFloat(0.2, 0.2, 0.2, 0.5);
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
            imgV.contentMode = UIViewContentModeCenter;
            imgV.image = [UIImage imageNamed:@"Video-recorder"];
            [_bottomBar addSubview:imgV];
            
            _timeLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.contentView.frame.size.width - 40, 20)];
            _timeLable.textColor = kWhiteColor;
            _timeLable.textAlignment = NSTextAlignmentRight;
            _timeLable.font = FontSize(13);
            
            [_bottomBar addSubview:_timeLable];
        }
        
        [self.contentView addSubview:_bottomBar];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.timeLable.text = nil;
    self.choiceBtn.selected = NO;
}

- (void)setModel:(ZWHAssetModel *)model {

    _model = model;
    _imageView.image = model.thumbnailImage;
    _choiceBtn.hidden = model.btnHidden;
    _choiceBtn.selected = model.selected;
    NSInteger second = (NSInteger)model.asset.duration % 60;
    NSInteger minute = (NSInteger)model.asset.duration / 60;
    _timeLable.text = [NSString stringWithFormat:@"%02ld:%02ld",minute,second];    
}

@end
