//
//  CDVoiceCollectionCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDVoiceCollectionCell : UICollectionViewCell

@property (nonatomic,retain) NSString *path;


- (void)setup;

//- (void)setButtonPlayerAction:(SEL)action andTarget:(id)target;
- (void)setButtonDeleteAction:(SEL)action andTarget:(id)target;

@end
