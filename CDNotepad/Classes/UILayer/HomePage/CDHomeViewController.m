//
//  CDHomeViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDHomeViewController.h"
#import "CDFilterSelectView.h"
#import "CDNoteItemCell.h"
#import "CDNoteModel.h"
#import "CDAddOrEditNoteViewController.h"
#import "CDNoteDetailsViewController.h"
#import "CDSearchBarView.h"

@interface CDHomeViewController () <UITableViewDelegate,UITableViewDataSource,CDKeyboardManagerDelegate>
{
    NSInteger _filterIndex;
}
@property (nonatomic,strong) NSMutableArray *notesArray;

@property (nonatomic,strong) UIButton *buttonTitle;
@property (nonatomic,strong) CDFilterSelectView *filterView;

@property (nonatomic,strong) UITableView *tableViewNotes;

@property (nonatomic,strong) CDSearchBarView *searchView;

@property (nonatomic,strong) UIView *viewEmpty;

@end

@implementation CDHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 左侧搜索按钮
    UIButton *rightButtonOne = [[UIButton alloc] init];
    rightButtonOne.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightButtonOne setImage:[UIImage imageNamed:@"home_navigation_search_icon"] forState:UIControlStateNormal];
    [rightButtonOne setTintColor:[UIColor whiteColor]];
    rightButtonOne.cd_size = CGSizeMake(30.0, 20.0);
    rightButtonOne.tag = 2;
    [rightButtonOne addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];// 监听按钮点击
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButtonOne]];
    
    // title设置
    [self initTitleView];
    
    self.tableViewNotes.delegate = self;
    self.tableViewNotes.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar layoutIfNeeded];
    
    [[CDKeyboardManager sharedKeyboard] setEventDelegate:self];
    
    [self filterDataListByIndex:_filterIndex];
    [self.tableViewNotes reloadData];
}

#pragma mark
- (void)initTitleView
{
    UILabel *title = [self.buttonTitle viewWithTag:100];
    _filterIndex = 0;
    title.text = @"全部";
    CGSize textSize = [title textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH - 200.0, 64.0) limitedToNumberOfLines:1].size;
    [title mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(textSize.width + 5.0));
    }];
    self.buttonTitle.cd_size = CGSizeMake(textSize.width + 10*2.0 + 15.0, 44.0);
    self.navigationItem.titleView = self.buttonTitle;
    
    
    /***** 右侧按钮 *****/
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton setImage:[UIImage imageNamed:@"home_navigation_right_add_new_note_icon"] forState:UIControlStateNormal];
    [leftButton setTintColor:[UIColor whiteColor]];
    leftButton.cd_size = CGSizeMake(30.0, 20.0);
    leftButton.tag = 3;
    // 监听按钮点击
    [leftButton addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)initTitleViewToSearchBar
{
    self.searchView.cd_size = CGSizeMake(SCREEN_WIDTH - 60*2, 44.0);
    self.navigationItem.titleView = self.searchView;
    
    
    /***** 右侧按钮 *****/
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    leftButton.titleLabel.font = UIFONT_14;
    [leftButton setTitleColor:COLOR_TITLE2 forState:UIControlStateNormal];
    leftButton.cd_size = CGSizeMake(40.0, 20.0);
    leftButton.tag = 4;
    // 监听按钮点击
    [leftButton addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)filterDataListByIndex:(NSInteger)index
{
    NSDate *targetDate;
    NSArray *allNote = [CDNoteModel allObject];
    _notesArray = [[NSMutableArray alloc] init];
    if (index == 0) {
        self.notesArray = [NSMutableArray arrayWithArray:allNote];
    } else if (index == 1) {
        targetDate = [CDDateHelper addToDate:[NSDate date] days:-7];
        for (CDNoteModel *model in allNote) {
            if ([model.createDate timeIntervalSince1970] >= [targetDate timeIntervalSince1970]) {
                [self.notesArray addObject:model];
            }
        }
    } else if (index == 2) {
        targetDate = [CDDateHelper addToDate:[NSDate date] days:-30];
        for (CDNoteModel *model in allNote) {
            if ([model.createDate timeIntervalSince1970] >= [targetDate timeIntervalSince1970]) {
                [self.notesArray addObject:model];
            }
        }
    } else if (index == 3) {
        targetDate = [CDDateHelper addToDate:[NSDate date] days:-30];
        for (CDNoteModel *model in allNote) {
            if ([model.createDate timeIntervalSince1970] < [targetDate timeIntervalSince1970]) {
                [self.notesArray addObject:model];
            }
        }
    }
    
    [self.tableViewNotes reloadData];
    
}

#pragma mark - IBAction Method
- (void)navigationButtonPressEvent:(UIButton *)button
{
    switch (button.tag) {
        case 0:
        {
            // 点击切换列表筛选条件
            self.filterView.hidden = self.filterView.tag;
            self.filterView.tag = !(self.filterView.tag);
            
        }
            break;
        case 1:
        {
            // 点击进入日期选择
            self.filterView.hidden = YES;
            self.filterView.tag = 0;
            
        }
            break;
        case 2:
        {
            // 点击开始搜索
            self.filterView.hidden = YES;
            self.filterView.tag = 0;
            
            
            [self initTitleViewToSearchBar];
            
            
        }
            break;
        case 3:
        {
            self.filterView.hidden = YES;
            self.filterView.tag = 0;
            // 点击添加新的记事本
            CDAddOrEditNoteViewController *addController = [[CDAddOrEditNoteViewController alloc] init];
            [self.navigationController pushViewController:addController animated:YES];
        }
            break;
        case 4:  // 取消搜索状态
        {
            self.filterView.hidden = YES;
            self.filterView.tag = 0;
            
            [self initTitleView];
            [self filterDataListByIndex:_filterIndex];
        }
            break;
        default:
            break;
    }
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDNoteItemCell *cell = [[CDNoteItemCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.noteModel = self.notesArray[indexPath.section];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchView.textField resignFirstResponder];
    self.searchView.textField.text = @"";
    
    self.filterView.hidden = YES;
    self.filterView.tag = 0;
    
    CDNoteModel *model = [self.notesArray objectAtIndex:indexPath.section];
    CDNoteDetailsViewController *detailsController = [[CDNoteDetailsViewController alloc] initWithNote:model];
    [self.navigationController pushViewController:detailsController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDNoteModel *note = self.notesArray[indexPath.section];
    return [[[CDNoteItemCell alloc] init] fitHeightByNote:note];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.notesArray.count == 0) {
        [self.view addSubview:self.viewEmpty];
        [self.viewEmpty mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    } else {
        [self.viewEmpty removeFromSuperview];
    }
    return self.notesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 8.0;
    } else {
        return 4.0; // cell之间的间距
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section + 1 == self.notesArray.count) {
        return 8.0;
    } else {
        return 4.0;
    }
}

//加入左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditing:false animated:NO];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0)
{
    // 添加一个删除按钮
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        CDAlertObject *alertView = [CDAlertObject alertPreferredStyle:CDAlertObjectStyleAlert withTitle:@"提示" message:@"确定要删除这条笔记吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] eventOfClickedBlock:^(NSInteger indexClick) {
            
            if (indexClick == 1) {
                CDNoteModel *model = [self.notesArray objectAtIndex:[indexPath row]];
                BOOL result = [model deleteObject];
                if (result) {
                    [self filterDataListByIndex:_filterIndex];
                    [self.tableViewNotes reloadData];
                } else {
                    [self showTipsViewText:@"删除失败,请稍后重试" delayTime:1.2];
                }
                
            }
            
        }];
        [alertView showAlert];
    }];
    return @[deleteRowAction];
}

#pragma mark Keyboard Delegate
- (void)textFieldTheTextChanged:(UITextField *)textField
{
    if (self.searchView.textField == textField) {
        NSString *searchKeyword = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *sql = [NSString stringWithFormat:@"user_id = %zi and note_content CONTAINS \"%@\"",[[[CDSharedDataManager shareManager] currentUser] userId],searchKeyword];
        NSArray *result = [CDNoteModel queryObjectByCondition:sql];
        self.notesArray = [NSMutableArray arrayWithArray:result];
        [self.tableViewNotes reloadData];
    }
}

#pragma mark - Getter Method
- (UIButton *)buttonTitle
{
    if (_buttonTitle == nil) {
        _buttonTitle = [[UIButton alloc] init];
        
        [_buttonTitle addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside]; // 监听按钮点击
        _buttonTitle.tag = 0;
        
        UILabel *label = [[UILabel alloc] init];
        label.tag = 100;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = UIFONT_BOLD_16;
        label.textColor = NavigationBarTitleColor;
        [_buttonTitle addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_buttonTitle.mas_centerX).offset(6.0);
            make.top.equalTo(_buttonTitle);
            make.bottom.equalTo(_buttonTitle);
            make.width.equalTo(@25.0);
        }];
        
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"home_navigation_row_down"];
        [_buttonTitle addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left);
            make.centerY.equalTo(label.mas_centerY);
            make.height.equalTo(@12.0);
            make.width.equalTo(@12.0);
        }];
        
        
    }
    return _buttonTitle;
}

- (CDFilterSelectView *)filterView
{
    if (_filterView == nil) {
        NSArray *menuTitle = @[@"全部",@"本周",@"本月",@"一个月前"];
        _filterView = [[CDFilterSelectView alloc] initWithFilterDataList:menuTitle onSelectedBlock:^(NSInteger index) {
            _filterIndex = index;
            _buttonTitle = nil;
            
            // 更新title显示
            UILabel *title = [self.buttonTitle viewWithTag:100];
            title.text = menuTitle[_filterIndex];
            CGSize textSize = [title textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH - 200.0, 64.0) limitedToNumberOfLines:1].size;
            [title mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(textSize.width + 5.0));
            }];
            self.buttonTitle.cd_size = CGSizeMake(textSize.width + 10*2.0 + 15.0, 44.0);
            self.navigationItem.titleView = self.buttonTitle;
            
            [self filterDataListByIndex:_filterIndex];
        }];
        [self.view addSubview:_filterView];
        [_filterView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view);
//            make.centerX.equalTo(self.view);
//            make.height.equalTo(@160);
//            make.width.equalTo(@120);
            make.edges.equalTo(self.view);
        }];
    }
    return _filterView;
}


- (UITableView *)tableViewNotes
{
    if (_tableViewNotes == nil) {
        _tableViewNotes = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableViewNotes.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewNotes.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self.view addSubview:_tableViewNotes];
        [_tableViewNotes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _tableViewNotes;
}

- (CDSearchBarView *)searchView
{
    if (_searchView == nil) {
        _searchView = [[CDSearchBarView alloc] init];
        
    }
    return _searchView;
}

- (UIView *)viewEmpty
{
    if (_viewEmpty == nil) {
        _viewEmpty = [[UIView alloc] init];
        _viewEmpty.backgroundColor = [UIColor clearColor];
        
        UILabel *title = [[UILabel alloc] init];
        title.textColor = COLOR_TITLE2;
        title.font = UIFONT_14;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"暂时木有数据哦~";
        [_viewEmpty addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewEmpty);
            make.right.equalTo(_viewEmpty);
            make.top.equalTo(_viewEmpty);
            make.bottom.equalTo(_viewEmpty).offset(-200.0);
        }];
    }
    return _viewEmpty;
}

@end
