//
//  CDNoteDetailsViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDNoteDetailsViewController.h"
#import "CDAddOrEditNoteViewController.h"
#import "CDNoteModel.h"
#import "CDInputCollectionCell.h"
#import "CDVoiceCollectionCell.h"
#import "CDPictureCollectionCell.h"

@interface CDNoteDetailsViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CDNoteModel *_nodeDetails;
}
@property (nonatomic,strong) UICollectionView *collectionViewDetails;
@end

@implementation CDNoteDetailsViewController

#pragma mark
- (instancetype)initWithNote:(CDNoteModel *)noteModel
{
    self = [super init];
    if (self) {
        _nodeDetails = noteModel;
    }
    return self;
}


#pragma mark
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTitleView];
    
    // 右侧搜索按钮
    UIButton *rightButton1 = [[UIButton alloc] init];
    rightButton1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightButton1 setImage:[UIImage imageNamed:@"details_page_edit_icon"] forState:UIControlStateNormal];
    [rightButton1 setTintColor:[UIColor whiteColor]];
    rightButton1.cd_size = CGSizeMake(30.0, 20.0);
    rightButton1.tag = 1;
    [rightButton1 addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];// 监听按钮点击
    
    UIButton *rightButton2 = [[UIButton alloc] init];
    rightButton2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [rightButton2 setImage:[UIImage imageNamed:@"details_page_delete_icon"] forState:UIControlStateNormal];
    [rightButton2 setTintColor:[UIColor whiteColor]];
    rightButton2.cd_size = CGSizeMake(30.0, 20.0);
    rightButton2.tag = 2;
    [rightButton2 addTarget:self action:@selector(navigationButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];// 监听按钮点击
    
    // 设置按钮
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:rightButton1],[[UIBarButtonItem alloc] initWithCustomView:rightButton2]];
    
    
    // 设置代理对象
    self.collectionViewDetails.delegate = self;
    self.collectionViewDetails.dataSource = self;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *sql = [NSString stringWithFormat:@"rm_id = %zi",_nodeDetails.noteId];
    _nodeDetails = [[CDNoteModel queryObjectByCondition:sql] firstObject];
    
    [self.collectionViewDetails reloadData];
}

- (void)initTitleView
{
    UIView *viewTitle = [[UIView alloc] init];
    // 设置时间title
    UILabel *title1 = [[UILabel alloc] init];
    //        title1.text = [CDDateHelper date:date toStringByFormat:@"yyyy年MM月dd日"];
    title1.tag = 1;
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = UIFONT_BOLD_16;
    title1.textColor = NavigationBarTitleColor;
    title1.text = [CDDateHelper date:_nodeDetails.createDate toStringByFormat:@"yyyy年MM月dd日"];
    [viewTitle addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTitle);
        make.right.equalTo(viewTitle);
        make.top.equalTo(viewTitle).offset(10.0);
        make.bottom.equalTo(viewTitle.mas_centerY);
    }];
    
    
    UILabel *title2 = [[UILabel alloc] init];
    //        title2.text = [CDDateHelper date:date toStringByFormat:@"hh:mm"];
    title2.tag = 2;
    title2.textAlignment = NSTextAlignmentCenter;
    title2.font = UIFONT_12;
    title2.textColor = COLOR_TITLE1;
    title2.text = [CDDateHelper date:_nodeDetails.createDate toStringByFormat:@"HH:mm"];
    [viewTitle addSubview:title2];
    [title2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewTitle);
        make.right.equalTo(viewTitle);
        make.top.equalTo(title1.mas_bottom);
        make.bottom.equalTo(viewTitle);
    }];
    
    viewTitle.cd_size = CGSizeMake(SCREEN_WIDTH - 160, 44.0);
    self.navigationItem.titleView = viewTitle;

}

#pragma mark - IBAction
- (void)navigationButtonPressEvent:(UIButton *)button
{
    if (button.tag == 1) {
        // 进入编辑
        CDAddOrEditNoteViewController *eidtController = [[CDAddOrEditNoteViewController alloc] initWithControllerType:1 andNoteModel:_nodeDetails];
        [self.navigationController pushViewController:eidtController animated:YES];
        
    } else if (button.tag == 2) {
        // 删除当前笔记
//        CDNoteModel *model = [self.notesArray objectAtIndex:[indexPath row]];
        CDAlertObject *alertView = [CDAlertObject alertPreferredStyle:CDAlertObjectStyleAlert withTitle:@"提示" message:@"确定要删除这条笔记吗？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] eventOfClickedBlock:^(NSInteger indexClick) {
            if (indexClick == 1) {
                BOOL result = [_nodeDetails deleteObject];
                if (result) {
                    [self showTipsViewText:@"删除成功" delayTime:1.2];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    [self showTipsViewText:@"删除失败,请稍后重试" delayTime:1.2];
                }
            }
        }];
        [alertView showAlert];
        
    }
}

#pragma mark -  Collection View Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
        {
            // 文字输入
            [self.collectionViewDetails registerClass:[CDInputCollectionCell class] forCellWithReuseIdentifier:@"CDInputCollectionCell"];
            CDInputCollectionCell * cell = (CDInputCollectionCell *)[self.collectionViewDetails dequeueReusableCellWithReuseIdentifier:@"CDInputCollectionCell" forIndexPath:indexPath];
            
            
            [cell setup:_nodeDetails.title OnInputTextChanged:nil];
            [cell setDisableEidt];
            
            
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
            break;
        case 1:
        {
            // 语音
            [self.collectionViewDetails registerClass:[CDVoiceCollectionCell class] forCellWithReuseIdentifier:@"CDVoiceCollectionCell"];
            CDVoiceCollectionCell * cell = (CDVoiceCollectionCell *)[self.collectionViewDetails dequeueReusableCellWithReuseIdentifier:@"CDVoiceCollectionCell" forIndexPath:indexPath];
            cell.path = [_nodeDetails.voicePathList objectAtIndex:indexPath.row];
            [cell setup];
            [cell setDisableEidt];
            
            cell.tag = [indexPath row];
            return cell;
        }
            break;
        case 2:
        {
            // 图片
            [self.collectionViewDetails registerClass:[CDPictureCollectionCell class] forCellWithReuseIdentifier:@"CDPictureCollectionCell"];
            CDPictureCollectionCell * cell = (CDPictureCollectionCell *)[self.collectionViewDetails dequeueReusableCellWithReuseIdentifier:@"CDPictureCollectionCell" forIndexPath:indexPath];
            
            
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
            UILabel *labeltext = [[UILabel alloc] init];
            labeltext.textColor = COLOR_TITLE1;
            labeltext.font = UIFONT_14;
            labeltext.text = _nodeDetails.title;
            CGRect textRect = [labeltext textRectForBounds:CGRectMake(0, 0, SCREEN_WIDTH - 15*2, SCREEN_HEIGHT) limitedToNumberOfLines:0];
            size = CGSizeMake(collectionView.cd_width, textRect.size.height + 50.0);
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
            number = _nodeDetails.voicePathList.count;
        }
            break;
        case 2:
        {
            // 图片
            number = _nodeDetails.picturePathList.count;
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
- (UICollectionView *)collectionViewDetails
{
    if (_collectionViewDetails == nil) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.isSuspend = YES;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewDetails.collectionViewLayout = flowLayout;
        _collectionViewDetails = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionViewDetails.backgroundColor = [UIColor whiteColor];
        _collectionViewDetails.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionViewDetails];
        [_collectionViewDetails mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(5.0);
            make.right.equalTo(self.view).offset(-5.0);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _collectionViewDetails;
}

@end
