

#ifndef NSDateComponents_api_h
#define NSDateComponents_api_h

//可以把NSDateComponents当成一个结构体使用


FOUNDATION_EXPORT NSNotificationName const NSCalendarDayChangedNotification;

NS_ENUM(NSInteger) {
    NSDateComponentUndefined = NSIntegerMax,
};

@interface NSDateComponents : NSObject <NSCopying, NSSecureCoding>
@property (nullable, copy) NSCalendar *calendar;     // 日历
@property (nullable, copy) NSTimeZone *timeZone;     // 时区
@property NSInteger era;     // 公元
@property NSInteger year;    // 年
@property NSInteger month;   // 月
@property NSInteger day;     // 日
@property NSInteger hour;    // 时
@property NSInteger minute;  // 分
@property NSInteger second;  // 秒
@property NSInteger nanosecond; // 纳秒
@property NSInteger weekday;    // 星期几
@property NSInteger weekdayOrdinal;// 星期序数
@property NSInteger quarter;       // 季度
@property NSInteger weekOfMonth;   // 本月第几个星期
@property NSInteger weekOfYear;    // 本年第几个星期
@property NSInteger yearForWeekOfYear; // 周年
@property (getter=isLeapMonth) BOOL leapMonth; // 闰月
@property (nullable, readonly, copy) NSDate *date;  // 日期

// 设置指定NSCalendarUnit某个值
- (void)setValue:(NSInteger)value forComponent:(NSCalendarUnit)unit

// 获取指定NSCalendarUnit的值
- (NSInteger)valueForComponent:(NSCalendarUnit)unit

@property (getter=isValidDate, readonly) BOOL validDate; // 有效的日期

// 日历是否有效
- (BOOL)isValidDateInCalendar:(NSCalendar *)calendar;


#endif 
