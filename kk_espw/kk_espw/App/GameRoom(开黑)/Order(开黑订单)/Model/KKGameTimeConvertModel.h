//
//  KKGameTimeConvertModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 日期转换
@interface KKGameTimeConvertModel : NSObject

/// 计算给定日期与当前日期差值
+ (NSTimeInterval)timeIntervalBetweenNowWithDateStr:(NSString * _Nullable)dateStr;

/// 时间戳转为时间字符串
+ (NSString * _Nonnull)timeWithTimeInteval:(NSTimeInterval)inteval;

@end

NS_ASSUME_NONNULL_END
