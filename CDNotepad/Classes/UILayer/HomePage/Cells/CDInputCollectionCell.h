//
//  CDInputCollectionCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDInputCollectionCell : UICollectionViewCell

- (void)setup:(NSString *)text OnInputTextChanged:(void(^)(NSString *textString))textCahnged;

- (void)setDisableEidt;

@end
