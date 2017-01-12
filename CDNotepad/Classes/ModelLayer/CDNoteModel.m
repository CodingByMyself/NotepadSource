//
//  CDNoteModel.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDNoteModel.h"

#import "CDRealmTableManager.h"
#import "CDNoteTable.h"
#import "CDResourceTable.h"

@implementation CDNoteModel


#pragma mark - 数据库操作
- (BOOL)insertTable
{
    if ([NSStringFromClass(self.class) isEqualToString:@"CDNoteModel"]) {
        // 笔记数据模型
        CDNoteModel *noteModel = self;
        
        /****** 生成NoteTable表模型 *******/
        CDNoteTable *noteTable = [[CDNoteTable alloc] init];
        noteTable.note_content = noteModel.title;
        noteTable.note_create_date = [CDDateHelper date:noteModel.createDate toStringByFormat:@"yyyyMMddHHmmss"];
        

        /****** 生成ResourceTable表模型 *******/
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSString *path in noteModel.voicePathList) {
            CDResourceTable *resourceTable = [[CDResourceTable alloc] init];
            resourceTable.resource_path = path;
            resourceTable.resource_type = 1;
            [temp addObject:resourceTable];
        }
        for (NSString *path in noteModel.picturePathList) {
            CDResourceTable *resourceTable = [[CDResourceTable alloc] init];
            resourceTable.resource_path = path;
            resourceTable.resource_type = 0;
            [temp addObject:resourceTable];
        }
        
        // 插入完整的数据
        return [CDRealmTableManager insertObject:noteTable andRelationObjects:temp];
        
        
    } else {
        
    }
    return NO;
}

+ (NSArray *)allObject
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    RLMResults *allNoteList = [CDRealmTableManager queryObjectListByCondition:nil fromClassName:[CDNoteTable className]];
    for (CDNoteTable *noteTable in allNoteList) {
        CDNoteModel *model = [[CDNoteModel alloc] init];
        model.noteId = noteTable.rm_id;
        model.title = noteTable.note_content;
        model.createDate = [CDDateHelper dateFromString:noteTable.note_create_date byFormat:@"yyyyMMddHHmmss"];
        // 附件
        NSString *sql = [NSString stringWithFormat:@"relation_note_id = %zi",model.noteId];
        RLMResults *relationResourceList = [CDRealmTableManager queryObjectListByCondition:sql fromClassName:[CDResourceTable className]];
        for (CDResourceTable *resource in relationResourceList) {
            if (resource.resource_type == 0) {
                [model.picturePathList addObject:resource.resource_path];
            } else if (resource.resource_type == 1) {
                [model.voicePathList addObject:resource.resource_path];
            }
        }
        
        [temp addObject:model];
    }
    // 按时间来排序
    [temp sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CDNoteModel *model1 = (CDNoteModel *)obj1;
        CDNoteModel *model2 = (CDNoteModel *)obj2;
        if ([model1.createDate timeIntervalSince1970] > [model2.createDate timeIntervalSince1970]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return [NSArray arrayWithArray:temp];
}

+ (NSArray *)queryObjectByCondition:(NSString *)condition
{
    NSMutableArray *tempObjectList = [[NSMutableArray alloc] init];
    RLMResults *listObject = [CDRealmTableManager queryObjectListByCondition:condition fromClassName:[CDNoteTable className]];
    for (CDNoteTable *noteTable in listObject) {
        CDNoteModel *model = [[CDNoteModel alloc] init];
        model.noteId = noteTable.rm_id;
        model.title = noteTable.note_content;
        model.createDate = [CDDateHelper dateFromString:noteTable.note_create_date byFormat:@"yyyyMMddHHmmss"];
        // 附件
        NSString *sql = [NSString stringWithFormat:@"relation_note_id = %zi",model.noteId];
        RLMResults *relationResourceList = [CDRealmTableManager queryObjectListByCondition:sql fromClassName:[CDResourceTable className]];
        for (CDResourceTable *resource in relationResourceList) {
            if (resource.resource_type == 0) {
                [model.picturePathList addObject:resource.resource_path];
            } else if (resource.resource_type == 1) {
                [model.voicePathList addObject:resource.resource_path];
            }
        }
        
        [tempObjectList addObject:model];
    }
    // 按时间来排序
    [tempObjectList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CDNoteModel *model1 = (CDNoteModel *)obj1;
        CDNoteModel *model2 = (CDNoteModel *)obj2;
        if ([model1.createDate timeIntervalSince1970] > [model2.createDate timeIntervalSince1970]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return [NSArray arrayWithArray:tempObjectList];
}

- (BOOL)deleteObject
{
    NSString *sqlOne = [NSString stringWithFormat:@"rm_id = %zi",self.noteId];
    RLMResults *noteList = [CDRealmTableManager queryObjectListByCondition:sqlOne fromClassName:[CDNoteTable className]];
    for (CDNoteTable *table in noteList) {
        if ([CDRealmTableManager deleteObject:table]) {
            continue;
        } else {
            return NO;
        }
    }
    
    // 同时删除附件资源
    NSString *sqlTwo = [NSString stringWithFormat:@"relation_note_id = %zi",self.noteId];
    RLMResults *relationResourceList = [CDRealmTableManager queryObjectListByCondition:sqlTwo fromClassName:[CDResourceTable className]];
    for (CDResourceTable *table in relationResourceList) {
        [CDRealmTableManager deleteObject:table];
    }
    
    return YES;
}

- (BOOL)updateObject
{
    NSString *sqlOne = [NSString stringWithFormat:@"rm_id = %zi",self.noteId];
    RLMResults *noteList = [CDRealmTableManager queryObjectListByCondition:sqlOne fromClassName:[CDNoteTable className]];
    
    for (CDNoteTable *table in noteList) {
        NSError *errorInfo;
        [[CDRealmTableManager defaultDatabase] beginWriteTransaction];
        table.note_content = self.title;
        table.note_create_date = [CDDateHelper date:self.createDate toStringByFormat:@"yyyyMMddHHmmss"];
        [[CDRealmTableManager defaultDatabase] commitWriteTransaction:&errorInfo];
        if (errorInfo) {
            return NO;
        }
    }
    
    NSString *sqlTwo = [NSString stringWithFormat:@"relation_note_id = %zi",self.noteId];
    RLMResults *relationResourceList = [CDRealmTableManager queryObjectListByCondition:sqlTwo fromClassName:[CDResourceTable className]];
    
    /****** 更新附件资源 *******/
    // 先删除已经废弃的资源
    for (CDResourceTable *table in relationResourceList) {
        if (table.resource_type == 0) {
            if ([self.voicePathList containsObject:table.resource_path] == NO) {
                [CDRealmTableManager deleteObject:table];
            }
        } else if (table.resource_type == 1) {
            if ([self.picturePathList containsObject:table.resource_path] == NO) {
                [CDRealmTableManager deleteObject:table];
            }
        }
    }
    
    NSString *sqlTwo2 = [NSString stringWithFormat:@"relation_note_id = %zi",self.noteId];
    RLMResults *resourceList = [CDRealmTableManager queryObjectListByCondition:sqlTwo2 fromClassName:[CDResourceTable className]];
    NSMutableArray *tempPathList = [NSMutableArray array];
    for (CDResourceTable *table in resourceList) {
        [tempPathList addObject:table.resource_path];
    }
    // 再检测是否有新添加的
    for (NSString *path in self.voicePathList) {
        if ([tempPathList containsObject:path] == NO) {
            CDResourceTable *resourceTable = [[CDResourceTable alloc] init];
            resourceTable.relation_note_id = self.noteId;
            resourceTable.resource_path = path;
            resourceTable.resource_type = 1;
            [CDRealmTableManager insertObject:resourceTable];
        }
    }
    for (NSString *path in self.picturePathList) {
        if ([tempPathList containsObject:path] == NO) {
            CDResourceTable *resourceTable = [[CDResourceTable alloc] init];
            resourceTable.relation_note_id = self.noteId;
            resourceTable.resource_path = path;
            resourceTable.resource_type = 0;
            [CDRealmTableManager insertObject:resourceTable];
        }
    }
    

    return YES;
    
}



#pragma mark - Getter Method
- (NSMutableArray *)voicePathList
{
    if ([_voicePathList isKindOfClass:[NSMutableArray class]] == NO) {
        _voicePathList = [[NSMutableArray alloc] init];
    }
    return _voicePathList;
}

- (NSMutableArray *)picturePathList
{
    if ([_picturePathList isKindOfClass:[NSMutableArray class]] == NO) {
        _picturePathList = [[NSMutableArray alloc] init];
    }
    return _picturePathList;
}




@end
