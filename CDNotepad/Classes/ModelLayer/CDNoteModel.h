//
//  CDNoteModel.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseObject.h"

@interface CDNoteModel : CDBaseObject

@property (nonatomic,assign) NSInteger noteId;
@property (nonatomic,retain) NSString *title;

@property (nonatomic,strong) NSMutableArray *voicePathList;
@property (nonatomic,strong) NSMutableArray *picturePathList;

@property (nonatomic,strong) NSDate *createDate;

@property (nonatomic,assign) BOOL mark;



- (BOOL)insertTable;
+ (NSArray *)allObject;
+ (NSArray *)queryObjectByCondition:(NSString *)condition;
- (BOOL)deleteObject;
- (BOOL)updateObject;

@end
