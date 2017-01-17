//
//  CDFilterSelectView.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDFilterSelectView.h"


@interface CDFilterSelectView () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSArray *_dataList;
}

@property (nonatomic,strong) UIView *viewContent;
@property (nonatomic,strong) UIImageView *imageViewBg;
@property (nonatomic,strong) UITableView *tableViewList;
@property (nonatomic,copy) void (^onSelectedIndexBlock)(NSInteger index);

@end

@implementation CDFilterSelectView

- (instancetype)initWithFilterDataList:(NSArray *)array onSelectedBlock:(void(^)(NSInteger index))selectedBlock
{
    self = [super init];
    if (self) {
        _dataList = array;
        self.onSelectedIndexBlock = selectedBlock;
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    [self.viewContent addSubview:self.imageViewBg];
    [self.imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.viewContent);
    }];
    
    self.tableViewList.delegate = self;
    self.tableViewList.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap
{
    [self setHidden:YES];
    self.tag = !(YES);
    
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    [self.superview bringSubviewToFront:self];
    if (hidden == NO) {
        [self.tableViewList reloadData];
    }
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDBaseTableViewCell *cell = [[CDBaseTableViewCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = _dataList[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidden = YES;
    self.tag = 0;
    if (self.onSelectedIndexBlock) {
        self.onSelectedIndexBlock(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (160.0 - 20)/[_dataList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataList count];
}

#pragma mark
//prevent the gesture recognizer from seeing this touch
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == self) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Getter Method
- (UIView *)viewContent
{
    if (_viewContent == nil) {
        _viewContent = [[UIView alloc] init];
        _viewContent.backgroundColor = [UIColor clearColor];
        [self addSubview:_viewContent];
        [_viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(@160);
            make.width.equalTo(@120);
        }];
        
    }
    return _viewContent;
}

- (UIImageView *)imageViewBg
{
    if (_imageViewBg == nil) {
        _imageViewBg = [[UIImageView alloc] init];
        
        UIImage *imageBg = [UIImage imageNamed:@"home_filter_view_bg"];
        CGFloat top = 20; // 顶端盖高度
        CGFloat bottom = 10 ; // 底端盖高度
        CGFloat left = 10; // 左端盖宽度
        CGFloat right = 10; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        _imageViewBg.image = [imageBg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        
    }
    return _imageViewBg;
}

- (UITableView *)tableViewList
{
    if (_tableViewList == nil) {
        _tableViewList = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewList.backgroundColor = [UIColor clearColor];
        [self.viewContent addSubview:_tableViewList];
        [_tableViewList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.viewContent).offset(15.0);
            make.left.equalTo(self.viewContent);
            make.right.equalTo(self.viewContent);
            make.bottom.equalTo(self.viewContent);
        }];
        
    }
    return _tableViewList;
}


@end
