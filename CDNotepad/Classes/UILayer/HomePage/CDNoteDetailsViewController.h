//
//  CDNoteDetailsViewController.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseViewController.h"
@class CDNoteModel;

@interface CDNoteDetailsViewController : CDBaseViewController

- (instancetype)initWithNote:(CDNoteModel *)noteModel;

@end
