//
//  CDTabBarView.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDTabBarView.h"
#import "CDBarItem.h"


NSInteger const ItemsCount = 2;

@interface CDTabBarView ()
{
    CDBarItem *items[ItemsCount];
}
@end

@implementation CDTabBarView
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
    //  背景 和 边框
    self.backgroundColor = TAB_BAR_BOTTOM_VIEW_BG_COLOR;
    self.layer.shadowColor = VIEW_BOTTOM_SHADOW_COLOR.CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0,-0.5);
    self.layer.shadowOpacity = 0.6;
    self.layer.shadowRadius = 0.5;
    
    //  item 填充
    NSArray * textArr =@[@"记事本",@"我的"];
    NSArray * imgSelected = @[@"tab_bar_bottom_item_icon_home",@"tab_bar_bottom_item_icon_mine"];
    NSArray * imgDeselected = @[@"tab_bar_bottom_item_icon_home_0",@"tab_bar_bottom_item_icon_mine_0"];
    for (NSInteger i = 0 ; i < ItemsCount ; i ++) {
        items[i] = [[CDBarItem alloc] init];
        [items[i] itemTitle:textArr[i] withSelectedImageName:imgSelected[i] andDeselectedImageName:imgDeselected[i]];
        [items[i] addTarget:self action:@selector(onItemClickedEvent:) forControlEvents:UIControlEventTouchUpInside];
        items[i].tag = i;
        [self addSubview:items[i]];
        [items[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            i == 0 ? make.left.equalTo(self) :  make.left.equalTo(items[i-1].mas_right) ;
            make.width.equalTo(@(SCREEN_WIDTH/ItemsCount));
        }];
    }
}

#pragma mark - Clicked Event
- (void)onItemClickedEvent:(CDBarItem *)sender
{
    for (NSInteger i = 0 ; i < ItemsCount ; i ++) {
        items[i].selected  =NO;
    }
    [CDTabBarController sharedTabBarController].selectedIndex = sender.tag;
    sender.selected=YES;
}

#pragma mark - Public Method
-(void)setSelectedItemIndex:(NSInteger)index
{
    [self onItemClickedEvent:items[index]];
}


@end
