//
//  CDAlertObject.m
//  MangocityTravel
//
//  Created by Cindy on 2016/12/15.
//  Copyright © 2016年 Mangocity. All rights reserved.
//

#import "CDAlertObject.h"

@interface CDAlertObject () <UIAlertViewDelegate,UIActionSheetDelegate>
@property (nonatomic,strong) UIAlertView *alertView;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) UIAlertController *alertController;

@property (nonatomic,assign) CDAlertObjectStyle alertStyle;
@property (nonatomic,strong) NSArray *otherButtonTitles;
@property (nonatomic,copy) void (^ buttonClickedBlock)(NSInteger buttonIndex);

@end

@implementation CDAlertObject

#pragma mark - 初始化一个弹框的实例对象
+ (instancetype)alertPreferredStyle:(CDAlertObjectStyle)style withTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles eventOfClickedBlock:(void(^)(NSInteger indexClick))clickAction
{
    static CDAlertObject *object;
    object = [[CDAlertObject alloc] init];
    /*** 事件回调 ***/
    object.buttonClickedBlock = clickAction;
    object.alertStyle = style;
    /*** 所有titles ***/
    NSMutableArray *titleList = [[NSMutableArray alloc] init];
    [cancelButtonTitle isKindOfClass:[NSString class]]? [titleList addObject:cancelButtonTitle] : nil;
    [otherButtonTitles isKindOfClass:[NSArray class]] ? [titleList addObjectsFromArray:otherButtonTitles] : nil;
    object.otherButtonTitles = [NSArray arrayWithArray:titleList];
    
    /**** 根据类型和当前运行的系统版本初始化弹框 ***/
    switch (style) {
        case CDAlertObjectStyleAlert:
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                [object initAlertViewWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
            } else {
                [object initAlertControllerPreferredStyle:UIAlertControllerStyleAlert WithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
            }
        }
            break;
        case CDAlertObjectStyleActionSheet:
        {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
                [object initActionSheetWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
            } else {
                [object initAlertControllerPreferredStyle:UIAlertControllerStyleActionSheet WithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
            }
        }
            break;
        default:
            break;
    }
    
    //  返回管理实例对象
    return object;
}

#pragma mark - ios8及以上版本支持 UIAlertController
- (void)initAlertControllerPreferredStyle:(UIAlertControllerStyle)preferredStyle WithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    self.alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    // 添加取消事件
    WS(weakSelf);
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf buttonClickedEvent:action.title];
    }];
    [self.alertController addAction:cancelAction];
    
    // 添加其他事件
    for (NSString *butonTitle in otherButtonTitles) {
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:butonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf buttonClickedEvent:action.title];
        }];
        [self.alertController addAction:otherAction];
    }
}

#pragma mark  UIAlertAction Event Method
- (void)buttonClickedEvent:(NSString *)title
{
    NSInteger buttonIndex = [self.otherButtonTitles indexOfObject:title];
    self.buttonClickedBlock ? self.buttonClickedBlock(buttonIndex) : nil;
}

#pragma mark - ios8以下版本支持 UIAlertView / UIActionSheet
- (void)initAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    switch (otherButtonTitles.count) {
        case 0:
        {
            self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
        }
            break;
        case 1:
        {
            self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles[0], nil];
        }
            break;
        default:
            break;
    }
}

- (void)initActionSheetWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles
{
    NSString *titleString = [NSString stringWithFormat:@"%@\n%@",title,message];
    
    switch (otherButtonTitles.count) {
        case 0:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:nil];
        }
            break;
        case 1:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],nil];
        }
            break;
        case 2:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],nil];
        }
            break;
        case 3:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],nil];
        }
            break;
        case 4:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],nil];
        }
            break;
        case 5:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],nil];
        }
            break;
        case 6:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],otherButtonTitles[5],nil];
        }
            break;
        case 7:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],otherButtonTitles[5],otherButtonTitles[6],nil];
        }
            break;
        case 8:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],otherButtonTitles[5],otherButtonTitles[6],otherButtonTitles[7],nil];
        }
            break;
        case 9:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],otherButtonTitles[5],otherButtonTitles[6],otherButtonTitles[7],otherButtonTitles[8],nil];
        }
            break;
        case 10:
        {
            self.actionSheet = [[UIActionSheet alloc] initWithTitle:titleString delegate:self.buttonClickedBlock ?  self : nil cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:nil otherButtonTitles:otherButtonTitles[0],otherButtonTitles[1],otherButtonTitles[2],otherButtonTitles[3],otherButtonTitles[4],otherButtonTitles[5],otherButtonTitles[6],otherButtonTitles[7],otherButtonTitles[8],otherButtonTitles[9],nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark  Delegate Method (ios8以下)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == self.alertView && self.buttonClickedBlock) {
        self.buttonClickedBlock(buttonIndex);
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.actionSheet && self.buttonClickedBlock) {
        self.buttonClickedBlock(buttonIndex);
    }
}


#pragma mark  - 显示
/**
 显示弹框
 */
- (void)showAlert
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self.alertController animated:YES completion:nil];
    } else {
        if (self.alertStyle == CDAlertObjectStyleAlert) {
            [self.alertView show];
        } else if (self.alertStyle == CDAlertObjectStyleActionSheet) {
            [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        }
    }
}

- (void)showAlertOnController:(UIViewController *)target
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [target presentViewController:self.alertController animated:YES completion:nil];
    } else {
        if (self.alertStyle == CDAlertObjectStyleAlert) {
            [self.alertView show];
        } else if (self.alertStyle == CDAlertObjectStyleActionSheet) {
            [self.actionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
        }
    }
}

@end
