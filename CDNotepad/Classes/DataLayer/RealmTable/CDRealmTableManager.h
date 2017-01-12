//
//  CDRealmTableManager.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDNoteTable.h"
#import "CDResourceTable.h"


@interface CDRealmTableManager : NSObject

#pragma mark - create data base
+ (RLMRealm *)defaultDatabase;

#pragma mark - 插入一条笔记本数据
+ (BOOL)insertObject:(CDBaseTable *)obj;
+ (BOOL)insertObject:(CDNoteTable *)note andRelationObjects:(NSArray <CDResourceTable *>*)resourceList;
#pragma mark - 查询
+ (RLMResults *)queryObjectListByCondition:(NSString *)condition fromClassName:(NSString *)className;
#pragma mark - 删除
+ (BOOL)deleteObject:(CDBaseTable *)obj;
#pragma mark - 更新
+ (BOOL)updateObject:(CDBaseTable *)obj;
@end
