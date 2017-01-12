//
//  CDTabBarController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDTabBarController.h"
#import "CDTabBarView.h"

#import "CDHomeViewController.h"
#import "CDMineViewController.h"


@interface CDTabBarController () <UINavigationControllerDelegate>
@property (strong, nonatomic) CDTabBarView *bottomTabBarView;
@end

@implementation CDTabBarController

/**
 *  获取并生成一个底部导航控制器的单实例
 * 注：因为整个App运行过程中只会有一个底部导航控制器，所以写成单例；
 * 方便在任何地方通过 " [CDTabBarController sharedTabBarController] " 去访问该实例对象以及其公开的成员属性；
 *
 *  @return 底部导航控制器的单实例
 */
+ (instancetype)sharedTabBarController
{
    static CDTabBarController *_sharedTabBarController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTabBarController = [[CDTabBarController alloc] init];
    });
    return _sharedTabBarController;
}

#pragma mark - view
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupCustomBottomTabbar];
    
    //  默认选中首页,避免循环调用单例初始化
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomTabBarView setSelectedItemIndex:0];
    });
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupViewControllers];  //  装载控制器
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[self.selectedViewController viewControllers] count] <= 1) {
        [self showCustomTabbar];
    } else {
        [self hideCustomTabbar];
    }
}

#pragma mark  初始化底部标签导航
- (void)setupCustomBottomTabbar
{
    self.tabBar.hidden=YES;
    _bottomTabBarView = [[CDTabBarView alloc] init];
    [self.view addSubview:_bottomTabBarView];
    [_bottomTabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(CDTabBarBottomViewHeight));
    }];
}

// 初始化控制器
- (void)setupViewControllers
{
    if ([self viewControllers] == 0) {
        //首页
        CDHomeViewController *home = [[CDHomeViewController alloc] init];
        home.title = @"记事本";
        CDNavigationController *oneNavi = [[CDNavigationController alloc] initWithRootViewController:home];
        oneNavi.delegate = self;
//        [oneNavi setNavigationBarHidden:YES];

        //我的
        CDMineViewController *personal =  [[CDMineViewController alloc] init];
        personal.title = @"我的";
        CDNavigationController *twoNavi = [[CDNavigationController alloc] initWithRootViewController:personal];
        twoNavi.delegate = self;
//        [fourNavi setNavigationBarHidden:YES];
        [self setViewControllers:@[oneNavi,twoNavi]]; //  装载控制器
        
        
    }
}

#pragma mark - UINavigationController Delegate Method
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.selectedViewController == navigationController) {
        if ([[navigationController viewControllers] firstObject] == viewController) {
            [self showCustomTabbar];
        } else {
            [self hideCustomTabbar];
        }
    }
}


#pragma mark  - 隐藏 底部标签导航
- (void)hideCustomTabbar
{
    //    for (UIView *view in self.view.subviews) {
    //        if ((![view isKindOfClass:[UITabBar class]])&&(![view isKindOfClass:[CDTabBarView class]])) {
    //            view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //        }
    //    }
    
    [self.bottomTabBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(CDTabBarBottomViewHeight);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark 显示 底部标签导航
- (void)showCustomTabbar
{
    [self.bottomTabBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        //        for (UIView *view in self.view.subviews) {
        //            if ((![view isKindOfClass:[UITabBar class]])&&(![view isKindOfClass:[CDTabBarView class]])) {
        //                view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49);
        //            }
        //        }
    }];
}

#pragma mark 设置 选择底部指定的标签项
- (void)setSelectedBottomItemOfIndex:(NSUInteger)index
{
    [self.bottomTabBarView setSelectedItemIndex:index];
    
    if ([[self.selectedViewController viewControllers] count] > 1) {
        [self hideCustomTabbar];
    } else {
        [self showCustomTabbar];
    }
}

#pragma mark  Getter Method
- (CDBaseViewController *)currentDisplayController
{
    CDBaseViewController *currentController;
    if ([self.selectedViewController isKindOfClass:[CDNavigationController class]]) {
        UINavigationController *navi = self.selectedViewController;
        currentController = [[navi viewControllers] lastObject];
    } else if ([self.selectedViewController isKindOfClass:[CDBaseViewController class]]) {
        currentController = self.selectedViewController;
    }
    return currentController;
}


@end
