//
//  CDSelectPictureViewController.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDSelectPictureViewController.h"
#import "CDPictureCollectionCell.h"

@interface CDSelectPictureViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray <PHAsset *>* _selectedList;
}
@property (nonatomic,strong) UICollectionView *collectionViewPhoto;

@end

@implementation CDSelectPictureViewController

#pragma mark - View
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"相册";
    
    
    /***** 右侧按钮 *****/
    UIButton *leftButton = [[UIButton alloc] init];
    leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftButton setImage:[UIImage imageNamed:@"new_or_edit_navigation_item_finished_icon"] forState:UIControlStateNormal];
    [leftButton setTintColor:[UIColor whiteColor]];
    leftButton.cd_size = CGSizeMake(30.0, 20.0);
    leftButton.tag = 3;
    // 监听按钮点击
    [leftButton addTarget:self action:@selector(navigationRightButtonPressEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    

    _selectedList = [[NSMutableArray alloc] init];
    // 设置代理对象
    self.collectionViewPhoto.delegate = self;
    self.collectionViewPhoto.dataSource = self;
}

- (void)navigationRightButtonPressEvent:(UIButton *)button
{
//    [self.navigationController pushViewController:_browser animated:YES];
    if (_selectedList.count == 0) {
        [self showTipsViewText:@"您还没有选中的图片哦~" delayTime:1.0];
        return;
    }
    
    for (PHAsset *asset in _selectedList){
        [[CDPhotoManager sharePhotos] saveImageWithAsset:asset toSavePathDirectory:[CDTools getSandboxPath] completeNotify:^(BOOL saveResult, NSString *saveFullPath) {
            
            NSLog(@"saveResult = %zi , saveFullPath = %@",saveResult,saveFullPath);
            
            
        }];
    }
}


#pragma mark -  Collection View Delegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 图片
    [self.collectionViewPhoto registerClass:[CDPictureCollectionCell class] forCellWithReuseIdentifier:@"CDPictureCollectionCell"];
    __block CDPictureCollectionCell * cell = (CDPictureCollectionCell *)[self.collectionViewPhoto dequeueReusableCellWithReuseIdentifier:@"CDPictureCollectionCell" forIndexPath:indexPath];
    
    PHAsset *asset = [[[CDPhotoManager sharePhotos] assets] objectAtIndex:indexPath.row];
    
    UIImage *buttonImage = [_selectedList containsObject:asset] ? [UIImage imageNamed:@"photo_image_selected_on_status_icon"] : [UIImage imageNamed:@"photo_image_selected_off_status_icon"];
    [[CDPhotoManager sharePhotos] getImageWithAsset:asset completeNotify:^(UIImage *image) {
        [cell setImage:image andButtonImage:buttonImage];
    }];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    
    CDPictureCollectionCell *pictureCell = (CDPictureCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    PHAsset *asset = [[[CDPhotoManager sharePhotos] assets] objectAtIndex:indexPath.row];
    if ([_selectedList containsObject:asset]) {
        [_selectedList removeObject:asset];
        [pictureCell updateButtonImage:[UIImage imageNamed:@"photo_image_selected_off_status_icon"]];
    } else {
        [_selectedList addObject:asset];
        [pictureCell updateButtonImage:[UIImage imageNamed:@"photo_image_selected_on_status_icon"]];
    }
}

#pragma mark  Item Size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;
    // 图片
    CGFloat width = collectionView.cd_width/3.0 - 3.0;
    size = CGSizeMake(width, width);
    return size;
}

#pragma mark  Item Number  And  Section Number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger number;
    // 图片
    number = [[CDPhotoManager sharePhotos] assets].count;
    
    return number;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  Item  Spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0;
}

#pragma mark - Getter Method
- (UICollectionView *)collectionViewPhoto
{
    if (_collectionViewPhoto == nil) {
        UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc]init];
        //        flowLayout.isSuspend = YES;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionViewPhoto.collectionViewLayout = flowLayout;
        _collectionViewPhoto = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionViewPhoto.backgroundColor = [UIColor whiteColor];
        _collectionViewPhoto.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionViewPhoto];
        [_collectionViewPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view).offset(5.0);
            make.right.equalTo(self.view).offset(-5.0);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _collectionViewPhoto;
}




@end
