//
//  CDSharedDataManager.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDSharedDataManager.h"



@interface CDSharedDataManager ()



@end


@implementation CDSharedDataManager


+ (CDSharedDataManager *)shareManager
{
    static CDSharedDataManager *shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc]init];
    });
    return shared;
}


- (void)setCurrentLoginUser:(CDUserModel *)user
{
    _currentUser = user;
}

@end
