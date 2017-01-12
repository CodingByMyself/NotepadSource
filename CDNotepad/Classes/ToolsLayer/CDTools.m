//
//  CDTools.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDTools.h"

@implementation CDTools


+ (NSString *)getSandboxPath
{
    NSString *sandboxPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    return sandboxPath;
}

@end
