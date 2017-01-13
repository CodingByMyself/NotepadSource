//
//  CDLoginButtonCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseTableViewCell.h"

@interface CDLoginButtonCell : CDBaseTableViewCell

- (void)setButtonAction:(SEL)action andTarget:(id)target;

- (void)setButtonType:(NSInteger)type;

@end
