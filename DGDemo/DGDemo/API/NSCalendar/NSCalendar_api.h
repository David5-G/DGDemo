

#ifndef NSCalendar_api_h
#define NSCalendar_api_h

typedef NS_OPTIONS(NSUInteger, NSCalendarUnit) {
    NSCalendarUnitEra,               // 时代（不知道是什么，换成中国日历会变）
    NSCalendarUnitYear,              // 年
    NSCalendarUnitMonth,             // 月
    NSCalendarUnitDay,               // 日
    NSCalendarUnitHour,             // 小时
    NSCalendarUnitMinute,            // 分钟
    NSCalendarUnitSecond,            // 秒
    NSCalendarUnitWeekday,           // 星期（1为初始值，为周日）
    NSCalendarUnitWeekdayOrdinal,    // 日历单位工作日序数（应该是以每月第几周来算）
    NSCalendarUnitQuarter,           // 季度（总是为0）
    NSCalendarUnitWeekOfMonth,       // 本月第几周
    NSCalendarUnitWeekOfYear,        // 本年第几周
    NSCalendarUnitYearForWeekOfYear, // 周年（如果为中国，则为中国的历史时长：4652）
    NSCalendarUnitNanosecond,        // 纳秒
    NSCalendarUnitCalendar,          // 该日历对象
    NSCalendarUnitTimeZone ,         // 时区对象（可获取当前所在时区，大洲，城市）
};

// 日历选项 (iOS 7.0)
typedef NS_OPTIONS(NSUInteger, NSCalendarOptions) {
    NSCalendarWrapComponents,  // 日历组件
    NSCalendarMatchStrictly,   // 严格匹配的日历
    NSCalendarSearchBackwards, // 向后搜索
    NSCalendarMatchPreviousTimePreservingSmallerUnits,  // 上一个较小的单位
    NSCalendarMatchNextTimePreservingSmallerUnits,      // 下一个较小单位
    NSCalendarMatchNextTime,  // 下一个时间段
    NSCalendarMatchFirst,     // 日历匹配第一个
    NSCalendarMatchLast       // 日历匹配最后一个
};

#pragma mark - 常量参数
// iOS 4.0之后
NSString * const NSCalendarIdentifierGregorian;             // 公历
NSString * const NSCalendarIdentifierBuddhist;              // 佛教日历
NSString * const NSCalendarIdentifierChinese;               // 中国农历
NSString * const NSCalendarIdentifierCoptic;                // 亚历山大历
NSString * const NSCalendarIdentifierEthiopicAmeteMihret;   // 埃塞俄比亚日历（公元8世纪左右）
NSString * const NSCalendarIdentifierEthiopicAmeteAlem;    // 埃塞俄比亚日历（公元前5493前后）
NSString * const NSCalendarIdentifierHebrew;                // 希伯来日历
NSString * const NSCalendarIdentifierISO8601;               // 国际标准ISO 8601是[日期](http://baike.baidu.com/view/566414.htm)和时间的表示方法（目前不可用）
NSString * const NSCalendarIdentifierIndian;                // 印度日历
NSString * const NSCalendarIdentifierIslamic;               // 伊斯兰历
NSString * const NSCalendarIdentifierIslamicCivil;          // 伊斯兰教日历
NSString * const NSCalendarIdentifierJapanese;              // 日本日历(和历，常用)
NSString * const NSCalendarIdentifierPersian;               // 波斯日历
NSString * const NSCalendarIdentifierRepublicOfChina;       // 中华民国日历（台湾）
NSString * const NSCalendarIdentifierIslamicTabular;        // 伊斯兰历法表格，在公元622年7月15日星期四的天文时代使用
NSString * const NSCalendarIdentifierIslamicUmmAlQura;      // 沙特阿拉伯使用的伊斯兰乌姆Qura日历


@interface NSCalendar : NSObject <NSCopying, NSSecureCoding>

// 当前用户日历(基于设备的系统设置)
@property (class, readonly, copy) NSCalendar *currentCalendar;

// 当前用户日历(基于设备的系统设置) 系统设置变autoupdatingCurrentCalendar会自动更新
@property (class, readonly, strong) NSCalendar *autoupdatingCurrentCalendar;

// 通过标识符获取一个日历类型（常量参数）
+ (nullable NSCalendar *)calendarWithIdentifier:(NSCalendarIdentifier)calendarIdentifierConstant;

- (instancetype)init NS_UNAVAILABLE;

// 通过标识符获取一个日历类型（常量参数）
- (nullable id)initWithCalendarIdentifier:(NSCalendarIdentifier)ident;

// 日历标识字符串
@property (readonly, copy) NSCalendarIdentifier calendarIdentifier;

// 设置关于本地的一些信息
@property (nullable, copy) NSLocale *locale;

// 时区
@property (copy) NSTimeZone *timeZone;

// 设定每周的第一天从星期几开始，比如:
// 如设定从星期日开始，则value传入1；如需设定从星期一开始，则value传入2，以此类推。
@property NSUInteger firstWeekday;

// 设定作为(每年及每月)第一周必须包含的最少天数，比如:
// 如需设定第一周最少包括7天，则value传入7
@property NSUInteger minimumDaysInFirstWeek;



#pragma mark - 单位(根据local返回本地单位)
// 公元
@property (readonly, copy) NSArray<NSString *> *eraSymbols;    // 缩写
@property (readonly, copy) NSArray<NSString *> *longEraSymbols;// 全写

// 月份
@property (readonly, copy) NSArray<NSString *> *monthSymbols;         // 全写
@property (readonly, copy) NSArray<NSString *> *shortMonthSymbols;    // 缩写
@property (readonly, copy) NSArray<NSString *> *veryShortMonthSymbols;// 最短缩写
// 与上同
@property (readonly, copy) NSArray<NSString *> *standaloneMonthSymbols;
@property (readonly, copy) NSArray<NSString *> *shortStandaloneMonthSymbols;
@property (readonly, copy) NSArray<NSString *> *veryShortStandaloneMonthSymbols;

// 星期
@property (readonly, copy) NSArray<NSString *> *weekdaySymbols;          // 全写
@property (readonly, copy) NSArray<NSString *> *shortWeekdaySymbols;     // 缩写
@property (readonly, copy) NSArray<NSString *> *veryShortWeekdaySymbols; // 最短缩写
// 与上同
@property (readonly, copy) NSArray<NSString *> *standaloneWeekdaySymbols;
@property (readonly, copy) NSArray<NSString *> *shortStandaloneWeekdaySymbols;
@property (readonly, copy) NSArray<NSString *>
*veryShortStandaloneWeekdaySymbols;

// 季度
@property (readonly, copy) NSArray<NSString *> *quarterSymbols;       // 全写
@property (readonly, copy) NSArray<NSString *> *shortQuarterSymbols;  // 缩写

// 与上同
@property (readonly, copy) NSArray<NSString *> *standaloneQuarterSymbols;
@property (readonly, copy) NSArray<NSString *> *shortStandaloneQuarterSymbols;

// 时段（上、下午）
@property (readonly, copy) NSString *AMSymbol  NS_AVAILABLE(10_7, 5_0);
@property (readonly, copy) NSString *PMSymbol;



#pragma mark - 日历计算
// 获取指定NSCalendarUnit的最小范围
- (NSRange)minimumRangeOfUnit:(NSCalendarUnit)unit;

// 获取指定NSCalendarUnit的最大范围
- (NSRange)maximumRangeOfUnit:(NSCalendarUnit)unit;

// 通过date,获取smaller在larger中的最大范围。
// 比如small为日,larger为月份,那么date如果在2月则会获取到28或者29最大
- (NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;

// 通过date,获取smaller在larger中是第几位
// 比如small为星期,larger为年,那么会返回smaller在larger中是第几周
- (NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;

// 根据unit来计算date的开始时间,起始时间赋值给detep,秒数赋值给tip
// 如果datep和tip都是可算的,返回YES。
// 例如unit为星期,date为2016-1-16,那么他的起始时间应该是一周前,即2016-1-10
- (BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate * _Nullable * _Nullable)datep interval:(nullable NSTimeInterval *)tip forDate:(NSDate *)date;

// 通过NSDateComponents获取一个NSDate对象
- (nullable NSDate *)dateFromComponents:(NSDateComponents *)comps;

// 通过unitFlags从Date中获取指定值,赋给NSDateComponents并返回
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)date;

// 在date的基础上,增加comps的时间值. 即增加多少天或多少秒等...
- (nullable NSDate *)dateByAddingComponents:(NSDateComponents *)comps toDate:(NSDate *)date options:(NSCalendarOptions)opts;

// 根据unitFlags和opts计算方法.
// 计算resultDate和startingDate的时间差,获取指定的unitFlags值.
// 赋值给NSDateComponents并返回
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDate:(NSDate *)startingDate toDate:(NSDate *)resultDate options:(NSCalendarOptions)opts;

//------ API_AVAILABLE(macos(10.9), ios(8.0), watchos(2.0), tvos(9.0)) -----------
// 从date中获取指定的值赋给其他几个参数,参数要求指针赋值,如果不需要则赋为nil
// 包括公元、年份、月份、日
- (void)getEra:(out nullable NSInteger *)eraValuePointer year:(out nullable NSInteger *)yearValuePointer month:(out nullable NSInteger *)monthValuePointer day:(out nullable NSInteger *)dayValuePointer fromDate:(NSDate *)date;


// 从date中获取指定的值赋给其他几个参数,参数要求指针赋值,如果不需要则赋为nil
// 包括公元、周年、本年第几周、周几
- (void)getEra:(out nullable NSInteger *)eraValuePointer yearForWeekOfYear:(out nullable NSInteger *)yearValuePointer weekOfYear:(out nullable NSInteger *)weekValuePointer weekday:(out nullable NSInteger *)weekdayValuePointer fromDate:(NSDate *)date;


// 从date中获取指定的值赋给其他几个参数,参数要求指针赋值,如果不需要则赋为nil
// 包括时、分、秒、纳秒
- (void)getHour:(out nullable NSInteger *)hourValuePointer minute:(out nullable NSInteger *)minuteValuePointer second:(out nullable NSInteger *)secondValuePointer nanosecond:(out nullable NSInteger *)nanosecondValuePointer fromDate:(NSDate *)date;


// 根据unit从date获取某个值
- (NSInteger)component:(NSCalendarUnit)unit fromDate:(NSDate *)date;


// 通过设置相应的值获取一个NSDate对象
// 年、月、日、时、分、秒、纳秒
- (nullable NSDate *)dateWithEra:(NSInteger)eraValue year:(NSInteger)yearValue month:(NSInteger)monthValue day:(NSInteger)dayValue hour:(NSInteger)hourValue minute:(NSInteger)minuteValue second:(NSInteger)secondValue nanosecond:(NSInteger)nanosecondValue;


// 通过设置相应的值获取一个NSDate对象
// 公元、周年、本年第几周、周几、时、分、秒、纳秒
- (nullable NSDate *)dateWithEra:(NSInteger)eraValue yearForWeekOfYear:(NSInteger)yearValue weekOfYear:(NSInteger)weekValue weekday:(NSInteger)weekdayValue hour:(NSInteger)hourValue minute:(NSInteger)minuteValue second:(NSInteger)secondValue nanosecond:(NSInteger)nanosecondValue;

// 返回date在当天的起始时间
- (NSDate *)startOfDayForDate:(NSDate *)date;

// 根据时区和给定的时间返回一个NSDateComponents
- (NSDateComponents *)componentsInTimeZone:(NSTimeZone *)timezone fromDate:(NSDate *)date;

#pragma mark - 比较日期
//根据指定unit比较两个日期的大小, 忽略smaller unit
//用月份,比较两个日期, 日,时,分,秒,纳秒就会被忽略
- (NSComparisonResult)compareDate:(NSDate *)date1 toDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

//根据指定unit比较两个日期是否相同, 忽略smaller unit
- (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

//比较date1和date2是否是同一天
- (BOOL)isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;

//date是否是 今天
- (BOOL)isDateInToday:(NSDate *)date;

//date是否是 昨天
- (BOOL)isDateInYesterday:(NSDate *)date;

//date是否是 今天
- (BOOL)isDateInTomorrow:(NSDate *)date;

//date是否是 周末(周六周日)
- (BOOL)isDateInWeekend:(NSDate *)date;

//判断date是否在周末,
//返回值为YES, 地址传递返回值:  datep:周末的开始时间  tip:周末的持续时长
//返回值为NO, datep和tip无值
- (BOOL)rangeOfWeekendStartDate:(out NSDate * _Nullable * _Nullable)datep interval:(out nullable NSTimeInterval *)tip containingDate:(NSDate *)date;

//根据 afterDate返回,下周的周末开始时间datep,和持续时长tip
//options如果是NSCalendarSearchBackwards,则为date上个的周末
- (BOOL)nextWeekendStartDate:(out NSDate * _Nullable * _Nullable)datep interval:(out nullable NSTimeInterval *)tip options:(NSCalendarOptions)options afterDate:(NSDate *)date;


// 通过计算startngDateComp与resultDateComp的日期距离,获取指定的unitFlags的值赋值给新的NSDateComponents并返回
- (NSDateComponents *)components:(NSCalendarUnit)unitFlags fromDateComponents:(NSDateComponents *)startingDateComp toDateComponents:(NSDateComponents *)resultDateComp options:(NSCalendarOptions)options;

//如果超出receiver定义的范围,或者如果计算不能被执行 return nil
//NSCalendarWrapComponents模式,会让unit增加,且溢出时候按0/1进位,且不会让higher units增加
- (nullable NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value toDate:(NSDate *)date options:(NSCalendarOptions)options;



- (void)enumerateDatesStartingAfterDate:(NSDate *)start matchingComponents:(NSDateComponents *)comps options:(NSCalendarOptions)opts usingBlock:(void (NS_NOESCAPE ^)(NSDate * _Nullable date, BOOL exactMatch, BOOL *stop))block;

//计算出下一个符合components的date
- (nullable NSDate *)nextDateAfterDate:(NSDate *)date matchingComponents:(NSDateComponents *)comps options:(NSCalendarOptions)options;

//计算出下一个符合指定unit的date
- (nullable NSDate *)nextDateAfterDate:(NSDate *)date matchingUnit:(NSCalendarUnit)unit value:(NSInteger)value options:(NSCalendarOptions)options;

//计算出下一个符合指定时分秒的date
- (nullable NSDate *)nextDateAfterDate:(NSDate *)date matchingHour:(NSInteger)hourValue minute:(NSInteger)minuteValue second:(NSInteger)secondValue options:(NSCalendarOptions)options;

//指定date的unit值, 获取新的date, 可能会让higher unit改变,
- (nullable NSDate *)dateBySettingUnit:(NSCalendarUnit)unit value:(NSInteger)v ofDate:(NSDate *)date options:(NSCalendarOptions)opts;

//指定date的时,分,秒对应的值, 获取新的date
- (nullable NSDate *)dateBySettingHour:(NSInteger)h minute:(NSInteger)m second:(NSInteger)s ofDate:(NSDate *)date options:(NSCalendarOptions)opts;

//date是否匹配components
//常用语enumerateDatesStartingAfterDate:matchingComponents:options:usingBlock中date的判断
- (BOOL)date:(NSDate *)date matchesComponents:(NSDateComponents *)components;

//------ API_AVAILABLE(macos(10.9), ios(8.0), watchos(2.0), tvos(9.0)) -----------




@end


#endif
