//
//  ZWDebugInfoView.m
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/21.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import "ZWDebugInfoView.h"
#import "DebugInfoModel.h"

@interface ZWDebugInfoView ()

//cpu使用率
@property (weak, nonatomic) IBOutlet UILabel *cpuLab;

//可用内存
@property (weak, nonatomic) IBOutlet UILabel *memoryLab;

//飞机模式
@property (weak, nonatomic) IBOutlet UILabel *flyModeLab;

//飞机高度
@property (weak, nonatomic) IBOutlet UILabel *flyHeightLab;

//起飞时长
@property (weak, nonatomic) IBOutlet UILabel *flyTimeLab;

@end
@implementation ZWDebugInfoView

+(instancetype)creatDebugInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}

-(void)setDebugInfo:(DebugInfoModel *)debugInfo
{
    _debugInfo = debugInfo;
    
    [self setUI:debugInfo];
}

//赋值
-(void)setUI:(DebugInfoModel*)debugInfo
{
       
    //cpu使用率
    self.cpuLab.text = [NSString stringWithFormat:@"%@:%ld%%",NSLocalizedString(@"CPU Rate",@"CPU使用率"),(long)debugInfo.cpuUseRate];
    
    //可用内存
    self.memoryLab.text = [NSString stringWithFormat:@"%@:%ldMB",NSLocalizedString(@"Available Mem",@"可用内存"),(long)debugInfo.unUsedMemory];
    
    //飞机模式
    self.flyModeLab.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"Plan Mode",@"飞机模式"),debugInfo.flyMode];
    
    //飞机高度
    self.flyHeightLab.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"Plan Height",@"飞机高度"),debugInfo.flyHeight];
    
    //起飞时长
    self.flyTimeLab.text = [NSString stringWithFormat:@"%@:%ld秒",NSLocalizedString(@"Takeoff Time",@"起飞时长"),debugInfo.flyTime];
    
}

@end
