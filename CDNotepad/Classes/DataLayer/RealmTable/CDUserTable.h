//
//  CDUserTable.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseTable.h"

@interface CDUserTable : CDBaseTable

@property NSString *name; // 用户登录名
@property NSString *nick_name; // 用户昵称
@property NSString *password; // 用户密码

@end
