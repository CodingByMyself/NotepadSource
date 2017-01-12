//
//  CDNoteItemCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseTableViewCell.h"
#import "CDNoteModel.h"

@interface CDNoteItemCell : CDBaseTableViewCell

@property (nonatomic,strong) CDNoteModel *noteModel;



- (CGFloat)fitHeightByNote:(CDNoteModel *)noteModel;

@end
