//
//  CDBaseViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseViewController.h"
#import "CDTipsView.h"

@interface CDBaseViewController ()

@end

@implementation CDBaseViewController

#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - Tips View
- (void)showTipsViewText:(NSString *)text
{
    [[CDTipsView sharedTips] setTargetView:self.view];
    [[CDTipsView sharedTips] tipString:text fontSize:14.0f];
    [[CDTipsView sharedTips] setTipsPostion:[[CDKeyboardManager sharedKeyboard] keyboardVisible] ? CDTipsViewShowPostionTop : CDTipsViewShowPostionBottom];
    [[CDTipsView sharedTips] show:YES];
}

- (void)showTipsViewText:(NSString *)text delayTime:(CGFloat)time
{
    [self showTipsViewText:text];
    [[CDTipsView sharedTips] hiden:YES delayTime:time];
}

- (void)hiddenTipsView
{
    [[CDTipsView sharedTips] hiden:YES];
}

@end
