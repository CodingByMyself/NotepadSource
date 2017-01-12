//
//  CDButton.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDButton.h"

@implementation CDButton
@synthesize labelButtonTitle = _labelButtonTitle;
@synthesize imageViewButtonIcon = _imageViewButtonIcon;

#pragma mark - init method
- (instancetype)initWithStyle:(CDButtonStyles)buttonStyle
{
    self = [super init];
    if (self) {
        _buttonStyle = buttonStyle;
    }
    return self;
}

- (void)reloadedConstraintOnView
{
    switch (self.buttonStyle) {
        case CDButtonStyleIsOnlyIcon:
        {
            [self.labelButtonTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.top.equalTo(self);
                make.bottom.equalTo(self);
            }];
        }
            break;
        case CDButtonStyleIsOnlyTitle:
        {
            [self.imageViewButtonIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.centerX.equalTo(self);
                make.height.equalTo(@(self.iconSize.height > 0 ? self.iconSize.height : 30));
                make.width.equalTo(@(self.iconSize.width > 0 ? self.iconSize.width : 30));
            }];
        }
            break;
        case CDButtonStyleIsTopIconAndBottomTitle:
        {
            [self.imageViewButtonIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self).offset(-6.0);
                make.centerX.equalTo(self);
                make.height.equalTo(@(self.iconSize.height > 0 ? self.iconSize.height : 30));
                make.width.equalTo(@(self.iconSize.width > 0 ? self.iconSize.width : 30));
            }];
            
            [self.labelButtonTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.top.equalTo(self.imageViewButtonIcon.mas_bottom);
//                make.bottom.equalTo(self);
            }];
        }
            break;
        case CDButtonStyleIsLeftIconAndRightTitle:
        {
            
        }
            break;
        case CDButtonStyleIsRightIconAndLeftTitle:
        {
            
        }
            break;
        default:
            break;
    }
    [self.labelButtonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}


#pragma mark - Getter Method
- (UILabel *)labelButtonTitle
{
    if (_labelButtonTitle == nil) {
        _labelButtonTitle = [[UILabel alloc] init];
        _labelButtonTitle.font = UIFONT_14;
        _labelButtonTitle.textColor = COLOR_TITLE1;
        [self addSubview:_labelButtonTitle];
    }
    return _labelButtonTitle;
}

- (UIImageView *)imageViewButtonIcon
{
    if (_imageViewButtonIcon == nil) {
        _imageViewButtonIcon = [[UIImageView alloc] init];
        _imageViewButtonIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageViewButtonIcon];
    }
    return _imageViewButtonIcon;
}

@end
