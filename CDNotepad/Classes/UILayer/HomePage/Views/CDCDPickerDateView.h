//
//  CDCDPickerDateView.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN CGFloat const CDDatePickerViewHeight;

@interface CDCDPickerDateView : UIView

@property (nonatomic,assign) NSInteger showConentType; // 默认0：显示日期；1：显示时间

- (void)showPickerViewOnTargetView:(UIView *)targetView;
- (void)hiddenPickerView;

- (void)setButtonActionEvent:(SEL)action andTarget:(id)target;

- (NSString *)selectedDataInComponent:(NSInteger)component;

@end
