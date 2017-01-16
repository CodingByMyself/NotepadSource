//
//  CDPhotoManager.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/13.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDPhotoManager.h"

@interface CDPhotoManager ()

@property (nonatomic, strong) ALAssetsLibrary *ALAssetsLibrary;

@end


@implementation CDPhotoManager

+ (CDPhotoManager *)sharePhotos
{
    static CDPhotoManager *shared;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[self alloc]init];
        [shared loadedAssets];
    });
    return shared;
}

#pragma mark
- (void)loadedAssets
{
    if (NSClassFromString(@"PHAsset")) {
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        }
    } else {
        // Assets library
        [self performLoadAssets];
    }
}

- (void)performLoadAssets
{
    
    // Initialise
    _assets = [[NSMutableArray alloc] init];
    
    // Load
    if (NSClassFromString(@"PHAsset")) {
        
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *options = [PHFetchOptions new];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *fetchResults = [PHAsset fetchAssetsWithOptions:options];
            [fetchResults enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_assets addObject:obj];
            }];
//            if (fetchResults.count > 0) {
//                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
//            }
        });
        
    } else {
        
        // Assets Library iOS < 8
//        _ALAssetsLibrary = [[ALAssetsLibrary alloc] init];
//        
//        // Run in the background as it takes a while to get all assets from the library
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
//            NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];
//            
//            // Process assets
//            void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
//                if (result != nil) {
//                    NSString *assetType = [result valueForProperty:ALAssetPropertyType];
//                    if ([assetType isEqualToString:ALAssetTypePhoto] || [assetType isEqualToString:ALAssetTypeVideo]) {
//                        [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
//                        NSURL *url = result.defaultRepresentation.url;
//                        [_ALAssetsLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
//                            if (asset) {
//                                @synchronized(_assets) {
//                                    [_assets addObject:asset];
//                                }
//                            }
//
//                        } failureBlock:^(NSError *error) {
//                            NSLog(@"operation was not successfull!");
//                        }];
//                        
//                    }
//                }
//            };
//            
//            // Process groups
//            void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
//                if (group != nil) {
//                    [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
//                    [assetGroups addObject:group];
//                }
//            };
//            
//            // Process!
//            [_ALAssetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:^(NSError *error) {
//                NSLog(@"There is an error");
//            }];
//            
//        });
        
    }
    
}

#pragma mark 
// Load from photos library
- (NSInteger)getImageWithAsset:(PHAsset *)asset completeNotify:(void(^)(UIImage *image,NSString *shortPath))notify
{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = NO;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        NSLog(@"progress = %f\ninfo = %@",progress,info);
//        NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithDouble: progress], @"progress",
//                              self, @"photo", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:MWPHOTO_PROGRESS_NOTIFICATION object:dict];
    };
    
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat scale = screen.scale;
    // Sizing is very rough... more thought required in a real implementation
    CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
    CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
    // 按指定尺寸生成图片
    PHImageRequestID id_num = [imageManager requestImageForAsset:asset targetSize:imageTargetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        NSString *url = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
        NSRange targetRang = [url rangeOfString:@"DCIM"];
        NSString *shortPath = @"/";
        if (targetRang.length > 0) {
            shortPath = [shortPath stringByAppendingString:[url substringWithRange:NSMakeRange(targetRang.location, url.length - targetRang.location)]];
        } else {
            shortPath = [shortPath stringByAppendingString:[url lastPathComponent]];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"resultHandler -> %@",info);
            notify ? notify(result,shortPath) : nil;
        });
    }];
    
    return id_num;
    
}

- (void)saveImageWithAsset:(PHAsset *)asset toSavePathDirectory:(NSString *)savePathDir completeNotify:(void(^)(BOOL saveResult,NSString *saveFullPath))notify
{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = NO;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        NSLog(@"progress = %f\ninfo = %@",progress,info);
    };
    
    [imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        NSString *url = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
        NSRange targetRang = [url rangeOfString:@"DCIM"];
        NSString *shortPath;
        if (targetRang.length > 0) {
            shortPath = [url substringWithRange:NSMakeRange(targetRang.location, url.length - targetRang.location)];
        } else {
            shortPath = [url lastPathComponent];
        }
        NSString *path = [savePathDir stringByAppendingPathComponent:shortPath];
        [[NSFileManager defaultManager] createDirectoryAtPath:[path stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:path contents:imageData attributes:nil];
        notify ? notify(result,path) : nil;
        
    }];
}

- (NSInteger)getShortPathWithAsset:(PHAsset *)asset completeNotify:(void(^)(NSString *shortPath))notify
{
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = NO;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        NSLog(@"progress = %f\ninfo = %@",progress,info);
    };
    
    // 按指定尺寸生成图片
    PHImageRequestID id_num = [imageManager requestImageForAsset:asset targetSize:CGSizeMake(1, 1) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        NSString *url = [[info objectForKey:@"PHImageFileURLKey"] absoluteString];
        NSRange targetRang = [url rangeOfString:@"DCIM"];
        NSString *shortPath = @"/";
        if (targetRang.length > 0) {
            shortPath = [shortPath stringByAppendingString:[url substringWithRange:NSMakeRange(targetRang.location, url.length - targetRang.location)]];
        } else {
            shortPath = [shortPath stringByAppendingString:[url lastPathComponent]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"resultHandler -> %@",info);
            notify ? notify(shortPath) : nil;
        });
    }];
    
    return id_num;
    
}

@end
