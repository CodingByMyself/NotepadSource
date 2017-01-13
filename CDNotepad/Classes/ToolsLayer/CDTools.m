//
//  CDTools.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDTools.h"

@implementation CDTools


/**
 获取应用沙盒目录的绝对地址

 @return 沙盒目录地址
 */
+ (NSString *)getSandboxPath
{
    NSString *sandboxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return sandboxPath;
}


/**
 去掉前后空格

 @param string 目标字符串
 @return 去掉前后空格的目的字符串
 */
+ (NSString *)stringByTrimmingCharacters:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - 字符串校验
/**
 纯数字或字母
 
 @param string 目标字符串
 @return 结果
 */
+(BOOL)validateIsOnlyNumberOrLetter:(NSString *)string
{
    BOOL isValid = NO;
    if (string.length > 0) {
        for (NSInteger i=0; i<string.length; i++) {
            unichar chr = [string characterAtIndex:i];
            if (chr < 0x80) { //字符
                if (chr >= 'a' && chr <= 'z') {
                    isValid = YES;
                } else if (chr >= 'A' && chr <= 'Z') {
                    isValid = YES;
                } else if (chr >= '0' && chr <= '9') {
                    isValid = YES;
                } else {
                    isValid = NO;
                }
            } else { //无效字符
                isValid = NO;
            }
            
            if (!isValid) {
                break;
            }
        }
    }
    
    return isValid;
}

@end
