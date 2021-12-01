//
//  KKGameTimeConvertModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameTimeConvertModel.h"

@implementation KKGameTimeConvertModel

/// 计算给定日期与当前日期差值
+ (NSTimeInterval)timeIntervalBetweenNowWithDateStr:(NSString * _Nullable)dateStr {
    
    NSDate *sourceDate = [self dateWithTimeStr:dateStr];
    if (!sourceDate) {
        return -1;
    }
    
    NSDate *nowLocalDate = [self localDateWithDate:[NSDate date]];
    NSTimeInterval interval = [sourceDate timeIntervalSinceDate:nowLocalDate];
    
    return ceil(interval);
}

+ (NSString * _Nonnull)timeWithTimeInteval:(NSTimeInterval)inteval {
    
    NSInteger seconds = (NSInteger)fabs(inteval);
    
    NSInteger hour = 3600;
    NSInteger minute = 60;
    
    NSString *str_hour = [NSString stringWithFormat:@"%02ld", seconds / hour];
    NSString *str_minute = [NSString stringWithFormat:@"%02ld", (seconds % hour) / minute];
    NSString *str_second = [NSString stringWithFormat:@"%02ld", seconds % minute];
    
    NSString *timeStr = nil;
    //timeStr = [NSString stringWithFormat:@"%@：%@：%@", str_hour, str_minute, str_second];;
    if (seconds < hour) {
        timeStr = [NSString stringWithFormat:@"%@:%@", str_minute, str_second];
    } else {
        timeStr = [NSString stringWithFormat:@"%@:%@:%@", str_hour, str_minute, str_second];
    }
    
    return timeStr;
}

/// 转换中国时间格式为日期
+ (NSDate * _Nullable)dateWithTimeStr:(NSString * _Nullable)timeStr {
    if (!timeStr) {
        return nil;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [format dateFromString:timeStr];
    NSDate *localDate = [self localDateWithDate:date];
    
    return localDate;
}

+ (NSDate * _Nonnull)localDateWithDate:(NSDate * _Nonnull)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    return localeDate;
}

@end
