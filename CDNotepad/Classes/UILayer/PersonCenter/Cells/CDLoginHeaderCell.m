//
//  CDLoginHeaderCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/12.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDLoginHeaderCell.h"

@interface CDLoginHeaderCell ()
@property (nonatomic,strong) UIImageView *imageViewIcon;
//@property (nonatomic,)
@end


@implementation CDLoginHeaderCell

- (void)setup
{
    self.imageViewIcon.image = [UIImage imageNamed:@"iTunesArtwork"];
}


#pragma mark - Getter Method
- (UIImageView *)imageViewIcon
{
    if (_imageViewIcon == nil) {
        _imageViewIcon = [[UIImageView alloc] init];
        _imageViewIcon.image = [UIImage imageNamed:@"iTunesArtwork"];
        _imageViewIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.clipsToBounds = YES;
        [self addSubview:_imageViewIcon];
        [_imageViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
//            make.width.equalTo(@180.0);
            make.width.equalTo(_imageViewIcon.mas_height);
        }];
        
    }
    return _imageViewIcon;
}

@end
