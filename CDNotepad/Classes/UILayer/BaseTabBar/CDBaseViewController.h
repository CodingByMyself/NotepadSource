//
//  CDBaseViewController.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDBaseViewController : UIViewController


#pragma mark - Tips View
/**
 *  调用即可显示吐司内容的视图
 *  注意：showTipsViewText:方法不会自动消失，需要主动调用hiddenTipsView方法才能消失
 *
 *  @param text 提示的文本内容
 */
- (void)showTipsViewText:(NSString *)text;

/**
 *  调用即可显示吐司内容的视图；
 *  注意：showTipsViewText:delayTime:方法会在吐司显示了 传入的time时长后 自动消失，无需调用hiddenTipsView方法；
 *
 *  @param text 提示的文本内容
 *  @param time 持续时间即指定时间长度后消失
 */
- (void)showTipsViewText:(NSString *)text delayTime:(CGFloat)time;

/**
 *  调用即可令吐司视图消失
 */
- (void)hiddenTipsView;


@end
