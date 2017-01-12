//
//  CDButton.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,CDButtonStyles) {
    CDButtonStyleIsDfault = 0,  //  默认相当于UIButton
    CDButtonStyleIsOnlyIcon,  //  仅图标
    CDButtonStyleIsOnlyTitle,  //  仅标题
    CDButtonStyleIsTopIconAndBottomTitle,  //  上面图标和下面标题
//    CDButtonStyleIsBottomIconAndTopTitle,  //  下面图标和上面标题
    CDButtonStyleIsLeftIconAndRightTitle,  //  左边图标和右边标题
    CDButtonStyleIsRightIconAndLeftTitle,  //  右边图标和左边标题
};


@interface CDButton : UIButton

@property (nonatomic,strong,readonly) UILabel *labelButtonTitle;
@property (nonatomic,strong,readonly) UIImageView *imageViewButtonIcon;
@property (nonatomic,assign,readonly) CDButtonStyles buttonStyle;

@property (nonatomic,assign) CGSize iconSize;



- (instancetype)initWithStyle:(CDButtonStyles)buttonStyle;



@end
