//
//  CDResourceTable.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//
#import "CDBaseTable.h"

@interface CDResourceTable : CDBaseTable

@property NSInteger relation_note_id; // 关联笔记的id即该附件所笔记的id
@property NSInteger resource_type; // 资源类型，如：0：图片；1：录音
@property NSString *resource_path;  // 资源在沙盒中存储的相对路径


@property NSString *reserve_one; //  预留字段1
@property NSString *reserve_two; //  预留字段2

@end
