//
//  KKRestrictionInput.m
//  kk_espw
//
//  Created by 景天 on 2019/8/3.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKRestrictionInput.h"

@implementation KKRestrictionInput
///字母、数字、中文正则判断（不包括空格）
+ (BOOL)isInputRuleNotBlank:(NSString *)str {
    NSString *pattern = @"[A-Za-z0-9\u4e00-\u9fa5]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch) {
        [CC_Notice show:@"请输入中英文，或数字"];
    }
    return isMatch;
}


@end
