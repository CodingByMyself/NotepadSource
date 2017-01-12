//
//  CDVoiceCollectionCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDVoiceCollectionCell.h"
#import "XHSoundRecorder.h"

@interface CDVoiceCollectionCell ()

@property (nonatomic,strong) UIButton *buttonVoice;
@property (nonatomic,strong) UIButton *buttonDelete;

@end

@implementation CDVoiceCollectionCell

- (void)setup
{
    self.buttonVoice.backgroundColor = [UIColor whiteColor];
    [self.buttonVoice addTarget:self action:@selector(buttonPlayerVoice:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonPlayerVoice:(UIButton *)button
{
    NSString *fullPath = [[CDTools getSandboxPath] stringByAppendingString:_path];
    
    UILabel *title = [self.buttonVoice viewWithTag:1];
    title.text = @"正在播放...";
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([title textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
    }];
    
    typeof(self) wSelf = self;
    [[XHSoundRecorder sharedSoundRecorder] playsound:fullPath withFinishPlaying:^{
        NSLog(@"播放结束");
        UILabel *title = [wSelf.buttonVoice viewWithTag:1];
        title.text = [NSString stringWithFormat:@"%@【点击播放】",[_path lastPathComponent]];
        [title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@([title textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
    }];
}

- (void)setButtonDeleteAction:(SEL)action andTarget:(id)target
{
    [self.buttonDelete addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.buttonDelete.tag = self.tag;
}

- (void)setPath:(NSString *)path
{
    _path = path;
    UILabel *title = [self.buttonVoice viewWithTag:1];
    title.text = [NSString stringWithFormat:@"%@【点击播放】",[_path lastPathComponent]];
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@([title textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
    }];
}

#pragma mark - Getter Method
- (UIButton *)buttonVoice
{
    if (_buttonVoice == nil) {
        _buttonVoice = [[UIButton alloc] init];
        _buttonVoice.layer.cornerRadius = 5.0f;
        _buttonVoice.layer.borderColor = DefineColorRGB(230, 230, 230, 1.0).CGColor;
        _buttonVoice.layer.borderWidth = 1.0;
        [self addSubview:_buttonVoice];
        [_buttonVoice mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.right.equalTo(self.mas_right).offset(-CDScreenMarginAtLeftAndRight);
            make.left.equalTo(self).offset(10.0);
            make.top.equalTo(self).offset(8.0);
            make.bottom.equalTo(self).offset(-8.0);
            make.width.equalTo(@250);
        }];
        
        
        // title文本
        UILabel *label = [[UILabel alloc] init];
        label.text = @"点击开始播放";
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_14;
        label.textColor = COLOR_TITLE2;
        [_buttonVoice addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonVoice).offset(7.0);
            make.top.equalTo(_buttonVoice);
            make.bottom.equalTo(_buttonVoice);
            make.width.equalTo(@([label textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
        
        // icon图标
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"new_or_edit_cell_voice_icon"];
        [_buttonVoice addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@15.0);
            make.width.equalTo(@15.0);
        }];
    }
    return _buttonVoice;
    
}

- (UIButton *)buttonDelete
{
    if (_buttonDelete == nil) {
        _buttonDelete = [[UIButton alloc] init];
        [_buttonDelete setImage:[UIImage imageNamed:@"new_or_edit_delete_attachment_icon"] forState:UIControlStateNormal];
        _buttonDelete.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_buttonDelete];
        [_buttonDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.buttonVoice.mas_right).offset(10.0);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.width.equalTo(@15.0);
        }];
        
    }
    return _buttonDelete;
}


@end
