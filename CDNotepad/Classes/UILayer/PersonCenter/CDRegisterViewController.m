//
//  CDRegisterViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDRegisterViewController.h"
#import "CDLoginHeaderCell.h"
#import "CDLoginInputCell.h"

@interface CDRegisterViewController ()<UITableViewDelegate ,UITableViewDataSource,CDKeyboardManagerDelegate>
@property (nonatomic,strong) UITableView *tableViewRegister;

@end

@implementation CDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    [self.navigationController setNavigationBarHidden:NO];
    
    // 设置代理
    self.tableViewRegister.delegate = self;
    self.tableViewRegister.dataSource = self;
    
    
    // 设置footer view
    UIView *viewBg = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, 80.0)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH/2.0, 30.0)];
    button.tag = 1;
    button.center =CGPointMake(SCREEN_WIDTH/2.0, 15.0);
    [button setTitle:@"注 册" forState:UIControlStateNormal];
    button.backgroundColor = MainColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0f;
    [viewBg addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewBg).offset(30.0);
        make.right.equalTo(viewBg).offset(-30.0);
        make.centerY.equalTo(viewBg);
        make.height.equalTo(@40.0);
    }];
    
    
    self.tableViewRegister.tableFooterView = viewBg;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            CDLoginHeaderCell *headerCell = [[CDLoginHeaderCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            
            return headerCell;
        }
            break;
        case 1:
        {
            CDLoginInputCell *loginCell = [[CDLoginInputCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            
            return loginCell;
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
    return [[CDBaseTableViewCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 200.0;
    } else {
        return 50.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 3;
        }
            break;
        case 2:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
    return 4.0;
}

#pragma mark - Getter Method
- (UITableView *)tableViewRegister
{
    if (_tableViewRegister == nil) {
        _tableViewRegister = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableViewRegister.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewRegister.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableViewRegister];
        [_tableViewRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _tableViewRegister;
}


@end
