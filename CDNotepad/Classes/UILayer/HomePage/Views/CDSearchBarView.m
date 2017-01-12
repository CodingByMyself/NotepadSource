//
//  CDSearchBarView.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDSearchBarView.h"


@interface CDSearchBarView ()
@property (nonatomic,strong) UIView *viewBg;
@end

@implementation CDSearchBarView
@synthesize textField = _textField;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.textField.placeholder = @"请输入搜索关键字";
}

#pragma mark - Getter Method
- (UIView *)viewBg
{
    if (_viewBg == nil) {
        _viewBg = [[UIView alloc] init];
        _viewBg.layer.cornerRadius = 4.0f;
        _viewBg.layer.borderColor = DefineColorRGB(200, 200, 200, 0.8).CGColor;
        _viewBg.layer.borderWidth = 0.8;
        [self addSubview:_viewBg];
        [_viewBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(6.0);
            make.bottom.equalTo(self).offset(-6.0);
            make.left.equalTo(self);
            make.right.equalTo(self);
        }];
    }
    return _viewBg;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"请输入搜索关键字";
        _textField.font = UIFONT_14;
        _textField.textColor = COLOR_TITLE2;
        
        [self.viewBg addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewBg).offset(10);
            make.right.equalTo(self.viewBg).offset(-10);
            make.top.equalTo(self.viewBg);
            make.bottom.equalTo(self.viewBg);
        }];
        
        
    }
    return _textField;
}


@end
