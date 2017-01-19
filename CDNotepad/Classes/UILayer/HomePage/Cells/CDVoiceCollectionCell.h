//
//  CDVoiceCollectionCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDVoiceCollectionCell;

@protocol CDVoiceCollectionCellDelegate <NSObject>

- (void)voiceCell:(CDVoiceCollectionCell *)cell buttonDeleteCicked:(UIButton *)button;

@end

@interface CDVoiceCollectionCell : UICollectionViewCell

@property (nonatomic,weak) id <CDVoiceCollectionCellDelegate> delegate;

@property (nonatomic,retain) NSString *path;


- (void)setup;

//- (void)setButtonPlayerAction:(SEL)action andTarget:(id)target;
//- (void)setButtonDeleteAction:(SEL)action andTarget:(id)target;

- (void)setDisableEidt;

@end
