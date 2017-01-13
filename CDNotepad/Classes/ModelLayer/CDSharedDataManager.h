//
//  CDSharedDataManager.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseObject.h"
#import "CDUserModel.h"


@interface CDSharedDataManager : CDBaseObject

@property (nonatomic,readonly) CDUserModel *currentUser;





+ (CDSharedDataManager *)shareManager;

- (void)setCurrentLoginUser:(CDUserModel *)user;

@end
