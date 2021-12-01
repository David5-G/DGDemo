//
//  KKOrderListInfo.m
//  kk_espw
//
//  Created by 景天 on 2019/7/29.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKOrderListInfo.h"

@implementation KKOrderListInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"userGameTagCountList" : @"KKTag"
             };
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    NSTimeInterval time = [self pleaseInsertStarTime:self.nowDate andInsertEndTime:self.gmtStopPay];
    
    NSTimeInterval timeGameEvaluateEnd = [self pleaseInsertStarTime:self.nowDate andInsertEndTime:self.gameEvaluateEnd];
    if (time < 0 || time == 0) {
        self.countNum = 0;
        
    }else {
        self.countNum = time;
    }
    
    if (timeGameEvaluateEnd < 0 || timeGameEvaluateEnd == 0) {
        self.gameEvaluateEndCountNum = 0;
        
    }else {
        self.gameEvaluateEndCountNum = timeGameEvaluateEnd;
    }
}

- (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [formater dateFromString:starTime];
    NSDate *endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

- (void)countDown {
    self.countNum -= 1;
}

- (void)gameEvaluateEndCountDown {
    self.gameEvaluateEndCountNum -= 1;
}

- (NSString*)currentTimeString {
    if (self.countNum <= 0) {
        return @"00:00:00";
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)self.countNum / 3600, (long)self.countNum % 3600 / 60, (long)self.countNum % 60];
    }
}

- (NSString*)currentGameEvaluateEndTimeString {
    if (self.gameEvaluateEndCountNum <= 0) {
        return @"00:00:00";
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)self.gameEvaluateEndCountNum / 3600, (long)self.gameEvaluateEndCountNum % 3600 / 60, (long)self.gameEvaluateEndCountNum % 60];
    }
}
@end
