//
//  CDMineViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDMineViewController.h"
#import "CDHeaderCell.h"
#import "CDLoginButtonCell.h"
#import "CDLoginViewController.h"
#import "AppDelegate.h"

@interface CDMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableViewMine;
@end

@implementation CDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableViewMine.delegate = self;
    self.tableViewMine.dataSource = self;
    
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    //
//    UIView *viewBg = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, 60.0)];
//    
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH/2.0, 30.0)];
//    button.center =CGPointMake(SCREEN_WIDTH/2.0, 15.0);
//    [button setTitle:@"退出登录" forState:UIControlStateNormal];
//    button.backgroundColor = [UIColor redColor];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.layer.cornerRadius = 5.0f;
//    [viewBg addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(viewBg).offset(30.0);
//        make.right.equalTo(viewBg).offset(-30.0);
//        make.centerY.equalTo(viewBg);
//        make.height.equalTo(@40.0);
//    }];
//    self.tableViewMine.tableFooterView = viewBg;
    
    
}


#pragma mark - IBAction
- (void)logoutButtonClickedEvent:(UIButton *)button
{
    CDAlertObject *alertView = [CDAlertObject alertPreferredStyle:CDAlertObjectStyleAlert withTitle:@"提示" message:@"确定要退出当前账户吗？" cancelButtonTitle:@"点错啦" otherButtonTitles:@[@"确定"] eventOfClickedBlock:^(NSInteger indexClick) {
        if (indexClick == 1) {
            CDLoginViewController *loginController = [[CDLoginViewController alloc] init];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = [[CDNavigationController alloc] initWithRootViewController:loginController];
        }
    }];
    [alertView showAlert];
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            CDHeaderCell *header = [[CDHeaderCell alloc] initWithRestorationIdentifier:@"CDHeaderCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            

            return header;
        }
            break;
        case 1:
        {
            CDBaseTableViewCell *cell = [[CDBaseTableViewCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //加入箭头
            if ([indexPath row] == 0) {
                cell.textLabel.text = @"资料修改";
                
                UILabel *line = [[UILabel alloc] init];
                line.backgroundColor = tableView.backgroundColor;
                [cell addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell);
                    make.right.equalTo(cell);
                    make.bottom.equalTo(cell);
                    make.height.equalTo(@0.8);
                }];
            } else if ([indexPath row] == 1) {
                cell.textLabel.text = @"设置";
            }
            
            return cell;
        }
            break;
        case 2:
        {
            CDLoginButtonCell *buttonCell = [[CDLoginButtonCell alloc] initWithRestorationIdentifier:@"CDLoginButtonCell" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            buttonCell.backgroundColor = tableView.backgroundColor;
            [buttonCell setButtonType:2];
            [buttonCell setButtonAction:@selector(logoutButtonClickedEvent:) andTarget:self];
            return buttonCell;
        }
            break;
        default:
            return [[CDBaseTableViewCell alloc] initWithRestorationIdentifier:@"" onTableView:tableView selectionStyle:UITableViewCellSelectionStyleNone];
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        return 180.0;
    } else if ([indexPath section] == 1) {
        return 45.0;
    } else if ([indexPath section] == 2) {
        return 80.0;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1.0;
    } else {
        return 10.0; // cell之间的间距
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

#pragma mark - Getter Method
- (UITableView *)tableViewMine
{
    if (_tableViewMine == nil) {
        _tableViewMine = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableViewMine.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableViewMine.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_tableViewMine setClipsToBounds:YES];
        [self.view addSubview:_tableViewMine];
        [_tableViewMine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    
    return _tableViewMine;
}

@end
