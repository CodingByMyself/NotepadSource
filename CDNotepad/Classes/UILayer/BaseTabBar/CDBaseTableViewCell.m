//
//  CDBaseTableViewCell.m
//  CDNotepad
//
//  Created by Cindy on 2017/1/9.
//  Copyright © 2017年 Comtop. All rights reserved.
//

#import "CDBaseTableViewCell.h"

@implementation CDBaseTableViewCell

#pragma mark - Public init method
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
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier fromNibFileName:(NSString *)nibName onTableView:(UITableView *)tableView
{
    CDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        //  开始寻找指定的nib
        if (nibName) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
            for(id oneObject in nib) {
                if([oneObject isKindOfClass:[self class]]) { self = oneObject; break; }
            }
        }
        
        if (self == nil) {
            self = [super init];
        }
        
        if (identifier) {
            [self setRestorationIdentifier:identifier];
        }
        [self setup];
        return self;
        
    } else {
        return cell;
    }
}

/**
 *  公共基类的cell初始化方法，利用唯一标示在指定的tableView中得到指定的cell实例；
 *  如果没有 则新建一个cell实例；
 *
 *  @param identifier 对新创建的cell设置一个唯一标示，复用机制
 *  @param tableView  该cell所在的tableView
 *
 *  @return 返回一个该cell的实例对象
 */
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier onTableView:(UITableView *)tableView
{
    CDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        self = [super init];
        if (identifier) {
            [self setRestorationIdentifier:identifier];
        }
        [self setup];
        return self;
    } else {
        return cell;
    }
}

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
- (instancetype)initWithRestorationIdentifier:(NSString *)identifier onTableView:(UITableView *)tableView selectionStyle:(UITableViewCellSelectionStyle)style
{
    CDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        self = [super init];
        if (identifier) {
            [self setRestorationIdentifier:identifier];
        }
        self.selectionStyle = style;
        [self setup];
        return self;
    } else {
        return cell;
    }
}

- (void)setup
{
    //  空实现，子类可以重载该方法来自定义初始化代码 ,并且子类的重载方法中加上 [super setup];
}


@end
