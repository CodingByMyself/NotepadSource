//
//  CDSelectPictureViewController.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseViewController.h"

@interface CDSelectPictureViewController : CDBaseViewController

@property (nonatomic,copy) void (^selectedComplete)(NSArray *pathList);

@property (nonatomic,strong) NSMutableArray <NSString *>* oldSelectedPathList;

@end
