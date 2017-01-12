//
//  CDNoteTable.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//
#import "CDBaseTable.h"

@interface CDNoteTable : CDBaseTable

@property BOOL note_mark; // 是否被标记
@property NSString *note_content; // 笔记文本内容
@property NSString *note_create_date;  // 笔记创建时间 存储格式为：“yyyyMMddHHmmss”


@property NSString *reserve_one; //  预留字段1
@property NSString *reserve_two; //  预留字段2

@end
