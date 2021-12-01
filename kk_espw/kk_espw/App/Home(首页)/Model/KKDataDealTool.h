//
//  KKDataDealTool.h
//  kk_espw
//
//  Created by 景天 on 2019/7/31.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDataDealTool : NSObject


/**
 返回段位英文

 @param ChineseStr 中文
 @return 英文
 */
+ (NSString *)returnDangradingEngWithChineseStr:(NSString *)ChineseStr;


/**
 返回区英文
 
 @param ChineseStr 中文
 @return 英文
 */
+ (NSString *)returnPlatformTypeEngWithChineseStr:(NSString *)ChineseStr;


/**
 订单状态

 @param englishStr 英文
 @return 中文
 */
+ (NSString *)returnChineseStrWithEnglisgStr:(NSString *)englishStr;


/**
 返回大神等级

 @param vStr 服务器数据
 @return 本地图片字符串
 */
+ (NSString *)returnImageStr:(NSString *)vStr;
@end

NS_ASSUME_NONNULL_END
