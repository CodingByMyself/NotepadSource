//
//  CDInputCollectionCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/10.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDInputCollectionCell.h"

@interface CDInputCollectionCell () <UITextViewDelegate>
{
    UILabel *_labelTextViewPlaceholder;
}
@property (nonatomic,strong) UITextView *textViewInputContent;
@property (nonatomic,copy) void(^InputTextChangedBlock)(NSString *textString);
@end


@implementation CDInputCollectionCell

- (void)setup:(NSString *)text OnInputTextChanged:(void(^)(NSString *textString))textCahnged
{
    self.InputTextChangedBlock = textCahnged;
    [self setContentText:text];
}

- (void)setContentText:(NSString *)content
{
    self.textViewInputContent.text = content.length > 0 ? content : @"";
    _labelTextViewPlaceholder.hidden = (self.textViewInputContent.text.length > 0) ? YES : NO;
    
}

#pragma mark 
- (void)textViewDidChange:(UITextView *)textView
{
    _labelTextViewPlaceholder.hidden = (self.textViewInputContent.text.length > 0) ? YES : NO;
    if (self.InputTextChangedBlock) {
        self.InputTextChangedBlock(textView.text);
    }
}

#pragma mark - Getter Method
- (UITextView *)textViewInputContent
{
    if (_textViewInputContent == nil) {
        _textViewInputContent = [[UITextView alloc] init];
        _textViewInputContent.layer.cornerRadius = 5.0;
        _textViewInputContent.layer.borderColor = DefineColorRGB(230, 230, 230, 1.0).CGColor;
        _textViewInputContent.layer.borderWidth = 1.0;
        _textViewInputContent.textColor = COLOR_TITLE1;
        _textViewInputContent.font = UIFONT_14;
//        _textViewInputContent.layer.cornerRadius = 3.0f;
//        _textViewInputContent.layer.borderColor = CommonBordorColor.CGColor;
//        _textViewInputContent.layer.borderWidth = CommonLineBorderWidth;
        _textViewInputContent.delegate = self;
        [self addSubview:_textViewInputContent];
        [_textViewInputContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10.0);
            make.right.equalTo(self).offset(-10.0);
            make.top.equalTo(self).offset(5.0);
            make.bottom.equalTo(self);
        }];
        
        
        
        [_labelTextViewPlaceholder removeFromSuperview];
        _labelTextViewPlaceholder = [[UILabel alloc] init];
        _labelTextViewPlaceholder.text  = @"最多输入500个字符";
        _labelTextViewPlaceholder.textColor = [UIColor lightGrayColor];
        _labelTextViewPlaceholder.font = UIFONT_14;
        _labelTextViewPlaceholder.numberOfLines = 0;
        _labelTextViewPlaceholder.textAlignment = NSTextAlignmentLeft;
        [_textViewInputContent addSubview:_labelTextViewPlaceholder];
        [_labelTextViewPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_textViewInputContent).offset(5.0);
            make.centerX.equalTo(_textViewInputContent);
            make.width.equalTo(@(SCREEN_WIDTH - (5.0+20.0)*2));
        }];
        
    }
    return _textViewInputContent;
}

@end
