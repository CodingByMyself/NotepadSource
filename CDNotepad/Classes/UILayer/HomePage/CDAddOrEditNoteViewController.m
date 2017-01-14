//
//  CDAddOrEditNoteViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDAddOrEditNoteViewController.h"
#import "CDInputCollectionCell.h"
#import "CDVoiceCollectionCell.h"
#import "CDPictureCollectionCell.h"
#import "CDAddAttachmentMenuView.h"
#import "CDSelectPictureViewController.h"
#import "CDNoteModel.h"

@interface CDAddOrEditNoteViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CDKeyboardManagerDelegate,CDAddAttachmentMenuViewDelegate>
{
    NSInteger _type;
    CDNoteModel *_currentNode;
}
@property (nonatomic,strong) UIView *viewTitle;
@property (nonatomic,strong) UICollectionView *collectionViewAdd;
@property (nonatomic,strong) CDAddAttachmentMenuView *menuView;

@end

@implementation CDAddOrEditNoteViewController

#pragma mark
- (instancetype)initWithControllerType:(NSInteger)type andNoteModel:(CDNoteModel *)noteModel
{
    self = [super init];
    if (self) {
        _type = type;
        _currentNode = noteModel;
    }
    return self;
}


#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置title
    if (_type == 0) {
        _currentNode = [[CDNoteModel alloc] init];
        _currentNode.createDate = [NSDate date];
    }
    UILabel *title1 = [self.viewTitle viewWithTag:1];
    title1.text = [CDDateHelper date:_currentNode.createDate toStringByFormat:@"yyyy年MM月dd日"];
    UILabel *title2 = [self.viewTitle viewWithTag:2];
    title2.text = [CDDateHelper date:_currentNode.createDate toStringByFormat:@"HH:mm"];
    
    self.viewTitle.cd_size = CGSizeMake(SCREEN_WIDTH - 160, 44.0);
    self.navigationItem.titleView = self.viewTitle;
    
    
    /***** 右侧按钮 *****/
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton setImage:[UIImage imageNamed:@"new_or_edit_navigation_item_finished_icon"] forState:UIControlStateNormal];
    [leftButton setTintColor:[UIColor whiteColor]];
    leftButton.cd_size = CGSizeMake(30.0, 20.0);
    leftButton.tag = 3;
    // 监听按钮点击
    [leftButton addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 设置代理对象
    self.collectionViewAdd.delegate = self;
    self.collectionViewAdd.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 设置键盘事件代理
    [[CDKeyboardManager sharedKeyboard] setEventDelegate:self];
}

- (void)updateTitleViewByNewDate:(NSDate *)date
{
    // 设置时间title
    UILabel *title1 = [self.viewTitle viewWithTag:1];
    title1.text = [CDDateHelper date:date toStringByFormat:@"yyyy年MM月dd日"];
    UILabel *title2 = [self.viewTitle viewWithTag:2];
    title2.text = [CDDateHelper date:date toStringByFormat:@"HH:mm"];
}


#pragma mark - IBAction Method
- (void)navigationButtonPressEvent:(UIButton *)button
{
    if (_currentNode.title.length > 0) {
        if (_type == 0) {
            // 插入数据库
            BOOL result = [_currentNode insertTable];
            if (result) {
                [self showTipsViewText:@"添加成功" delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [self showTipsViewText:@"创建失败，请稍后重试" delayTime:1.0];
            }
        } else {
            // 更新数据库
            BOOL result = [_currentNode updateObject];
            if (result) {
                [self showTipsViewText:@"更新成功" delayTime:1.0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            } else {
                [self showTipsViewText:@"更新失败，请稍后重试" delayTime:1.0];
            }
        }
        
    } else {
        [self showTipsViewText:@"您还没有输入文字内容哦~" delayTime:1.0];
    }
}


- (void)buttonDeleteOnVoiceCellClciked:(UIButton *)button
{
    NSLog(@"删除语音");
    [_currentNode.voicePathList removeObjectAtIndex:button.tag];
    [self.collectionViewAdd reloadData];
}

#pragma mark - CDAddAttachmentMenuView Delegate
- (void)menuView:(CDAddAttachmentMenuView *)menuView buttonSelectPictureClicked:(UIButton *)button
{
    NSLog(@"选择图片");
    [self.collectionViewAdd reloadData];
    
    CDSelectPictureViewController *selectedPicture = [[CDSelectPictureViewController alloc] init];
    [self.navigationController pushViewController:selectedPicture animated:YES];
}

- (void)menuView:(CDAddAttachmentMenuView *)menuView makeVoiceFinishedOnFilePath:(NSString *)filePath
{
    NSLog(@"录音结束，保存的相对路径：%@",filePath);
    [_currentNode.voicePathList addObject:filePath];
    [self.collectionViewAdd reloadData];
}

- (void)menuView:(CDAddAttachmentMenuView *)menuView selectedDate:(NSDate *)selectedDate
{
    _currentNode.createDate = selectedDate;
    [self updateTitleViewByNewDate:selectedDate];
}

#pragma mark 键盘事件
- (void)keyboardWillShowEventByUserInfo:(NSDictionary *)userInfo
{
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect bounds = [value CGRectValue];
    NSLog(@"%@",NSStringFromCGRect(bounds));
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-bounds.size.height);
    }];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHiddenEventByUserInfo:(NSDictionary *)userInfo
{
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
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


#pragma mark -  Collection View Delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    switch ([indexPath section]) {
        case 0:
        {
            // 文字输入
            [self.collectionViewAdd registerClass:[CDInputCollectionCell class] forCellWithReuseIdentifier:@"CDInputCollectionCell"];
            CDInputCollectionCell * cell = (CDInputCollectionCell *)[self.collectionViewAdd dequeueReusableCellWithReuseIdentifier:@"CDInputCollectionCell" forIndexPath:indexPath];
            
            
            [cell setup:_currentNode.title OnInputTextChanged:^(NSString *textString) {
                _currentNode.title = textString;
            }];
            
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
            break;
        case 1:
        {
            // 语音
            [self.collectionViewAdd registerClass:[CDVoiceCollectionCell class] forCellWithReuseIdentifier:@"CDVoiceCollectionCell"];
            CDVoiceCollectionCell * cell = (CDVoiceCollectionCell *)[self.collectionViewAdd dequeueReusableCellWithReuseIdentifier:@"CDVoiceCollectionCell" forIndexPath:indexPath];
            cell.path = [_currentNode.voicePathList objectAtIndex:indexPath.row];
            [cell setup];
            [cell setButtonDeleteAction:@selector(buttonDeleteOnVoiceCellClciked:) andTarget:self];
            
            cell.tag = [indexPath row];
            return cell;
        }
            break;
        case 2:
        {
            // 图片
            [self.collectionViewAdd registerClass:[CDPictureCollectionCell class] forCellWithReuseIdentifier:@"CDPictureCollectionCell"];
            CDPictureCollectionCell * cell = (CDPictureCollectionCell *)[self.collectionViewAdd dequeueReusableCellWithReuseIdentifier:@"CDPictureCollectionCell" forIndexPath:indexPath];
            
            
            cell.backgroundColor = [UIColor greenColor];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark  Item Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    switch ([indexPath section]) {
        case 0:
        {
            // 文字输入
            if (SCREEN_WIDTH > 320) {
                size = CGSizeMake(collectionView.cd_width, 200.0);
            } else {
                size = CGSizeMake(collectionView.cd_width, 120.0);
            }
        }
            break;
        case 1:
        {
            // 语音
            size = CGSizeMake(collectionView.cd_width, 50.0);
        }
            break;
        case 2:
        {
            // 图片
            CGFloat width = collectionView.cd_width/3.0 - 5.0;
            size = CGSizeMake(width, width);
        }
            break;
        default:
            break;
    }
    return size;
}

#pragma mark  Item Number  And  Section Number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number;
    switch (section) {
        case 0:
        {
            // 文字输入
            number = 1;
        }
            break;
        case 1:
        {
            // 语音
            number = _currentNode.voicePathList.count;
        }
            break;
        case 2:
        {
            // 图片
            number = _currentNode.picturePathList.count;
        }
            break;
        default:
            break;
    }
    
    return number;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

#pragma mark  Item  Spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

#pragma mark - Getter Method
- (UIView *)viewTitle
{
    if (_viewTitle == nil) {
        _viewTitle = [[UIView alloc] init];
        // 设置时间title
        UILabel *title1 = [[UILabel alloc] init];
//        title1.text = [CDDateHelper date:date toStringByFormat:@"yyyy年MM月dd日"];
        title1.tag = 1;
        title1.textAlignment = NSTextAlignmentCenter;
        title1.font = UIFONT_BOLD_16;
        title1.textColor = NavigationBarTitleColor;
        [_viewTitle addSubview:title1];
        [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTitle);
            make.right.equalTo(_viewTitle);
            make.top.equalTo(_viewTitle).offset(10.0);
            make.bottom.equalTo(_viewTitle.mas_centerY);
        }];
        
        
        UILabel *title2 = [[UILabel alloc] init];
//        title2.text = [CDDateHelper date:date toStringByFormat:@"hh:mm"];
        title2.tag = 2;
        title2.textAlignment = NSTextAlignmentCenter;
        title2.font = UIFONT_12;
        title2.textColor = COLOR_TITLE1;
        [_viewTitle addSubview:title2];
        [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_viewTitle);
            make.right.equalTo(_viewTitle);
            make.top.equalTo(title1.mas_bottom);
            make.bottom.equalTo(_viewTitle);
        }];
    }
    return _viewTitle;
}

- (UICollectionView *)collectionViewAdd
{
    if (_collectionViewAdd == nil) {
        CDCollectionViewFlowLayout *flowLayout= [[CDCollectionViewFlowLayout alloc]init];
        flowLayout.isSuspend = YES;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewAdd.collectionViewLayout = flowLayout;
        _collectionViewAdd = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionViewAdd.backgroundColor = [UIColor whiteColor];
        _collectionViewAdd.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionViewAdd];
        [_collectionViewAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(5.0);
            make.right.equalTo(self.view).offset(-5.0);
            make.bottom.equalTo(self.menuView.mas_top);
        }];
        
    }
    return _collectionViewAdd;
}

- (CDAddAttachmentMenuView *)menuView
{
    if (_menuView == nil) {
        _menuView = [[CDAddAttachmentMenuView alloc] init];
        _menuView.delegate = self;
        [self.view addSubview:_menuView];
        [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
            make.height.equalTo(@(AddAttachmentMenuHeight));
        }];
    }
    return _menuView;
}

@end
