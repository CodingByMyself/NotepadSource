//
//  CDUserModel.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseObject.h"

@interface CDUserModel : CDBaseObject

@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,retain) NSString *name; // 用户登录名
@property (nonatomic,retain) NSString *password; // 用户密码

@property (nonatomic,retain) NSString *nickName; // 用户昵称





+ (BOOL)updateCurrentLoginUserInfo;

#pragma mark - 数据库操作
- (BOOL)insertTable;
+ (CDUserModel *)loginByUserName:(NSString *)name andUserPassword:(NSString *)password;
+ (BOOL)checkUserIsExistByUserName:(NSString *)userName;
@end
