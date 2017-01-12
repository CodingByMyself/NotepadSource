//
//  CDAlertObject.h
//  MangocityTravel
//
//  Created by Cindy on 2016/12/15.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, CDAlertObjectStyle) {
    CDAlertObjectStyleAlert = 0,
    CDAlertObjectStyleActionSheet
};


@interface CDAlertObject : NSObject

#pragma mark - 重写一个初始化方法

/**
 初始化一个弹框控件

 @param style 弹框风格样式
 @param title 标题
 @param message 消息内容
 @param cancelButtonTitle 取消按钮标题
 @param otherButtonTitles 其他按钮标题的集合
 @param clickAction 点击事件的回调
 @return 弹框控件的一个实例对象
 */
+ (instancetype)alertPreferredStyle:(CDAlertObjectStyle)style withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles eventOfClickedBlock:(void(^)(NSInteger indexClick))clickAction;


/**
 显示弹框
 */
- (void)showAlert;
- (void)showAlertOnController:(UIViewController *)target;


@end
