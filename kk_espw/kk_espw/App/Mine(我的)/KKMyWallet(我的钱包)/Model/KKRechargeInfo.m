//
//  KKRechargeInfo.m
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKRechargeInfo.h"

@implementation KKChannels

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

@end

@implementation KKUserBaseInfo

@end

@implementation KKRechargeInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"fundChannels" : @"KKChannels"
             };
}
@end
