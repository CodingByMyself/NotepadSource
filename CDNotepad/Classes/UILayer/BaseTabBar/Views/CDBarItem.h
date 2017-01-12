//
//  CDBarItem.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/7.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDBarItem : UIButton

- (void)itemTitle:(NSString*)title withSelectedImageName:(NSString*)selectedName andDeselectedImageName:(NSString*)deselectedName;

@end
