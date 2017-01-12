//
//  CDDateHelper.h
//  CDFunctionTestProject
//
//  Created by Cindy on 16/8/4.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#ifndef CDDateHelper_h
#define CDDateHelper_h

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger,CDCalendarWeekdays) {
    CDCalendarWeekdayAtSun = 0,   // 周日
    CDCalendarWeekdayAtMon,   // 周一
    CDCalendarWeekdayAtTue,  // 周二
    CDCalendarWeekdayAtWed,  // 周三
    CDCalendarWeekdayAtThu,  // 周四
    CDCalendarWeekdayAtFri, // 周五
    CDCalendarWeekdayAtSat  // 周六
};



@interface CDDateHelper : NSObject

+ (NSCalendar *)calendar;
+ (NSDateFormatter *)createDateFormatter;

+ (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months;
+ (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks;
+ (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days;
+ (NSDate *)addToDate:(NSDate *)date hours:(NSInteger)hours;

// Must be less or equal to 6
/**
 *  返回两个日期之间间隔的天数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return  间隔的总天数
 */
+ (NSInteger)numberBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
+ (NSUInteger)numberOfWeeks:(NSDate *)date;

+ (NSInteger)monthOfDate:(NSDate *)date;
+ (NSInteger)yearOfDate:(NSDate *)date;

+ (NSDate *)firstDayOfMonth:(NSDate *)date;
+ (NSDate *)lastDayOfMonth:(NSDate *)date;
+ (NSDate *)firstWeekDayOfMonth:(NSDate *)date;
+ (NSDate *)firstWeekDayOfWeek:(NSDate *)date;

/**
 *  创建一个指定的日期对象
 *
 *  @param year       年份
 *  @param month      月份
 *  @param day        天
 *  @param hour       时
 *  @param minute     分
 *  @param second     秒
 *  @param nanosecond 毫秒
 *
 *  @return 日期对象
 */
//+ (NSDate *)dateByYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second nanosecond:(NSInteger)nanosecond;

#pragma mark - 返回中国常见的节假日
+ (NSString *)holidayStringForDate:(NSDate *)date;

+ (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB;

+ (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB;
+ (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate;

#pragma mark  show
+ (NSDate *)today;

/**
 *  按照指定的format格式转换一个日期，返回转换后的字符串
 *
 *  @param date   需要转换的日期
 *  @param format 转换格式
 *
 *  @return 转换后的字符串
 */
+ (NSString *)date:(NSDate *)date toStringByFormat:(NSString *)format;


/**
 *  按照指定的format格式转换一个字符串，返回转换后的日期
 *
 *  @param dateText   需要转换的日期
 *  @param format 转换格式 yyyy-MM-dd HH:mm:ss
 *
 *  @return 转换后的字符串
 */
+(NSDate *)dateFromString:(NSString *)dateText byFormat:(NSString *)format;

/**
 *  获取某个日期是星期几
 *
 *  @param date 日期实例
 *
 *  @return 星期值
 */
+ (NSString *)getWeekdayStringWithDate:(NSDate *)date;
+ (CDCalendarWeekdays)getWeekdayWithDate:(NSDate *)date;

/**
 *  按照指定的formatters分割一个日期；
 *  如：date是2016年8月23日，formatters是@[@"yyyy",@"MM",@"dd"]，则返回@[@"2016",@"08",@"23"];
 *
 *  @param date     需要分割的日期对象1
 *  @param formaters 分割的格式
 *
 *  @return 分割后的结果数组
 */
+ (NSArray *)dateSeparator:(NSDate *)date withSeparatorFormatterArray:(NSArray <NSString *>*)formaters;


@end

#endif /* CDDateHelper_h */
