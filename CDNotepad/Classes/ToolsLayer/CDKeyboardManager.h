//
//  CDKeyboardManager.h
//  MangocityTravel
//
//  Created by Cindy on 2016/11/14.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDKeyboardManagerDelegate <NSObject>

@optional
- (void)keyboardDidShowEventByUserInfo:(NSDictionary *)userInfo;
- (void)keyboardWillShowEventByUserInfo:(NSDictionary *)userInfo;

- (void)keyboardWillHiddenEventByUserInfo:(NSDictionary *)userInfo;
- (void)keyboardDidHideEventByUserInfo:(NSDictionary *)userInfo;

- (void)textFieldTheTextChanged:(UITextField *)textField;

@end

@interface CDKeyboardManager : NSObject

@property (nonatomic,weak) id <CDKeyboardManagerDelegate> eventDelegate;  //  事件代理
@property (nonatomic,readonly) BOOL  keyboardVisible;  //  键盘是否处于显示状态的标志


/**
 *  键盘管理类的单实例
 *
 *  @return 单例
 */
+ (instancetype)sharedKeyboard;
- (void)releaseManager;


@end
