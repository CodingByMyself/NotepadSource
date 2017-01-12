//
//  CDNoteItemCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDNoteItemCell.h"


@interface CDNoteItemCell ()

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UILabel *labelVoiceNumber;
@property (nonatomic,strong) UILabel *labelDateTime;
@property (nonatomic,strong) UIImageView *imageViewMark;
@property (nonatomic,strong) UIImageView *imageViewItem;

@end


@implementation CDNoteItemCell

- (void)setup
{
    
}

#pragma mark - Public Method
- (void)setNoteModel:(CDNoteModel *)noteModel
{
    self.labelTitle.text = noteModel.title;
    
    self.labelVoiceNumber.hidden = !(noteModel.voicePathList.count);
    self.labelVoiceNumber.text = [NSString stringWithFormat:@"(包含%zi条语音信息)",noteModel.voicePathList.count];
    
    self.labelDateTime.text = [CDDateHelper date:noteModel.createDate toStringByFormat:@"yyyy年MM月dd日 HH:mm"];
    
    self.imageViewMark.hidden = !(noteModel.mark);
    
    if (noteModel.picturePathList.count > 0) {
        self.imageViewItem.image = [UIImage imageNamed:@"test_picture"];
        [_imageViewItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CDScreenMarginAtLeftAndRight);
            make.top.equalTo(self.contentView).offset(5.0);
            make.bottom.equalTo(self.contentView).offset(-5.0);
            make.width.equalTo(_imageViewItem.mas_height);
        }];
    } else {
        self.imageViewItem.image = nil;
        [self.imageViewItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CDScreenMarginAtLeftAndRight);
            make.top.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(@1);
        }];
    }
    
}

- (CGFloat)fitHeightByNote:(CDNoteModel *)noteModel
{
    self.labelTitle.text = noteModel.title;
    CGFloat height = [self.labelTitle textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH - CDScreenMarginAtLeftAndRight*2 - 5.0 - 80.0, SCREEN_HEIGHT) limitedToNumberOfLines:2].size.height;
    if (noteModel.voicePathList.count > 0) {
        height = height + 15.0 ;
    }
    return height + 10.0 + 10.0 + 15.0;
}

#pragma mark - Getter Method
- (UIImageView *)imageViewItem
{
    if (_imageViewItem == nil) {
        _imageViewItem = [[UIImageView alloc] init];
        _imageViewItem.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageViewItem];
        [_imageViewItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-CDScreenMarginAtLeftAndRight);
            make.top.equalTo(self.contentView).offset(CDScreenMarginAtLeftAndRight);
            make.bottom.equalTo(self.contentView).offset(-CDScreenMarginAtLeftAndRight);
            make.width.equalTo(_imageViewItem.mas_height);
        }];
    }
    return _imageViewItem;
}

- (UILabel *)labelTitle
{
    if (_labelTitle == nil) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.textColor = COLOR_TITLE1;
        _labelTitle.font = UIFONT_14;
        _labelTitle.numberOfLines = 2;
        [self.contentView addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5.0);
            make.left.equalTo(self.contentView).offset(CDScreenMarginAtLeftAndRight);
            make.right.equalTo(self.imageViewItem.mas_left).offset(-5.0);
//            make.height.equalTo(@36.0);
        }];
    }
    return _labelTitle;
}

- (UILabel *)labelVoiceNumber
{
    if (_labelVoiceNumber == nil) {
        _labelVoiceNumber = [[UILabel alloc] init];
        _labelVoiceNumber.textColor = COLOR_TITLE2;
        _labelVoiceNumber.font = UIFONT_12;
        [self.contentView addSubview:_labelVoiceNumber];
        [_labelVoiceNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelTitle);
            make.right.equalTo(self.imageViewItem.mas_left);
            make.top.equalTo(self.labelTitle.mas_bottom).offset(3.0);
        }];
    }
    return _labelVoiceNumber;
}


- (UILabel *)labelDateTime
{
    if (_labelDateTime == nil) {
        _labelDateTime = [[UILabel alloc] init];
        _labelDateTime.textColor = COLOR_TITLE2;
        _labelDateTime.font = UIFONT_12;
        [self.contentView addSubview:_labelDateTime];
        [_labelDateTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.labelTitle);
            make.bottom.equalTo(self.contentView).offset(-5.0);
            make.height.equalTo(@15.0);
        }];
        
    }
    return _labelDateTime;
}


- (UIImageView *)imageViewMark
{
    if (_imageViewMark == nil) {
        _imageViewMark = [[UIImageView alloc] init];
        _imageViewMark.contentMode = UIViewContentModeScaleAspectFit;
        _imageViewMark.image = [UIImage imageNamed:@"home_cell_mark_note_icon"];
        
        [self.contentView addSubview:_imageViewMark];
        [_imageViewMark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageViewItem.mas_left).offset(-5);
            make.centerY.equalTo(self.labelDateTime);
            make.height.equalTo(@12);
            make.width.equalTo(@12);
        }];
    }
    return _imageViewMark;
}

@end








