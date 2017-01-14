//
//  CDPhotoManager.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>


@interface CDPhotoManager : NSObject

@property (nonatomic, readonly) NSMutableArray *assets;




+ (CDPhotoManager *)sharePhotos;

- (void)loadedAssets;


// Load from photos library
// 生成指定相册资源的图片对象
- (NSInteger)getImageWithAsset:(PHAsset *)asset completeNotify:(void(^)(UIImage *image))notify;

// 保存指定照片到指定目录
- (void)saveImageWithAsset:(PHAsset *)asset toSavePathDirectory:(NSString *)savePathDir completeNotify:(void(^)(BOOL saveResult,NSString *saveFullPath))notify;
@end
