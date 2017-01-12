//
//  CDNavigationController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDNavigationController.h"

@interface CDNavigationController ()

@end



// 3.导航栏标题的字体
#define MTNavigationTitleFont [UIFont systemFontOfSize:18.0]
#define  MTNavigationBarColorBlack  DefineColorRGB(243, 243, 243, 1.0)

@implementation CDNavigationController

#pragma mark - Theme的主题
/**
 *  当第一次使用这个类的时候调用1次
 */
+ (void)initialize
{
    // 设置UINavigationBarTheme的主
    [self setupNavigationBarTheme];
    
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**
 *  设置UINavigationBarTheme的主题
 */
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NavigationBarTitleColor;
    // UITextAttributeFont  --> NSFontAttributeName(iOS6)
    textAttrs[NSFontAttributeName] = MTNavigationTitleFont;
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = [[NSValue valueWithUIOffset:UIOffsetZero] CGSizeValue];
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs];
    [appearance setTintColor:DefineColorRGB(100, 100, 100, 1.0)];
    // 设置导航栏背景颜色
    [appearance setBarTintColor:NavigationBarTitleColor];
}

/**
 *  设置UIBarButtonItem的主题
 */
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = NavigationBarTitleColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = [[NSValue valueWithUIOffset:UIOffsetZero] CGSizeValue];
    textAttrs[NSShadowAttributeName] = shadow;
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
    
    /**设置背景**/
    // 技巧: 为了让某个按钮的背景消失, 可以设置一张完全透明的背景图片
    //    [appearance setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}


#pragma mark
- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationBar.barTintColor = DefineColorRGB(243, 243, 243, 1.0);
    
    /**
     * 去掉导航栏原生的底部黑线
     */
    [[self navigationBar] setShadowImage:[[UIImage alloc] init]];
    //  背景拉伸
    UIImage *imageBg = [UIImage imageNamed:@"navigation_bg_color"];
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10 ; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    [[self navigationBar] setBackgroundImage:[imageBg resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile] forBarMetrics:UIBarMetricsDefault];
    //    [[self navigationBar] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    
    /**
     *  为导航栏添加底部阴影
     */
    [self navigationBar].layer.shadowColor = VIEW_BOTTOM_SHADOW_COLOR.CGColor; //shadowColor阴影颜色
    [self navigationBar].layer.shadowOffset = CGSizeMake(0.0f , 1.0f); //shadowOffset阴影偏移x，y向(上/下)偏移(-/+)2
    [self navigationBar].layer.shadowOpacity = 0.6f;//阴影透明度，默认0
    [self navigationBar].layer.shadowRadius = 1.0f;//阴影半径
    
    
//    self.delegate = self;
    //  设置导航手势不可用
//    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark 
/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];

    [super pushViewController:viewController animated:YES];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:YES];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    return [super popToRootViewControllerAnimated:NO];
}






@end
