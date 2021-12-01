//
//  KKDataDealTool.m
//  kk_espw
//
//  Created by 景天 on 2019/7/31.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKDataDealTool.h"

@implementation KKDataDealTool
+ (NSString *)returnDangradingEngWithChineseStr:(NSString *)ChineseStr {
    NSString *rank;
    if ([ChineseStr isEqualToString:@"王者"]) {
        rank = @"KING";
    }else if ([ChineseStr isEqualToString:@"星耀"]) {
        rank = @"STARSHINE";
    }else if ([ChineseStr isEqualToString:@"钻石"]) {
        rank = @"DIAMOND";
    }else if ([ChineseStr isEqualToString:@"铂金"]) {
        rank = @"PLATINUM";
    }else if ([ChineseStr isEqualToString:@"黄金"]) {
        rank = @"GOLD";
    }else if ([ChineseStr isEqualToString:@"白银"]) {
        rank = @"SILVER";
    }else if ([ChineseStr isEqualToString:@"青铜"]) {
        rank = @"BRONZE";
    }else if ([ChineseStr isEqualToString:@"荣耀"]) {
        rank = @"GLORY";
    }
    return rank;
}

+ (NSString *)returnPlatformTypeEngWithChineseStr:(NSString *)chineseStr{
    NSString *platformType;
    if ([chineseStr isEqualToString:@"微信"]) {
        platformType = @"WE_CHART";
    }else {
        platformType = @"QQ";
    }
    return platformType;
}

+ (NSString *)returnChineseStrWithEnglisgStr:(NSString *)englishStr {
    /*
     INIT => 待支付
     RECRUIT => 招募中
     PROCESSING => 比赛中
     EVALUATE => 待评价
     FINISH => 已完成
     CANCEL => 关闭
     FAIL_SOLD => 流局
     */
    NSString *chineseStr;
    if ([englishStr isEqualToString:@"INIT"]) {
        chineseStr = @"待支付";
    }else if ([englishStr isEqualToString:@"RECRUIT"]){
        chineseStr = @"招募中";
    }else if ([englishStr isEqualToString:@"PROCESSING"]){
        chineseStr = @"比赛中";
    }else if ([englishStr isEqualToString:@"EVALUATE"]){
        chineseStr = @"待评价";
    }else if ([englishStr isEqualToString:@"FINISH"]){
        chineseStr = @"已完成";
    }else if ([englishStr isEqualToString:@"CANCEL"]){
        chineseStr = @"关闭";
    }else if ([englishStr isEqualToString:@"FAIL_SOLD"]){
        chineseStr = @"流局";
    }
    return chineseStr;
}

+ (NSString *)returnImageStr:(NSString *)vStr {
    NSString *imageStr;
    if ([vStr isEqualToString:@"GOD_V1"]) {
        imageStr = @"manito_v1";
    }else if ([vStr isEqualToString:@"GOD_V2"]) {
        imageStr = @"manito_v2";
    }else if ([vStr isEqualToString:@"GOD_V3"]) {
        imageStr = @"manito_v3";
    }else if ([vStr isEqualToString:@"GOD_V4"]) {
        imageStr = @"manito_v4";
    }else if ([vStr isEqualToString:@"GOD_V5"]) {
        imageStr = @"manito_v5";
    }else if ([vStr isEqualToString:@"GODDESS_V1"]) {
        imageStr = @"goddess_v1";
    }else if ([vStr isEqualToString:@"GODDESS_V2"]) {
        imageStr = @"goddess_v2";
    }else if ([vStr isEqualToString:@"GODDESS_V3"]) {
        imageStr = @"goddess_v3";
    }else if ([vStr isEqualToString:@"GODDESS_V4"]) {
        imageStr = @"goddess_v4";
    }else if ([vStr isEqualToString:@"GODDESS_V5"]) {
        imageStr = @"goddess_v5";
    }
    return imageStr;
}
@end
