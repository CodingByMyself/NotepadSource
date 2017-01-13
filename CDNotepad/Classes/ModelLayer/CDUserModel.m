//
//  CDUserModel.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDUserModel.h"
#import "CDUserTable.h"
#import "CDRealmTableManager.h"

@implementation CDUserModel



#pragma mark - 数据库操作
- (BOOL)insertTable
{
    if ([NSStringFromClass(self.class) isEqualToString:@"CDUserModel"]) {
        // 数据模型
        
        /****** 生成NoteTable表模型 *******/
        CDUserTable *userTable = [[CDUserTable alloc] init];
        userTable.name = self.name;
        userTable.nick_name = self.name;
        userTable.password = self.password;
        
        // 插入完整的数据
        return [CDRealmTableManager insertObject:userTable];
        
    }
    return NO;
}

+ (CDUserModel *)loginByUserName:(NSString *)name andUserPassword:(NSString *)password
{
    CDUserModel *user = [[CDUserModel alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"name = \"%@\" or password = \"%@\"",name,password];
    if ([CDRealmTableManager queryObjectListByCondition:sql fromClassName:[CDUserTable className]].count == 0) {
        user.userId = -2;
        return user;  // 用户不存在
    }
    
    
    NSString *sql2 = [NSString stringWithFormat:@"name = \"%@\" and password = \"%@\"",name,password];
    RLMResults *loginUserResult = [CDRealmTableManager queryObjectListByCondition:sql2 fromClassName:[CDUserTable className]];
    if (loginUserResult.count > 0) {
        CDUserTable *table = [loginUserResult lastObject];
        user.userId = table.rm_id;
        user.name = table.name;
        user.nickName = table.nick_name;
        return user;
    } else {
        user.userId = -1;
        return user;  // 用户名或密码错误
    }
}

+ (BOOL)checkUserIsExistByUserName:(NSString *)userName
{
    NSString *sql = [NSString stringWithFormat:@"name = \"%@\"",userName];
    if ([CDRealmTableManager queryObjectListByCondition:sql fromClassName:[CDUserTable className]].count > 0) {
        return YES;
    } else {
        return NO;
    }
}




@end
