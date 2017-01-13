//
//  CDHeaderCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDHeaderCell.h"

@interface CDHeaderCell ()
@property (nonatomic,strong) UIImageView *imageViewHeader;
@property (nonatomic,strong) UILabel *labelName;
@end

@implementation CDHeaderCell

- (void)setup
{
    self.imageViewHeader.image = [UIImage imageNamed:@"test_picture"];
    self.labelName.text = [[[CDSharedDataManager shareManager] currentUser] name];
}

#pragma mark - Getter Method
- (UIImageView *)imageViewHeader
{
    if (_imageViewHeader == nil) {
        _imageViewHeader = [[UIImageView alloc] init];
        _imageViewHeader.image = [UIImage imageNamed:@""];
        _imageViewHeader.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageViewHeader.layer.cornerRadius = 30.0;
        _imageViewHeader.clipsToBounds = YES;
        [self addSubview:_imageViewHeader];
        [_imageViewHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-15.0);
            make.width.equalTo(@60.0);
            make.height.equalTo(_imageViewHeader.mas_width);
        }];
        
    }
    return _imageViewHeader;
}

- (UILabel *)labelName
{
    if (_labelName == nil) {
        _labelName = [[UILabel alloc] init];
        _labelName.text = [[[CDSharedDataManager shareManager] currentUser] name];
        _labelName.textColor = COLOR_TITLE1;
        _labelName.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelName];
        [_labelName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
//            make.centerX.equalTo(self);
            make.top.equalTo(self.imageViewHeader.mas_bottom).offset(10.0);
        }];
    }
    return _labelName;
}

@end
