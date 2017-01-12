//
//  CDCDPickerDateView.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDCDPickerDateView.h"


CGFloat const CDDatePickerViewHeight = 150.0;


@interface CDCDPickerDateView ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
{
    NSInteger _selectedRow[3];
}
//@property (nonatomic,copy) void(^ completeCallBack)(NSDate *selectedDate);
@property (nonatomic,strong) UIView *viewTitle;
@property (nonatomic,strong) UIButton *buttonCancel;
@property (nonatomic,strong) UIButton *buttonSelected;

@property (nonatomic,strong) UIPickerView *pickerViewDate;
@property (nonatomic,strong) NSArray *yearsArray; // 年
@property (nonatomic,strong) NSArray *monthsArray;  // 月
@property (nonatomic,strong) NSArray *daysArray; // 天
@property (nonatomic,strong) NSArray *hoursArray; // 小时
@property (nonatomic,strong) NSArray *minuteArray; // 分钟

@end


@implementation CDCDPickerDateView

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
    _selectedRow[0] = [self.yearsArray count] - 1;
    
    self.pickerViewDate.delegate = self;
    self.pickerViewDate.dataSource = self;
}

#pragma mark
- (void)showPickerViewOnTargetView:(UIView *)targetView
{
    [self hiddenPickerView];
    [self.pickerViewDate selectRow:_selectedRow[0] inComponent:0 animated:YES];
    [self.pickerViewDate reloadAllComponents];
    
//    self.completeCallBack = complete;
    
    [self.pickerViewDate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(CDDatePickerViewHeight);
    }];
    [targetView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(targetView).offset(45.0);
        make.left.equalTo(targetView);
        make.right.equalTo(targetView);
        make.bottom.equalTo(targetView);
    }];
    [self layoutIfNeeded];
    
    [self.pickerViewDate mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
//    [UIView animateWithDuration:0.2 animations:^{
//        [self layoutIfNeeded];
//    }];
}

- (void)hiddenPickerView
{
    [self removeFromSuperview];
}

- (void)setButtonActionEvent:(SEL)action andTarget:(id)target
{
    [self.buttonCancel addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.buttonCancel.tag = 0;
    [self.buttonSelected addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.buttonSelected.tag = 1;
}

- (NSString *)selectedDataInComponent:(NSInteger)component
{
    NSInteger row = [self.pickerViewDate selectedRowInComponent:component];
    if (component == 0) {
        return self.showConentType ? self.hoursArray[row] : self.yearsArray[row];
    } else if (component == 1) {
        return self.showConentType ? self.minuteArray[row] : self.monthsArray[row];
    } else if (component == 2) {
        return self.daysArray[row];
    } else {
        return nil;
    }
}

#pragma mark - Getter Method
- (UIView *)viewTitle
{
    if (_viewTitle == nil) {
        _viewTitle = [[UIView alloc] init];
        _viewTitle.backgroundColor = [UIColor whiteColor];
        [self addSubview:_viewTitle];
        [_viewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self.pickerViewDate.mas_top);
            make.height.equalTo(@35.0);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_viewTitle addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTitle);
            make.right.equalTo(_viewTitle);
            make.bottom.equalTo(_viewTitle);
            make.height.equalTo(@1.0);
        }];
    }
    return _viewTitle;
}

- (UIButton *)buttonCancel
{
    if (_buttonCancel == nil) {
        _buttonCancel = [[UIButton alloc] init];
        [_buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_buttonCancel setTitleColor:COLOR_TITLE2 forState:UIControlStateNormal];
        _buttonCancel.titleLabel.font = UIFONT_14;
        [self.viewTitle addSubview:_buttonCancel];
        [_buttonCancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.viewTitle).offset(CDScreenMarginAtLeftAndRight);
            make.width.equalTo(@60.0);
            make.height.equalTo(@30.0);
            make.centerY.equalTo(self.viewTitle);
        }];
    }
    return _buttonCancel;
}

- (UIButton *)buttonSelected
{
    if (_buttonSelected == nil) {
        _buttonSelected = [[UIButton alloc] init];
        [_buttonSelected setTitle:@"确认" forState:UIControlStateNormal];
        _buttonSelected.titleLabel.font = UIFONT_14;
        [_buttonSelected setTitleColor:COLOR_TITLE1 forState:UIControlStateNormal];
        [self.viewTitle addSubview:_buttonSelected];
        [_buttonSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.viewTitle).offset(-CDScreenMarginAtLeftAndRight);
            make.width.equalTo(@60.0);
            make.height.equalTo(@30.0);
            make.centerY.equalTo(self.viewTitle);
        }];
    }
    return _buttonSelected;
}

- (UIPickerView *)pickerViewDate
{
    if (_pickerViewDate == nil) {
        _pickerViewDate = [[UIPickerView alloc] init];
        _pickerViewDate.backgroundColor = [UIColor whiteColor];
        [self addSubview:_pickerViewDate];
        [_pickerViewDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(CDDatePickerViewHeight));
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _pickerViewDate;
}

- (NSArray *)yearsArray
{
    if (_yearsArray == nil) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        NSInteger currentYear = [[CDDateHelper date:[NSDate date] toStringByFormat:@"yyyy"] integerValue];
        for (NSInteger i = currentYear - 500.0 ; i <= currentYear ; i ++) {
            [temp addObject:[NSString stringWithFormat:@"%zi",i]];
        }
        _yearsArray = [NSArray arrayWithArray:temp];
    }
    return _yearsArray;
}

- (NSArray *)monthsArray
{
    if (_monthsArray == nil) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSInteger i = 1 ; i <= 12 ; i ++) {
            if (i <= 9) {
                [temp addObject:[NSString stringWithFormat:@"0%zi",i]];
            } else {
                [temp addObject:[NSString stringWithFormat:@"%zi",i]];
            }
        }
        _monthsArray = [NSArray arrayWithArray:temp];
    }
    return _monthsArray;
}

- (NSArray *)daysArray
{
    if (_daysArray == nil) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSInteger i = 1 ; i <= 31 ; i ++) {
            if (i <= 9) {
                [temp addObject:[NSString stringWithFormat:@"0%zi",i]];
            } else {
                [temp addObject:[NSString stringWithFormat:@"%zi",i]];
            }
        }
        _daysArray = [NSArray arrayWithArray:temp];
    }
    return _daysArray;
}

- (NSArray *)hoursArray
{
    if (_hoursArray == nil) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSInteger i = 0 ; i <= 23 ; i ++) {
            if (i <= 9) {
                [temp addObject:[NSString stringWithFormat:@"0%zi",i]];
            } else {
                [temp addObject:[NSString stringWithFormat:@"%zi",i]];
            }
        }
        _hoursArray = [NSArray arrayWithArray:temp];
    }
    return _hoursArray;
}

- (NSArray *)minuteArray
{
    if (_minuteArray == nil) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (NSInteger i = 0 ; i <= 59 ; i ++) {
            if (i <= 9) {
                [temp addObject:[NSString stringWithFormat:@"0%zi",i]];
            } else {
                [temp addObject:[NSString stringWithFormat:@"%zi",i]];
            }
        }
        _minuteArray = [NSArray arrayWithArray:temp];
    }
    return _minuteArray;
}

#pragma mark - Delegate
// 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.showConentType ? 2 : 3;
}
//行高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30.0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 90.0;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *titleString = @"";
    @try {
        if (component == 0) {
            titleString = self.showConentType ? [self.hoursArray objectAtIndex:row] : [self.yearsArray objectAtIndex:row];
        } else if (component == 1){
            titleString = self.showConentType ? [self.minuteArray objectAtIndex:row] : [self.monthsArray objectAtIndex:row];
        } else if (component == 2){
            titleString = [self.daysArray objectAtIndex:row];
        }
    } @catch (NSException *exception) {
        NSLog(@"异常信息打印：%@",exception);
    } @finally {}
    
    if (component==0) {
        titleString = [titleString stringByAppendingString:self.showConentType ? @"时" : @"年"];
    } else if (component==1) {
        titleString = [titleString stringByAppendingString:self.showConentType ? @"分" : @"月"];
    } else if (component==2) {
        titleString = [NSString stringWithFormat:@"%@日",titleString];
    }
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:COLOR_TITLE1}];
    return attString;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {  // year
        if (self.showConentType) {
            return self.hoursArray.count;
        } else {
            return [self.yearsArray count];
        }
        
    } else if (component == 1) {  // month
        if (self.showConentType) {
            return self.minuteArray.count;
        } else {
            if ([[self.yearsArray objectAtIndex:_selectedRow[0]] isEqualToString:[CDDateHelper date:[NSDate date] toStringByFormat:@"yyyy"]]) {
                NSInteger months = [[CDDateHelper date:[NSDate date] toStringByFormat:@"MM"] integerValue];
                return months;
            } else {
                return [self.monthsArray count];
            }
        }
        
    } else if (component == 2) { // day
        NSString *selectedDateString = [NSString stringWithFormat:@"%@%@",self.yearsArray[_selectedRow[0]],self.monthsArray[_selectedRow[1]]];
        NSDate *date = [CDDateHelper dateFromString:selectedDateString byFormat:@"yyyyMM"];
        NSInteger days = [[CDDateHelper date:[CDDateHelper lastDayOfMonth:date] toStringByFormat:@"dd"] integerValue];
        NSLog(@"%@  last date[%@]; days count = %zi",date,[CDDateHelper lastDayOfMonth:date],days);
        return days;
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedRow[component] = row;
    if (self.showConentType == 0) {
        if (component == 0 && [[self.yearsArray objectAtIndex:_selectedRow[0]] isEqualToString:[CDDateHelper date:[NSDate date] toStringByFormat:@"yyyy"]]) {
            NSInteger months = [[CDDateHelper date:[NSDate date] toStringByFormat:@"MM"] integerValue];
            _selectedRow[1] = (months <= _selectedRow[1]) ? months - 1 : _selectedRow[1];
        }
    }
    
    // 刷新
    [self.pickerViewDate reloadAllComponents];
}

@end
