//
//  CDAddAttachmentMenuView.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDAddAttachmentMenuView.h"
#import "CDCDPickerDateView.h"
#import "CDLongPressMakeVoice.h"
#import "XHSoundRecorder.h"

const CGFloat AddAttachmentMenuHeight = 45.0;


@interface CDAddAttachmentMenuView ()
{
    CDCDPickerDateView *_picker;
    NSString *_dateString;
    NSString *_timeString;
    
    CDLongPressMakeVoice *_makeVoiceView;
}
@property (nonatomic,strong) UIView *viewMenu;
@property (nonatomic,strong) UIButton *buttonSelectedPicture;
@property (nonatomic,strong) UIButton *buttonMakeVoice;
@property (nonatomic,strong) UIButton *buttonSelectedDate;
@property (nonatomic,strong) UIButton *buttonSelectedTime;

@end


@implementation CDAddAttachmentMenuView

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
    
    _dateString = [CDDateHelper date:[NSDate date] toStringByFormat:@"yyyyMMdd"];
    _timeString = [CDDateHelper date:[NSDate date] toStringByFormat:@"HHmm"];
    
    self.viewMenu.layer.borderColor = DefineColorRGB(190.0, 190.0, 190.0, 0.5).CGColor;
    self.viewMenu.layer.borderWidth = 1.0;
    
    
    self.buttonSelectedPicture.backgroundColor = [UIColor whiteColor];
    self.buttonSelectedPicture.layer.borderColor = MainColor.CGColor;
    self.buttonSelectedPicture.layer.borderWidth = 0.5;
    self.buttonSelectedPicture.layer.cornerRadius = 3.0f;
    
    self.buttonMakeVoice.backgroundColor = [UIColor whiteColor];
    self.buttonMakeVoice.layer.borderColor = MainColor.CGColor;
    self.buttonMakeVoice.layer.borderWidth = 0.5;
    self.buttonMakeVoice.layer.cornerRadius = 3.0f;
    
    self.buttonSelectedDate.backgroundColor = [UIColor whiteColor];
    self.buttonSelectedDate.layer.borderColor = MainColor.CGColor;
    self.buttonSelectedDate.layer.borderWidth = 0.5;
    self.buttonSelectedDate.layer.cornerRadius = 3.0f;
    
    self.buttonSelectedTime.backgroundColor = [UIColor whiteColor];
    self.buttonSelectedTime.layer.borderColor = MainColor.CGColor;
    self.buttonSelectedTime.layer.borderWidth = 0.5;
    self.buttonSelectedTime.layer.cornerRadius = 3.0f;
    
    
    [self.buttonSelectedPicture addTarget:self action:@selector(menuButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonSelectedPicture.tag = 1;
    [self.buttonMakeVoice addTarget:self action:@selector(menuButtonClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonMakeVoice.tag = 2;
    
    
    // 日期和时间
    [self.buttonSelectedDate addTarget:self action:@selector(showPickerDateView:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonSelectedDate.tag = 1;
    [self.buttonSelectedTime addTarget:self action:@selector(showPickerDateView:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonSelectedTime.tag = 2;
}

#pragma mark - Public Method
- (void)setActionEvent:(SEL)action andTarget:(id)target
{
    
}

#pragma mark - IBAction
- (void)menuButtonClickedEvent:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            NSLog(@"选择图片");
            if ([_delegate respondsToSelector:@selector(menuView:buttonSelectPictureClicked:)]) {
                [_delegate menuView:self buttonSelectPictureClicked:button];
            }
        }
            break;
        case 2:
        {
            NSLog(@"开始录音");
            if (self.cd_height > AddAttachmentMenuHeight && [self.subviews containsObject:_makeVoiceView]) {
                return;
            }
            [_picker hiddenPickerView];
            
            [[XHSoundRecorder sharedSoundRecorder] startRecorder:^(NSString *filePath) {
                NSLog(@"录音文件全路径:%@",filePath);
                NSLog(@"录音结束");
                NSString *relativePath = [filePath stringByReplacingOccurrencesOfString:[CDTools getSandboxPath] withString:@""];
                if ([_delegate respondsToSelector:@selector(menuView:makeVoiceFinishedOnFilePath:)]) {
                    [_delegate menuView:self makeVoiceFinishedOnFilePath:relativePath];
                }
                
            }];
            
            
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(AddAttachmentMenuHeight + CDDatePickerViewHeight));
            }];
            
            [_makeVoiceView removeFromSuperview];
            _makeVoiceView = [[CDLongPressMakeVoice alloc] init];
            [_makeVoiceView setOverActionEvent:@selector(buttonOverClickedEvent:) andTarget:self];
            [self addSubview:_makeVoiceView];
            [_makeVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.viewMenu.mas_bottom);
                make.left.equalTo(self);
                make.right.equalTo(self);
                make.bottom.equalTo(self);
            }];

        }
            break;
        default:
            break;
    }
}

#pragma mark  显示日期和时间的选择器
- (void)showPickerDateView:(UIButton *)button
{
    [self buttonOverClickedEvent:nil];
    
    [_picker hiddenPickerView];
    if (button.tag == 1) {
        if (self.cd_height > AddAttachmentMenuHeight && _picker.showConentType == 0) {
            return;
        }
        _picker = [[CDCDPickerDateView alloc] init];
        _picker.showConentType = 0;
        
        
    } else {
        if (self.cd_height > AddAttachmentMenuHeight && _picker.showConentType == 1) {
            return;
        }
        _picker = [[CDCDPickerDateView alloc] init];
        _picker.showConentType = 1;
    }
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AddAttachmentMenuHeight +CDDatePickerViewHeight + 35.0));
    }];
    [self.viewMenu endEditing:YES];
    
    [_picker setButtonActionEvent:@selector(buttonOnPickerClickedEvent:) andTarget:self];
    [_picker showPickerViewOnTargetView:self];
}

#pragma mark 选中日期和时间
- (void)buttonOnPickerClickedEvent:(UIButton *)button
{
    [_picker hiddenPickerView];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AddAttachmentMenuHeight));
    }];
    
    if (button.tag == 1) {
        if (_picker.showConentType) {
            _timeString = [NSString stringWithFormat:@"%@%@",[_picker selectedDataInComponent:0],[_picker selectedDataInComponent:1]];
        } else {
            _dateString = [NSString stringWithFormat:@"%@%@%@",[_picker selectedDataInComponent:0],[_picker selectedDataInComponent:1],[_picker selectedDataInComponent:2]];
        }
        NSString *fullDateString = [NSString stringWithFormat:@"%@%@",_dateString,_timeString];
        NSDate *newDate = [CDDateHelper dateFromString:fullDateString byFormat:@"yyyyMMddHHmm"];
        if ([_delegate respondsToSelector:@selector(menuView:selectedDate:)]) {
            [_delegate menuView:self selectedDate:newDate];
        }
    }
}

#pragma mark - 结束录音
- (void)buttonOverClickedEvent:(UIButton *)button
{
    NSLog(@"结束录音");
    [[XHSoundRecorder sharedSoundRecorder] stopRecorder];
    
    [_makeVoiceView removeFromSuperview];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(AddAttachmentMenuHeight));
    }];
    [self layoutIfNeeded];
}

#pragma mark - Getter Method
- (UIView *)viewMenu
{
    if (_viewMenu == nil) {
        _viewMenu = [[UIView alloc] init];
        _viewMenu.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_viewMenu];
        [_viewMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@(AddAttachmentMenuHeight));
        }];
        
        
    }
    return _viewMenu;
}

- (UIButton *)buttonSelectedPicture
{
    if (_buttonSelectedPicture == nil) {
        _buttonSelectedPicture = [[UIButton alloc] init];
        [self.viewMenu addSubview:_buttonSelectedPicture];
        [_buttonSelectedPicture mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.viewMenu).offset(CDScreenMarginAtLeftAndRight);
            make.centerX.equalTo(self.viewMenu.mas_left).offset(SCREEN_WIDTH/4.0/2.0);
            make.top.equalTo(self.viewMenu).offset(8.0);
            make.bottom.equalTo(self.viewMenu).offset(-8.0);
            make.width.equalTo(@70);
        }];
        
        // title文本
        UILabel *label = [[UILabel alloc] init];
        label.text = @"图片";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_14;
        label.textColor = MainColor;
        [_buttonSelectedPicture addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonSelectedPicture).offset(10.0);
            make.top.equalTo(_buttonSelectedPicture);
            make.bottom.equalTo(_buttonSelectedPicture);
            make.width.equalTo(@([label textRectForBounds:CGRectMake(0, 0, 100.0, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
        
        // icon图标
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"new_or_edit_menu_item_camera_icon"];
        [_buttonSelectedPicture addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@20.0);
            make.width.equalTo(@20.0);
        }];
        
        
    }
    return _buttonSelectedPicture;
}

- (UIButton *)buttonMakeVoice
{
    if (_buttonMakeVoice == nil) {
        _buttonMakeVoice = [[UIButton alloc] init];
        [self.viewMenu addSubview:_buttonMakeVoice];
        [_buttonMakeVoice mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.buttonSelectedPicture.mas_right).offset(CDScreenMarginAtLeftAndRight);
            make.centerX.equalTo(self.buttonSelectedPicture.mas_centerX).offset(SCREEN_WIDTH/4.0);
            make.top.equalTo(self.buttonSelectedPicture);
            make.bottom.equalTo(self.buttonSelectedPicture);
            make.width.equalTo(@70);
        }];
        
        
        // title文本
        UILabel *label = [[UILabel alloc] init];
        label.text = @"录音";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_14;
        label.textColor = MainColor;
        [_buttonMakeVoice addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonMakeVoice).offset(10.0);
            make.top.equalTo(_buttonMakeVoice);
            make.bottom.equalTo(_buttonMakeVoice);
            make.width.equalTo(@([label textRectForBounds:CGRectMake(0, 0, 100.0, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
        
        // icon图标
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"new_or_edit_menu_item_voice_icon"];
        [_buttonMakeVoice addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@20.0);
            make.width.equalTo(@20.0);
        }];
        
    }
    return _buttonMakeVoice;
}

- (UIButton *)buttonSelectedDate
{
    if (_buttonSelectedDate == nil) {
        _buttonSelectedDate = [[UIButton alloc] init];
        [self.viewMenu addSubview:_buttonSelectedDate];
        [_buttonSelectedDate mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.buttonSelectedTime.mas_left).offset(-CDScreenMarginAtLeftAndRight);
            make.centerX.equalTo(self.buttonSelectedTime.mas_centerX).offset(-SCREEN_WIDTH/4.0);
            make.top.equalTo(self.buttonSelectedPicture);
            make.bottom.equalTo(self.buttonSelectedPicture);
            make.width.equalTo(@70);
        }];
        
        
        // title文本
        UILabel *label = [[UILabel alloc] init];
        label.text = @"日期";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_14;
        label.textColor = MainColor;
        [_buttonSelectedDate addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonSelectedDate).offset(10.0);
            make.top.equalTo(_buttonSelectedDate);
            make.bottom.equalTo(_buttonSelectedDate);
            make.width.equalTo(@([label textRectForBounds:CGRectMake(0, 0, 100.0, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
        
        // icon图标
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"new_or_edit_menu_item_calendar_icon"];
        [_buttonSelectedDate addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@20.0);
            make.width.equalTo(@20.0);
        }];
        
        
    }
    return _buttonSelectedDate;
}

- (UIButton *)buttonSelectedTime
{
    if (_buttonSelectedTime == nil) {
        _buttonSelectedTime = [[UIButton alloc] init];
        [self.viewMenu addSubview:_buttonSelectedTime];
        [_buttonSelectedTime mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.mas_right).offset(-CDScreenMarginAtLeftAndRight);
            make.centerX.equalTo(self.viewMenu.mas_right).offset(-SCREEN_WIDTH/4.0/2.0);
            make.top.equalTo(self.buttonSelectedPicture);
            make.bottom.equalTo(self.buttonSelectedPicture);
            make.width.equalTo(@70);
        }];
        
        
        // title文本
        UILabel *label = [[UILabel alloc] init];
        label.text = @"时间";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_14;
        label.textColor = MainColor;
        [_buttonSelectedTime addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonSelectedTime).offset(10.0);
            make.top.equalTo(_buttonSelectedTime);
            make.bottom.equalTo(_buttonSelectedTime);
            make.width.equalTo(@([label textRectForBounds:CGRectMake(0, 0, 100.0, SCREEN_HEIGHT) limitedToNumberOfLines:1].size.width + 5.0));
        }];
        
        // icon图标
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"new_or_edit_menu_item_time_icon"];
        [_buttonSelectedTime addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@20.0);
            make.width.equalTo(@20.0);
        }];
        
    }
    return _buttonSelectedTime;
}

@end
