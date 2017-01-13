//
//  CDLoginButtonCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDLoginButtonCell.h"


@interface CDLoginButtonCell ()
{
//    UIButton *_loginButton;
    UIButton *_registerButton;
}
@property (nonatomic,strong) UIButton *buttonLogin;
@end

@implementation CDLoginButtonCell

- (void)setup
{
    self.buttonLogin.tag = 1;
}

- (void)setButtonAction:(SEL)action andTarget:(id)target
{
    [self.buttonLogin addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.buttonLogin.tag = 1;
    
    [_registerButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    _registerButton.tag = 2;
}

- (void)setButtonType:(NSInteger)type
{
    if (type == 0) {
        // 登录
        _registerButton.hidden = NO;
        [self.buttonLogin setTitle:@"登 录" forState:UIControlStateNormal];
        
    } else if (type == 1) {
        // 注册
        _registerButton.hidden = YES;
        [self.buttonLogin setTitle:@"注 册" forState:UIControlStateNormal];
    } else if (type == 2) {
        // 退出登录
        _registerButton.hidden = YES;
        [self.buttonLogin setTitle:@"退出登录" forState:UIControlStateNormal];
        self.buttonLogin.backgroundColor = [UIColor redColor];
    }
}

#pragma mark - Getter Method
- (UIButton *)buttonLogin
{
    if (_buttonLogin == nil) {
        // 设置footer view
        _buttonLogin = [[UIButton alloc] init];
        _buttonLogin.tag = 1;
        [_buttonLogin setTitle:@"登 录" forState:UIControlStateNormal];
        _buttonLogin.backgroundColor = MainColor;
        [_buttonLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonLogin.layer.cornerRadius = 5.0f;
        [self addSubview:_buttonLogin];
        [_buttonLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30.0);
            make.right.equalTo(self).offset(-30.0);
            make.centerY.equalTo(self);
            make.height.equalTo(@40.0);
        }];
        
        _registerButton = [[UIButton alloc] init];
        _registerButton.tag = 2;
        [_registerButton setTitle:@"没有账号？马上注册" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = UIFONT_12;
        [_registerButton setTitleColor:MainColor forState:UIControlStateNormal];
        [self addSubview:_registerButton];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_buttonLogin);
            make.top.equalTo(_buttonLogin.mas_bottom);
            make.height.equalTo(@35.0);
            make.width.equalTo(@120.0);
        }];
    }
    return _buttonLogin;
}

@end
