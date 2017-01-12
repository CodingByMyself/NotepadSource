//
//  CDBaseTableViewCell.h
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//


#ifndef CDBaseTableViewCell_h
#define CDBaseTableViewCell_h

#import <UIKit/UIKit.h>

@interface CDBaseTableViewCell : UITableViewCell

/**
 *  公共基类的cell初始化方法，利用唯一标示在指定的tableView中得到指定的cell实例；
 *  如果没有，则新建一个cell实例，并从一个指定的nib文件中加载视图；
 *
 *  @param identifier  对新创建的cell设置一个唯一标示，复用机制
 *  @param nibName  指定的nib文件名
 *  @param tableView  cell所在的tableView
 *
 *  @return 返回一个该cell的实例对象
 */
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier fromNibFileName:(NSString *)nibName onTableView:(UITableView *)tableView;


/**
 *  公共基类的cell初始化方法，利用唯一标示在指定的tableView中得到指定的cell实例；
 *  如果没有 则新建一个cell实例；
 *
 *  @param identifier 对新创建的cell设置一个唯一标示，复用机制
 *  @param tableView  该cell所在的tableView
 *
 *  @return 返回一个该cell的实例对象
 */
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier onTableView:(UITableView *)tableView;

/**
 *  公共基类的cell初始化方法，利用唯一标示在指定的tableView中得到指定的cell实例；
 *  如果没有 则新建一个cell实例；
 *
 *  @param identifier 对新创建的cell设置一个唯一标示，复用机制
 *  @param tableView  该cell所在的tableView
 *  @param style      cell的选中效果
 *
 *  @return 返回一个该cell的实例对象
 */
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier onTableView:(UITableView *)tableView selectionStyle:(UITableViewCellSelectionStyle)style;


/**
 *  初始化方法 （空实现，子类可以重载该方法来自定义初始化代码）
 */
- (void)setup;

@end


#endif /* CDBaseTableViewCell_h */


