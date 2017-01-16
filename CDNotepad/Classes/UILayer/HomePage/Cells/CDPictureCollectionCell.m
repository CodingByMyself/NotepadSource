//
//  CDPictureCollectionCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDPictureCollectionCell.h"

@interface CDPictureCollectionCell ()
@property (nonatomic,strong) UIImageView *imageViewPicture;
@property (nonatomic,strong) UIButton *buttonSelected;

@end


@implementation CDPictureCollectionCell


- (void)setImage:(UIImage *)image andButtonImage:(UIImage *)imageButton
{
    self.imageViewPicture.image = image;
    [self.buttonSelected setImage:imageButton forState:UIControlStateNormal];
//    if (selected) {
//        [self.buttonSelected setImage:[UIImage imageNamed:@"photo_image_selected_on_status_icon"] forState:UIControlStateNormal];
//    } else {
//        [self.buttonSelected setImage:[UIImage imageNamed:@"photo_image_selected_off_status_icon"] forState:UIControlStateNormal];
//    }
}

- (void)updateButtonImage:(UIImage *)image
{
    [self.buttonSelected setImage:image forState:UIControlStateNormal];
}

#pragma mark - Getter Method
- (UIImageView *)imageViewPicture
{
    if (_imageViewPicture == nil) {
        _imageViewPicture = [[UIImageView alloc] init];
        _imageViewPicture.contentMode = UIViewContentModeScaleAspectFill;
        _imageViewPicture.clipsToBounds = YES;
        _imageViewPicture.layer.cornerRadius = 3.0f;
        [self addSubview:_imageViewPicture];
        [_imageViewPicture mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5.0);
            make.right.equalTo(self).offset(-5.0);
            make.top.equalTo(self).offset(5.0);
            make.bottom.equalTo(self);
        }];
    }
    return _imageViewPicture;
}

- (UIButton *)buttonSelected
{
    if (_buttonSelected == nil) {
        _buttonSelected =[[UIButton alloc] init];
        _buttonSelected.clipsToBounds = YES;
//        _buttonSelected.backgroundColor = [UIColor yellowColor];
        [self addSubview:_buttonSelected];
        [_buttonSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(SCREEN_WIDTH/3.0/4.0));
            make.width.equalTo(_buttonSelected.mas_height);
        }];
        
        [_buttonSelected.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonSelected.mas_centerX).offset(15.0);
            make.centerY.equalTo(_buttonSelected.mas_centerY).offset(-5.0);
            make.height.equalTo(@(SCREEN_WIDTH/3.0/3.0/3.0*1.2));
            make.width.equalTo(_buttonSelected.imageView.mas_height);
        }];
        
    }
    return _buttonSelected;
}


@end
