//
//  CDLoginViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDLoginViewController.h"
#import "CDLoginHeaderCell.h"
#import "CDLoginInputCell.h"
#import "CDLoginButtonCell.h"
#import "CDRegisterViewController.h"
#import "AppDelegate.h"

@interface CDLoginViewController () <UITableViewDelegate ,UITableViewDataSource,CDKeyboardManagerDelegate>
@property (nonatomic,strong) UITableView *tableViewLogin;
@end

@implementation CDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES];
    
    // 设置代理
    self.tableViewLogin.delegate = self;
    self.tableViewLogin.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CDKeyboardManager sharedKeyboard] setEventDelegate:self];
}

#pragma mark - IBAction
- (void)loginButtonClickedEvent:(UIButton *)button
{
    if (button.tag == 1) {
        // 登录
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = [CDTabBarController sharedTabBarController];
        
    } else if (button.tag == 2) {
        // 注册
        CDRegisterViewController *registerController = [[CDRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerController animated:YES];
    }
}

#pragma mark 键盘事件
- (void)keyboardWillShowEventByUserInfo:(NSDictionary *)userInfo
{
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect bounds = [value CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(bounds));
    [self.tableViewLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bounds.size.height);
    }];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHiddenEventByUserInfo:(NSDictionary *)userInfo
{
    [self.tableViewLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(0);
    }];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            CDLoginHeaderCell *headerCell = [[CDLoginHeaderCell alloc] initWithRestorationIdentifier:@"CDLoginHeaderCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            
            return headerCell;
        }
            break;
        case 1:
        {
            CDLoginInputCell *loginCell = [[CDLoginInputCell alloc] initWithRestorationIdentifier:@"CDLoginInputCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            
            return loginCell;
        }
            break;
        case 2:
        {
            CDLoginButtonCell *buttonCell = [[CDLoginButtonCell alloc] initWithRestorationIdentifier:@"CDLoginButtonCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            [buttonCell setButtonAction:@selector(loginButtonClickedEvent:) andTarget:self];
            return buttonCell;
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
    } else if([indexPath section] == 1) {
        return 50.0;
    } else {
        return 100.0;
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
            return 2;
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
    return 3;
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
- (UITableView *)tableViewLogin
{
    if (_tableViewLogin == nil) {
        _tableViewLogin = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableViewLogin.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewLogin.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_tableViewLogin];
        [_tableViewLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _tableViewLogin;
}

@end
