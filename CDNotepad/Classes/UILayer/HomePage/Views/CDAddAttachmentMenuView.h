//
//  CDAddAttachmentMenuView.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDAddAttachmentMenuView;

UIKIT_EXTERN const CGFloat AddAttachmentMenuHeight;


@protocol CDAddAttachmentMenuViewDelegate <NSObject>

- (void)menuView:(CDAddAttachmentMenuView *)menuView buttonSelectPictureClicked:(UIButton *)button;
- (void)menuView:(CDAddAttachmentMenuView *)menuView makeVoiceFinishedOnFilePath:(NSString *)filePath;
- (void)menuView:(CDAddAttachmentMenuView *)menuView selectedDate:(NSDate *)selectedDate;

@end

@interface CDAddAttachmentMenuView : UIView

@property (nonatomic,weak) id <CDAddAttachmentMenuViewDelegate> delegate;

- (void)setActionEvent:(SEL)action andTarget:(id)target;

@end
