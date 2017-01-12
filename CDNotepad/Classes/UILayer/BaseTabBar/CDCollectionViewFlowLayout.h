//
//  CDCollectionViewFlowLayout.h
//  MangoCityTravel
//
//  Created by Cindy on 16/6/22.
//  Copyright © 2016年 mangocity. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const UICollectionElementKindSectionHeaderID;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionFooterID;

@interface CDCollectionViewFlowLayout : UICollectionViewFlowLayout

/**
 *  是否支持悬浮，默认为NO不支持
 */
@property (nonatomic, assign) BOOL isSuspend;

@end
