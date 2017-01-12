//
//  CDAddOrEditNoteViewController.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseViewController.h"
#import "CDNoteModel.h"

@interface CDAddOrEditNoteViewController : CDBaseViewController

- (instancetype)initWithControllerType:(NSInteger)type andNoteModel:(CDNoteModel *)noteModel;

@end
