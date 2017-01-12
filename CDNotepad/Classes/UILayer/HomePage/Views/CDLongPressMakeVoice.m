//
//  CDLongPressMakeVoice.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/11.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDLongPressMakeVoice.h"

@interface CDLongPressMakeVoice ()
{
    NSTimer *_timer;
    NSInteger _timeInterval;
}
@property (nonatomic,strong) UILabel *labelTimerString;
@property (nonatomic,strong) UIButton *buttonOver;

@end

@implementation CDLongPressMakeVoice

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    [self overMakeVoice];
}

#pragma mark 
- (void)setup
{
    self.labelTimerString.text = @"00:00";
    _timeInterval = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerVoiceDuration:) userInfo:nil repeats:YES];
}

- (void)timerVoiceDuration:(NSTimer *)timer
{
    _timeInterval++;
    NSInteger min = _timeInterval/60;
    NSInteger sec = _timeInterval%60;
    NSString *minString = min > 9 ? [NSString stringWithFormat:@"%zi",min] : [NSString stringWithFormat:@"0%zi",min];
    NSString *secString = sec > 9 ? [NSString stringWithFormat:@"%zi",sec] : [NSString stringWithFormat:@"0%zi",sec];
    self.labelTimerString.text = [NSString stringWithFormat:@"%@:%@",minString,secString];
    NSLog(@"_timeInterval = %zi",_timeInterval);
}

#pragma mark - Public Method
- (void)setOverActionEvent:(SEL)action andTarget:(id)target
{
    [self.buttonOver addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)overMakeVoice
{
    [_timer invalidate];
}



#pragma mark
- (UILabel *)labelTimerString
{
    if (_labelTimerString == nil) {
        _labelTimerString = [[UILabel alloc] init];
        
        
        UILabel *labelDescription = [[UILabel alloc] init];
        labelDescription.text = @"正在录音: ";
        labelDescription.textColor = MainColor;
        labelDescription.font = UIFONT_BOLD_20;
        labelDescription.textAlignment = NSTextAlignmentRight;
        [self addSubview:labelDescription];
        [labelDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self.mas_centerX);
            make.centerY.equalTo(self).offset(-25.0);
            make.height.equalTo(@50.0);
        }];
        
        
        _labelTimerString.textColor = MainColor;
        _labelTimerString.font = UIFONT_BOLD_20;
        _labelTimerString.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_labelTimerString];
        [_labelTimerString mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelDescription.mas_right);
            make.right.equalTo(self);
            make.centerY.equalTo(labelDescription);
            make.height.equalTo(labelDescription);
        }];
        
    }
    return _labelTimerString;
}

- (UIButton *)buttonOver
{
    if (_buttonOver == nil) {
        _buttonOver = [[UIButton alloc] init];
        _buttonOver.layer.cornerRadius = 3.0f;
        [_buttonOver setTitle:@"结束" forState:UIControlStateNormal];
        [_buttonOver setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buttonOver.backgroundColor = MainColor;
        [self addSubview:_buttonOver];
        [_buttonOver mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelTimerString.mas_bottom).offset(15.0);
            make.centerX.equalTo(self);
            make.height.equalTo(@38.0);
            make.width.equalTo(@100.0);
        }];
        
    }
    return _buttonOver;
}

@end
