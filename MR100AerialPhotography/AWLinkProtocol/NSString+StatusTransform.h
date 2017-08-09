//
//  NSString+StatusTransform.h
//  MR100AerialPhotography
//
//  Created by xzw on 17/8/3.
//  Copyright © 2017年 AllWinner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StatusTransform)

//飞行器的飞行模式,字符串表示
+(NSString*)flyModelTransform:(NSInteger)num;

+ (NSString *)getHexByDecimal:(NSInteger)decimal;

@end
