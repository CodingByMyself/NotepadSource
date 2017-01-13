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
{
    UITextField *_textFieldInput[2];
}
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
        if ([CDTools stringByTrimmingCharacters:_textFieldInput[0].text].length <= 0) {
            [self showTipsViewText:@"请输入用户名" delayTime:1.0];
            return;
        } else if ([CDTools validateIsOnlyNumberOrLetter:[CDTools stringByTrimmingCharacters:_textFieldInput[0].text]] == NO) {
            [self showTipsViewText:@"用户名仅支持输入字母或数字" delayTime:1.0];
            return;
        } else if ([CDTools stringByTrimmingCharacters:_textFieldInput[1].text].length <= 0) {
            [self showTipsViewText:@"请输入密码" delayTime:1.0];
            return;
        }
        
        [self.view endEditing:YES];
        
        // 准备登录
        CDUserModel *loginUser = [CDUserModel loginByUserName:[CDTools stringByTrimmingCharacters:_textFieldInput[0].text] andUserPassword:[CDTools stringByTrimmingCharacters:_textFieldInput[1].text]];
        if (loginUser.userId > 0) {
            [[CDSharedDataManager shareManager] setCurrentLoginUser:loginUser];
            [self showTipsViewText:@"恭喜您，登录成功" delayTime:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.window.rootViewController = [CDTabBarController sharedTabBarController];
            });
        } else if (loginUser.userId == -1){
            [self showTipsViewText:@"用户名或密码不正确" delayTime:1.0];
        } else if (loginUser.userId == -2) {
            [self showTipsViewText:@"用户不存在" delayTime:1.0];
        }
        
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
            [loginCell setInputType:indexPath.row];
            _textFieldInput[indexPath.row] = loginCell.textField;
            return loginCell;
        }
            break;
        case 2:
        {
            CDLoginButtonCell *buttonCell = [[CDLoginButtonCell alloc] initWithRestorationIdentifier:@"CDLoginButtonCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            [buttonCell setButtonType:0];
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
    [self.view endEditing:YES];
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
