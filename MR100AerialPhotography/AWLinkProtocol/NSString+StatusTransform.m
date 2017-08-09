//
//  NSString+StatusTransform.m
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/3.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import "NSString+StatusTransform.h"

@implementation NSString (StatusTransform)

//飞行器的飞行模式,字符串表示
+(NSString*)flyModelTransform:(NSInteger)num
{
    NSString * str = @"";
    switch (num) {
        case 0:
            str = @"Stabilize";
            break;
        case 1:
            str = @"althold";
            break;

        case 2:
            str = @"poshold";
            break;

        case 3:
            str = @"takeoff";
            break;

        case 4:
            str = @"land";
            break;

        case 5:
            str = @"followme";
            break;

        case 6:
            str = @"auto";
            break;

        case 7:
            str = @"circle";
            break;

        case 8:
            str = @"flip";
            break;

        case 9:
            str = @"RTL";
            break;

        case 10:
            str = @"STOP";
            break;

        case 11:
            str = @"LOCAL360";
            break;
        case 12:
            str = @"Findme";
            break;
        default:
            str = @"other";
            break;
    }
    
    return str;
}

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal {
    
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}


@end
