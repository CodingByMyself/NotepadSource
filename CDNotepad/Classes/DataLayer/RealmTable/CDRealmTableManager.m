//
//  CDRealmTableManager.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <Realm/RLMRealm_Dynamic.h>
#import "CDRealmTableManager.h"



NSString *const MGRealmDatabaseName = @"CDNotepadDatabase.realm";


@implementation CDRealmTableManager

#pragma mark - create data base
+ (RLMRealm *)defaultDatabase
{
    static RLMRealm *defaultRealm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        NSString *pathString = [[[[config.fileURL path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Realm"] stringByAppendingPathComponent:MGRealmDatabaseName];
        [[NSFileManager defaultManager] createDirectoryAtPath:[pathString stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        config.fileURL = [NSURL fileURLWithPath:pathString];
        
        //        NSString *tempPath = [NSString stringWithFormat:@"%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
        NSLog(@"database path : %@",[config.fileURL path]);
        
        [RLMRealmConfiguration setDefaultConfiguration:config]; // 将这个配置应用到默认的 Realm 数据库当中
        NSError *error;
        defaultRealm = [RLMRealm realmWithConfiguration:config error:&error]; // 通过这个配置找到（如果没有就新建）一个数据库
        NSLog(@"get realm database retrun error info : %@",error);
    });
    return defaultRealm;
}


#pragma mark - 多表插入
+ (BOOL)insertObject:(CDNoteTable *)note andRelationObjects:(NSArray <CDResourceTable *>*)resourceList
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [temp addObjectsFromArray:resourceList];
    [temp addObject:note];
    if ([self checkObject:temp]) {
        NSError *errorInfo;
        RLMRealm *realm = [CDRealmTableManager defaultDatabase];
        //  得到主键
        CDNoteTable *lastNoteObj = [[[realm allObjects:[[note class] className]] sortedResultsUsingProperty:@"rm_id" ascending:YES] lastObject];
        [realm beginWriteTransaction];  // 开始事务
        // 开始插入第一条数据
        note.rm_id = lastNoteObj.rm_id+1;
//        RLMObject *object = (RLMObject *)obj;
        [realm addObject:note];
        [realm commitWriteTransaction:&errorInfo];  // 提交事务
        
        if ([errorInfo isKindOfClass:[NSError class]]) {
            return NO; // 数据插入失败
        } else {
            // 开始插入关联数据
            for (CDResourceTable *resourceTable in resourceList) {
                CDResourceTable *lastResource = [[[realm allObjects:[[resourceTable class] className]] sortedResultsUsingProperty:@"rm_id" ascending:YES] lastObject];
                [realm beginWriteTransaction];  // 开始事务
                resourceTable.rm_id = lastResource.rm_id+1;
                resourceTable.relation_note_id = note.rm_id;
                [realm addObject:resourceTable];
                [realm commitWriteTransaction:&errorInfo];  // 提交事务
                NSLog(@"添加操作的错误信息：%@",errorInfo);
                if ([errorInfo isKindOfClass:[NSError class]]) {
                    return NO; // 数据插入失败
                } else {
                    continue;
                }
            }
        }
        
        // 全部数据插入成功
        return YES;
    } else {
        NSLog(@"传入的被操作对象不是 RLMObject 的子类");
        return NO;
    }
}

#pragma mark 单表插入
+ (BOOL)insertObject:(CDBaseTable *)obj
{
    if ([self checkObject:@[obj]]) {
        NSError *errorInfo;
        RLMRealm *realm = [CDRealmTableManager defaultDatabase];
        //  得到主键
        CDBaseTable *lastObj = [[[realm allObjects:[[obj class] className]] sortedResultsUsingProperty:@"rm_id" ascending:YES] lastObject];
        
        [realm beginWriteTransaction];  // 开始事务
        obj.rm_id = lastObj.rm_id+1;
        // 开始插入数据
        RLMObject *object = (RLMObject *)obj;
        [realm addObject:object];
        [realm commitWriteTransaction:&errorInfo];  // 提交事务
        
        NSLog(@"添加操作的错误信息：%@",errorInfo);
        return  errorInfo ? NO : YES;
    } else {
        NSLog(@"传入的被操作对象不是 RLMObject 的子类");
        return NO;
    }
}

#pragma mark - 查询
+ (RLMResults *)allObjectByClassName:(NSString *)className
{
    RLMRealm *realm = [CDRealmTableManager defaultDatabase];
    return  [realm allObjects:className];
}

+ (RLMResults *)queryObjectListByCondition:(NSString *)condition fromClassName:(NSString *)className
{
    if (condition.length > 0) {
        RLMRealm *realm = [CDRealmTableManager defaultDatabase];
        return [realm objects:className where:condition];
    } else {
        return [CDRealmTableManager allObjectByClassName:className];
    }
}

#pragma mark - 删除
+ (BOOL)deleteObject:(CDBaseTable *)obj
{
    if ([self checkObject:@[obj]]) {
        NSError *errorInfo;
        RLMRealm *realm = [CDRealmTableManager defaultDatabase];
        [realm beginWriteTransaction];  // 开始事务
        [realm deleteObject:obj];
        [realm commitWriteTransaction:&errorInfo];  // 提交事务
        NSLog(@"删除操作的错误信息：%@",errorInfo);
        return  errorInfo ? NO : YES;
    } else {
        NSLog(@"传入的被操作对象不是 RLMObject 的子类");
        return NO;
    }
}

#pragma mark - 更新
+ (BOOL)updateObject:(CDBaseTable *)obj
{
    if ([self checkObject:@[obj]]) {
        NSError *errorInfo;
        RLMRealm *realm = [CDRealmTableManager defaultDatabase];
        [realm beginWriteTransaction];  // 开始事务
        [realm addOrUpdateObject:obj];
        [realm commitWriteTransaction:&errorInfo];  // 提交事务
        NSLog(@"更新操作的错误信息：%@",errorInfo);
        return  errorInfo ? NO : YES;
    } else {
        NSLog(@"传入的被操作对象不是 RLMObject 的子类");
        return NO;
    }
}


#pragma mark - Private Method
+ (BOOL)checkObject:(NSArray *)checkList
{
    for (NSObject *obj in checkList) {
        if ([obj isKindOfClass:[RLMObject class]] == NO) {
            return NO;
        }
    }
    return YES;
}



@end
