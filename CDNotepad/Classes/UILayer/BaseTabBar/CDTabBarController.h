//
//  CDTabBarController.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CDBaseViewController;

@interface CDTabBarController : UITabBarController



// 当前屏幕上正在显示的控制器
@property (nonatomic,readonly) CDBaseViewController *currentDisplayController;


#pragma mark - 获取底部导航控制器

/**
 *  获取并生成一个底部导航控制器的单实例
 * 注：因为整个App运行过程中只会有一个底部导航控制器，所以写成单例；
 * 方便在任何地方通过 " [CDTabBarController sharedTabBarController] " 去访问该实例对象以及其公开的成员属性；
 *
 *  @return 底部导航控制器的单实例
 */
+ (instancetype)sharedTabBarController;

#pragma mark - 隐藏 底部标签导航
/**
 *  隐藏底部导航视图
 */
- (void)hideCustomTabbar;
#pragma mark 显示 底部标签导航
/**
 *  显示底部导航视图
 */
- (void)showCustomTabbar;

#pragma mark 设置 选择底部指定的标签项
- (void)setSelectedBottomItemOfIndex:(NSUInteger)index;




@end
