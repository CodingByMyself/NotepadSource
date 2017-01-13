//
//  CDLoginInputCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDLoginInputCell.h"


@interface CDLoginInputCell ()
@property (nonatomic,strong) UIView *viewBg;
@property (nonatomic,strong) UIImageView *imageViewIcon;
//@property (nonatomic,strong) UITextField *textField;

@end


@implementation CDLoginInputCell
@synthesize textField = _textField;

- (void)setup
{
    self.viewBg.backgroundColor = [UIColor whiteColor];
    self.imageViewIcon.image = [UIImage imageNamed:@"login_page_user_name_icon"];
    self.textField.text = @"";
}

- (void)setInputType:(NSInteger)type
{
    switch (type) {
        case 0:
        {
            self.textField.placeholder = @"请输入用户名";
            self.textField.secureTextEntry = NO;
//            self.textField.keyboardType
        }
            break;
        case 1:
        {
            self.textField.placeholder = @"请输入密码";
            self.textField.secureTextEntry = YES;
        }
            break;
        case 2:
        {
            self.textField.placeholder = @"请输入确认密码";
            self.textField.secureTextEntry = YES;
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter Method
- (UIView *)viewBg
{
    if (_viewBg == nil) {
        _viewBg = [[UIView alloc] init];
        _viewBg.layer.cornerRadius = 5.0;
        _viewBg.layer.borderColor = DefineColorRGB(210, 210, 210, 0.6).CGColor;
        _viewBg.layer.borderWidth = 0.8;
        
        [self addSubview:_viewBg];
        [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(CDScreenMarginAtLeftAndRight*2);
            make.right.equalTo(self).offset(-CDScreenMarginAtLeftAndRight*2);
            make.centerY.equalTo(self);
            make.height.equalTo(@40.0);
        }];
    }
    return _viewBg;
}

- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil) {
        _imageViewIcon = [[UIImageView alloc] init];
        _imageViewIcon.image = [UIImage imageNamed:@"login_page_user_name_icon"];
        _imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.viewBg addSubview:_imageViewIcon];
        [_imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewBg).offset(5.0);
            make.centerY.equalTo(self);
            make.width.equalTo(@20.0);
            make.height.equalTo(_imageViewIcon.mas_width);
        }];
        
    }
    return _imageViewIcon;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入用户名";
        _textField.font = UIFONT_14;
        _textField.textColor = COLOR_TITLE2;
        
        [self.viewBg addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageViewIcon.mas_right).offset(10);
            make.right.equalTo(self.viewBg).offset(-10);
            make.top.equalTo(self.viewBg);
            make.bottom.equalTo(self.viewBg);
        }];
        
    }
    return _textField;
}


@end
