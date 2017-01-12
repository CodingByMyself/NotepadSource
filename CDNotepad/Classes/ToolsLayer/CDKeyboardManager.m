//
//  CDKeyboardManager.m
//  MangocityTravel
//
//  Created by Cindy on 2016/11/14.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import "CDKeyboardManager.h"

@implementation CDKeyboardManager

/**
 *  键盘管理类的单实例
 *
 *  @return 单例
 */
+ (instancetype)sharedKeyboard
{
    static CDKeyboardManager *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[CDKeyboardManager alloc] init]; //  初始化单例
        // 注册键盘事件
        
        // 显示
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

        // 隐藏
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
        // UITextField输入文字改变通知
        [[NSNotificationCenter defaultCenter] addObserver:_shared selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        
    });
    return _shared;
}

- (void)releaseManager
{
    // 注销键盘事件
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


#pragma mark  Notification keyboard event
- (void)keyboardDidHide:(NSNotification *)notify
{
    NSLog(@"键盘隐藏");
    _keyboardVisible = NO;
    if (_eventDelegate && [_eventDelegate respondsToSelector:@selector(keyboardDidHideEventByUserInfo:)]) {
        [_eventDelegate keyboardDidHideEventByUserInfo:[notify userInfo]];
    }
}

- (void)keyboardWillHide:(NSNotification *)notify
{
    NSLog(@"键盘隐藏");
    _keyboardVisible = NO;
    if (_eventDelegate && [_eventDelegate respondsToSelector:@selector(keyboardWillHiddenEventByUserInfo:)]) {
        [_eventDelegate keyboardWillHiddenEventByUserInfo:[notify userInfo]];
    }
}

- (void)keyboardDidShow:(NSNotification *)notify
{
    NSLog(@"键盘显示");
    _keyboardVisible = YES;
    if (_eventDelegate && [_eventDelegate respondsToSelector:@selector(keyboardDidShowEventByUserInfo:)]) {
        [_eventDelegate keyboardDidShowEventByUserInfo:[notify userInfo]];
    }
}

- (void)keyboardWillShow:(NSNotification *)notify
{
    NSLog(@"键盘显示");
    _keyboardVisible = YES;
    if (_eventDelegate && [_eventDelegate respondsToSelector:@selector(keyboardWillShowEventByUserInfo:)]) {
        [_eventDelegate keyboardWillShowEventByUserInfo:[notify userInfo]];
    }
}

#pragma mark 
- (void)textFieldTextDidChange:(NSNotification *)notify
{
//    MGDetailLog(@"%@",notify);
    if (_eventDelegate && [_eventDelegate respondsToSelector:@selector(textFieldTheTextChanged:)]) {
        [_eventDelegate textFieldTheTextChanged:[notify object]];
    }
}




@end
