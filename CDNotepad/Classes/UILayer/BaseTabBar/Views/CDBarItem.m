//
//  CDBarItem.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBarItem.h"

@interface CDBarItem ()
{
    NSString * _selectItemImageString;
    NSString * _deselectItemImageString;
    NSString * _titleText;
}
@property (nonatomic,strong) UIImageView * itemImageView;
@property (nonatomic,strong) UILabel * itemLabelText;
@end


#define ItemImageViewHeight  (CDTabBarBottomViewHeight/1.9)
@implementation CDBarItem
#pragma mark - init
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
    [self addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(ItemImageViewHeight));
        make.centerY.equalTo(self).offset( - ItemImageViewHeight/3.5);
    }];
    
    [self addSubview:self.itemLabelText];
    [self.itemLabelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemImageView.mas_bottom).offset(0);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(20.0));
    }];
}

#pragma mark  Getter Method
- (UIImageView *)itemImageView
{
    if (!_itemImageView) {
        _itemImageView = [[UIImageView alloc] init];
        _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _itemImageView;
}

- (UILabel *)itemLabelText
{
    if (!_itemLabelText) {
        _itemLabelText = [[UILabel alloc] init];
        _itemLabelText.textAlignment = NSTextAlignmentCenter;
        _itemLabelText.font = [UIFont systemFontOfSize:10];
        _itemLabelText.textColor = [UIColor darkGrayColor];
    }
    return _itemLabelText;
}

#pragma mark  Overwirte  Method
-(void)setSelected:(BOOL)selected
{
    if ( YES == selected) {
        self.itemImageView.image = [UIImage imageNamed:_selectItemImageString] ;
        self.itemLabelText.textColor = TAB_BAR_BOTTOM_ITEM_TITLE_COLOR;
    } else {
        self.itemImageView.image = [UIImage imageNamed:_deselectItemImageString] ;
        self.itemLabelText.textColor = [UIColor grayColor];
    }
    self.itemLabelText.text = _titleText;
}

#pragma mark - Public Method

- (void)itemTitle:(NSString*)title withSelectedImageName:(NSString*)selectedName andDeselectedImageName:(NSString*)deselectedName
{
    _selectItemImageString = selectedName;
    _deselectItemImageString = deselectedName;
    _titleText = title;
    
    [self setSelected:self.selected];  //  更新一下视图
}

@end
