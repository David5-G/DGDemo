//
//  KKCardTag.m
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCardTag.h"

@implementation KKCardTag
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"evaluationProfileIds" : @"KKTag",
             @"preferLocations" : @"KKMessage"
             };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id",
             };
}
@end
