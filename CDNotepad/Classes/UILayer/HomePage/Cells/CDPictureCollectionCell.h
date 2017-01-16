//
//  CDPictureCollectionCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDPictureCollectionCell;

@protocol CDPictureCollectionCellDelegate <NSObject>

- (void)collectionPictiureCell:(CDPictureCollectionCell *)cell buttonClicked:(UIButton *)button;

@end

@interface CDPictureCollectionCell : UICollectionViewCell

@property (nonatomic,assign) id<CDPictureCollectionCellDelegate> delegate;

- (void)setImage:(UIImage *)image andButtonImage:(UIImage *)imageButton;
- (void)updateButtonImage:(UIImage *)image;


@end
