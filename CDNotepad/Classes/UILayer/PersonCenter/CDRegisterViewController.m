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
#import "CDLoginButtonCell.h"
#import "CDUserModel.h"
#import "AppDelegate.h"


@interface CDRegisterViewController ()<UITableViewDelegate ,UITableViewDataSource,CDKeyboardManagerDelegate>
{
    UITextField *_textFieldInput[3];
}
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[CDKeyboardManager sharedKeyboard] setEventDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - IBAction
- (void)registerButtonClickedEvent:(UIButton *)button
{
    if ([CDTools stringByTrimmingCharacters:_textFieldInput[0].text].length <= 0) {
        [self showTipsViewText:@"请输入用户名" delayTime:1.0];
        return;
    } else if ([CDTools validateIsOnlyNumberOrLetter:[CDTools stringByTrimmingCharacters:_textFieldInput[0].text]] == NO) {
        [self showTipsViewText:@"用户名仅支持输入字母或数字" delayTime:1.0];
        return;
    } else if ([CDTools stringByTrimmingCharacters:_textFieldInput[1].text].length <= 0) {
        [self showTipsViewText:@"请输入密码" delayTime:1.0];
        return;
    } else if ([[CDTools stringByTrimmingCharacters:_textFieldInput[1].text] isEqualToString:[CDTools stringByTrimmingCharacters:_textFieldInput[2].text]] == NO) {
        [self showTipsViewText:@"您输入的密码与确认密码不一致" delayTime:1.0];
        return;
    } else if ([CDUserModel checkUserIsExistByUserName:[CDTools stringByTrimmingCharacters:_textFieldInput[0].text]]) {
        [self showTipsViewText:@"用户名已存在，请修改后重试" delayTime:1.0];
        return;
    }
    
    [self.view endEditing:YES];
    
    // 插入用户表
    CDUserModel *user = [[CDUserModel alloc] init];
    user.name = [CDTools stringByTrimmingCharacters:_textFieldInput[0].text];
    user.password = [CDTools stringByTrimmingCharacters:_textFieldInput[1].text];
    BOOL result = [user insertTable];
    
    if (result) {
        CDUserModel *loginUser = [CDUserModel loginByUserName:user.name andUserPassword:user.password];
        if ([loginUser isKindOfClass:[CDUserModel class]]) {
            [[CDSharedDataManager shareManager] setCurrentLoginUser:loginUser];
            [self showTipsViewText:@"恭喜您，注册成功" delayTime:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                appDelegate.window.rootViewController = [CDTabBarController sharedTabBarController];
            });
            
        } else {
            [self showTipsViewText:@"注册失败，请稍后重试" delayTime:1.0];
        }
    } else {
        [self showTipsViewText:@"注册失败，请稍后重试" delayTime:1.0];
    }
}

#pragma mark 键盘事件
- (void)keyboardWillShowEventByUserInfo:(NSDictionary *)userInfo
{
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect bounds = [value CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(bounds));
    [self.tableViewRegister mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bounds.size.height);
    }];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHiddenEventByUserInfo:(NSDictionary *)userInfo
{
    [self.tableViewRegister mas_updateConstraints:^(MASConstraintMaker *make) {
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
            CDLoginHeaderCell *headerCell = [[CDLoginHeaderCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            
            return headerCell;
        }
            break;
        case 1:
        {
            CDLoginInputCell *loginCell = [[CDLoginInputCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            [loginCell setInputType:indexPath.row];
            _textFieldInput[indexPath.row] = loginCell.textField;
            return loginCell;
        }
            break;
        case 2:
        {
            CDLoginButtonCell *buttonCell = [[CDLoginButtonCell alloc] initWithRestorationIdentifier:@"CDLoginButtonCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            [buttonCell setButtonType:1];
            [buttonCell setButtonAction:@selector(registerButtonClickedEvent:) andTarget:self];
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
        return 130.0;
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
