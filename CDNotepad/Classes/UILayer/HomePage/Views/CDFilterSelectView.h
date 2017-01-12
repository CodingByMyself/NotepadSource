//
//  CDFilterSelectView.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDFilterSelectView : UIView

- (instancetype)initWithFilterDataList:(NSArray *)array onSelectedBlock:(void(^)(NSInteger index))selectedBlock;

@end
