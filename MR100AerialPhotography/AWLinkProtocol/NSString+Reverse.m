//
//  NSString+Reverse.m
//  CRC16Demo
//
//  Created by xzw on 17/8/3.
//  Copyright © 2017年 xzw. All rights reserved.
//

#import "NSString+Reverse.h"

@implementation NSString (Reverse)

-(NSMutableString *)twoBitReverse{
    NSMutableString *newStr = [NSMutableString string];
    NSInteger length = self.length;
    for (int i = 0; i < length / 2; i++) {
        NSString *str1 = [self substringWithRange:NSMakeRange(length - (i+1) * 2 , 2)];
        
        [newStr insertString:str1 atIndex:i * 2];
    }
    return newStr;
}

@end
