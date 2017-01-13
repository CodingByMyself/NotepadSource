//
//  CDTools.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDTools : NSObject

+ (NSString *)getSandboxPath;


/**
 去掉前后空格
 
 @param string 目标字符串
 @return 去掉前后空格的目的字符串
 */
+ (NSString *)stringByTrimmingCharacters:(NSString *)string;


#pragma mark - 字符串校验
/**
 纯数字或字母
 
 @param string 目标字符串
 @return 结果
 */
+(BOOL)validateIsOnlyNumberOrLetter:(NSString *)string;




@end
