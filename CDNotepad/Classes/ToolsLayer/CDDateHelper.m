//
//  CDDateHelper.m
//  CDFunctionTestProject
//
//  Created by Cindy on 16/8/4.
//  Copyright © 2016年 Cindy. All rights reserved.
//

#import "CDDateHelper.h"


@implementation CDDateHelper

+ (NSCalendar *)calendar
{
    static NSCalendar *_calendar;
    if(!_calendar){
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _calendar.timeZone = [NSTimeZone localTimeZone];
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    
    return _calendar;
}

+ (NSCalendar *)calendarChinese
{
    static NSCalendar *_calendarChinese;
    if(!_calendarChinese){
        _calendarChinese = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        _calendarChinese.timeZone = [NSTimeZone localTimeZone];
        _calendarChinese.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    }
    
    return _calendarChinese;
}

+ (NSArray *)lunarDayString
{
    static NSArray *_lunarDayString;
    if (_lunarDayString == nil) {
        _lunarDayString = [NSArray arrayWithObjects:@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                           @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                           @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    }
    return _lunarDayString;
}

+ (NSArray *)lunarMonthString
{
    static NSArray *_lunarMonthString;
    if (_lunarMonthString == nil) {
        _lunarMonthString = [NSArray arrayWithObjects:@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    }
    return _lunarMonthString;
}

+ (NSDateFormatter *)createDateFormatter
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.timeZone = self.calendar.timeZone;
    dateFormatter.locale = self.calendar.locale;
    
    return dateFormatter;
}

#pragma mark - Operations

+ (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *components = [NSDateComponents new];
    components.month = months;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

+ (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *components = [NSDateComponents new];
    components.day = 7 * weeks;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

+ (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *components = [NSDateComponents new];
    components.day = days;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

+ (NSDate *)addToDate:(NSDate *)date hours:(NSInteger)hours
{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateComponents *components = [NSDateComponents new];
    components.hour = hours;
    return [self.calendar dateByAddingComponents:components toDate:date options:0];
}

#pragma mark - Helpers
/**
 *  返回两个日期之间间隔的天数
 *
 *  @param startDate 开始日期
 *  @param endDate   结束日期
 *
 *  @return  间隔的总天数
 */
+ (NSInteger)numberBetweenStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:startDate toDate:endDate options:0];
    NSInteger days = components.year * 365 + components.month * 30 + components.weekOfMonth * 7 + components.day;
    return days;
}

+ (NSUInteger)numberOfWeeks:(NSDate *)date
{
    NSDate *firstDay = [self firstDayOfMonth:date];
    NSDate *lastDay = [self lastDayOfMonth:date];
    
    NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:firstDay];
    NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitWeekOfYear fromDate:lastDay];
    
    // weekOfYear may return 53 for the first week of the year
    return (componentsB.weekOfYear - componentsA.weekOfYear + 52 + 1) % 52;
}

#pragma mark 
//+ (NSInteger)dayOfDate:(NSDate *)date
//{
//    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
//    return components.year;
//}

+ (NSInteger)monthOfDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
    return components.month;
}

+ (NSInteger)yearOfDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear fromDate:date];
    return components.year;
}

#pragma mark
+ (NSDate *)firstDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = 1;
    componentsNewDate.day = 1;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

+ (NSDate *)lastDayOfMonth:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month + 1;
    componentsNewDate.day = 0;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

+ (NSDate *)firstWeekDayOfMonth:(NSDate *)date
{
    NSDate *firstDayOfMonth = [self firstDayOfMonth:date];
    return [self firstWeekDayOfWeek:firstDayOfMonth];
}

+ (NSDate *)firstWeekDayOfWeek:(NSDate *)date
{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekOfMonth = componentsCurrentDate.weekOfMonth;
    componentsNewDate.weekday = self.calendar.firstWeekday;
    
    return [self.calendar dateFromComponents:componentsNewDate];
}

#pragma mark - 农历转换函数
/**
 *  返回农历的日期描述文本
 *
 *  @param date 日期
 *
 *  @return 日期的农历描述
 */
+ (NSString *)lunarDayForDate:(NSDate*)date
{
    NSInteger day = [[CDDateHelper calendarChinese] components:NSCalendarUnitDay fromDate:date].day;
    
    NSString* dayStr = [self lunarDayString][day-1];
    NSInteger month = [[CDDateHelper calendarChinese] components:NSCalendarUnitMonth fromDate:date].month;
    NSString* monthStr=[self lunarMonthString][month-1];
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",monthStr,dayStr];
    
    return lunarDate;
}

+ (NSString *)holidayStringForDate:(NSDate *)date
{
    if ([date isKindOfClass:[NSDate class]] == NO) {
        return nil;
    }
    
    NSString *solarYear = [self lunarDayForDate:date];
    NSString *holidayString;
    NSArray *solarYear_arr= [solarYear componentsSeparatedByString:@"-"];
    
    if([solarYear_arr[0]isEqualToString:@"正"] &&
       [solarYear_arr[1]isEqualToString:@"初一"]){
        
        //正月初一：春节
        holidayString = @"春节";
        
    }else if([solarYear_arr[0]isEqualToString:@"正"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        //正月十五：元宵节
        holidayString = @"元宵";
        
    }else if([solarYear_arr[0]isEqualToString:@"五"] &&
             [solarYear_arr[1]isEqualToString:@"初五"]){
        //五月初五：端午节
        holidayString = @"端午";
        
    }else if([solarYear_arr[0]isEqualToString:@"七"] &&
             [solarYear_arr[1]isEqualToString:@"初七"]){
        //七月初七：七夕情人节
        holidayString = @"七夕";
        
    }else if([solarYear_arr[0]isEqualToString:@"八"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        //八月十五：中秋节
        holidayString = @"中秋";
        
    }else if([solarYear_arr[0]isEqualToString:@"九"] &&
             [solarYear_arr[1]isEqualToString:@"初九"]){
        //九月初九：重阳节、中国老年节（义务助老活动日）
        holidayString = @"重阳";
        
    }else if([solarYear_arr[0]isEqualToString:@"十一"] &&
             [solarYear_arr[1]isEqualToString:@"廿三"]){
        //十一月二十三：冬至
        holidayString = @"冬至";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"初八"]){
        //腊月初八：腊八节
        holidayString = @"腊八";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"廿四"]){
        //腊月二十四 小年
        holidayString = @"小年";
        
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"三十"]){
        //腊月三十（小月二十九）：除夕
        holidayString = @"除夕";
        
    }
    
    
    NSString* commonHoliday=[self commonHoliday:date];
    if(commonHoliday != nil){
        holidayString = commonHoliday;
    }
    
    return holidayString;
}

+ (NSString*)commonHoliday:(NSDate *)date
{
    NSDateComponents *calendarDay = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    if (calendarDay.month == 1 && calendarDay.day == 1){
        return @"元旦";
    }else if (calendarDay.month == 2 && calendarDay.day == 14){
        return @"情人";
    }else if (calendarDay.month == 3 && calendarDay.day == 8){
        return @"妇女";
    } else if (calendarDay.month == 4 && calendarDay.day == 4){
//        规律是，，闰年的  清明节是阳历  4月4号，闰年的下一年也是 阳历4月4号，其他每年都是 阳历4月5号，，
        if (calendarDay.year%4 == 0 || (calendarDay.year-1)%4 == 0) {
            return @"清明";
        } else {
            return nil;
        }
        //4.4清明节
    } else if (calendarDay.month == 4 && calendarDay.day == 5){
        //        规律是，，闰年的  清明节是阳历  4月4号，闰年的下一年也是 阳历4月4号，其他每年都是 阳历4月5号，，
        if ((calendarDay.year%4 == 0 || (calendarDay.year-1)%4 == 0) == NO) {
            return @"清明";
        } else {
            return nil;
        }
    }else if (calendarDay.month == 5 && calendarDay.day == 1){
        return @"劳动";
    }else if (calendarDay.month == 6 && calendarDay.day == 1){
        return @"儿童";
    }else if (calendarDay.month == 7 && calendarDay.day == 1){
        return @"建党";
    }else if (calendarDay.month == 8 && calendarDay.day == 1){
        return @"建军";
    } else if  (calendarDay.month == 9 && calendarDay.day == 10){
        return @"教师";
    } else if  (calendarDay.month == 10 && calendarDay.day == 1){
        return @"国庆";
    } else if (calendarDay.month == 11 && calendarDay.day == 11){
        return @"光棍";
    } else if (calendarDay.month == 12 && calendarDay.day == 25) {
        return @"圣诞";
    }
    return nil;
}

#pragma mark - Comparaison

+ (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB
{
    if ([dateA isKindOfClass:[NSDate class]] && [dateB isKindOfClass:[NSDate class]]) {
        NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateA];
        NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:dateB];
        
        return componentsA.year == componentsB.year && componentsA.month == componentsB.month;
    } else {
        return NO;
    }
}

+ (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB
{
    if ([dateA isKindOfClass:[NSDate class]] && [dateB isKindOfClass:[NSDate class]]) {
        NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateA];
        NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitWeekOfYear fromDate:dateB];
        
        return componentsA.year == componentsB.year && componentsA.weekOfYear == componentsB.weekOfYear;
    } else {
        return NO;
    }
}

+ (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB
{
    if ([dateA isKindOfClass:[NSDate class]] && [dateB isKindOfClass:[NSDate class]]) {
        NSDateComponents *componentsA = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateA];
        NSDateComponents *componentsB = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:dateB];
        
        return componentsA.year == componentsB.year && componentsA.month == componentsB.month && componentsA.day == componentsB.day;
    } else {
        return NO;
    }
}

+ (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedAscending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

+ (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB
{
    if([dateA compare:dateB] == NSOrderedDescending || [self date:dateA isTheSameDayThan:dateB]){
        return YES;
    }
    
    return NO;
}

+ (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate
{
    //    if([self date:date isEqualOrAfter:startDate] && [self date:date isEqualOrBefore:endDate]){
    //        return YES;
    //    }
    //
    //    return NO;
    
#pragma mark   Modify
    if (date == nil) {
        return NO;
    }
    
    BOOL  isAfter;
    if (startDate == nil) {
        isAfter = YES;
    } else {
        isAfter = [self date:date isEqualOrAfter:startDate];
    }
    
    BOOL  isEnd;
    if (endDate == nil) {
        isEnd = YES;
    } else {
        isEnd = [self date:date isEqualOrBefore:endDate];
    }
    
    //  最终结果
    if(isAfter && isEnd){
        return YES;
    } else {
        return NO;
    }
}

#pragma mark  show
+ (NSDate *)today
{
    return [NSDate date];
}

/**
 *  按照指定的format格式转换一个日期，返回转换后的字符串
 *
 *  @param date   需要转换的日期
 *  @param format 转换格式
 *
 *  @return 转换后的字符串
 */
+ (NSString *)date:(NSDate *)date toStringByFormat:(NSString *)format
{
    static NSDateFormatter *dateFormatter = nil;
    if(!dateFormatter){
        dateFormatter = [self createDateFormatter];
    }
    //  eg : format = @"MMMM yyyy" ;  format = @"dd"  ;
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

/**
 *  按照指定的format格式转换一个字符串，返回转换后的日期
 *
 *  @param dateText   需要转换的日期
 *  @param format 转换格式 yyyy-MM-dd HH:mm:ss
 *
 *  @return 转换后的字符串
 */

+(NSDate *)dateFromString:(NSString *)dateText byFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:dateText];
    return date;
}

/**
 *  获取某个日期是星期几
 *
 *  @param date 日期实例
 *
 *  @return 星期值
 */
+ (NSString *)getWeekdayStringWithDate:(NSDate *)date
{
    NSArray *weekdays = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday fromDate:date];
    if (components.weekday-1 < [weekdays count]) {
        return weekdays[components.weekday-1];
    } else {
        return @"";
    }
}

+ (CDCalendarWeekdays)getWeekdayWithDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday fromDate:date];
    return components.weekday-1;
}

/**
 *  按照指定的formatters分割一个日期；
 *  如：date是2016年8月23日，formatters是@[@"yyyy",@"MM",@"dd"]，则返回@[@"2016",@"08",@"23"];
 *
 *  @param date     需要分割的日期对象1
 *  @param formaters 分割的格式
 *
 *  @return 分割后的结果数组
 */
+ (NSArray *)dateSeparator:(NSDate *)date withSeparatorFormatterArray:(NSArray <NSString *>*)formaters
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < [formaters count] ; i ++) {
        [temp addObject:[self date:date toStringByFormat:formaters[i]]];
    }
    return [NSArray arrayWithArray:temp];
}


@end
