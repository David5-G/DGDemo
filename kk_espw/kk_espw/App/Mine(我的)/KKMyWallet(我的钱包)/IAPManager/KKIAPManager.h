//
//  KKIAPManager.h
//  kk_espw
//
//  Created by 景天 on 2019/7/30.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    KKIAPPurchSuccess = 0,       // 购买成功
    KKIAPPurchFailed = 1,        // 购买失败
    KKIAPPurchCancle = 2,        // 取消购买
    KKIAPPurchVerFailed = 3,     // 订单校验失败
    KKIAPPurchVerSuccess = 4,    // 订单校验成功
    KKIAPPurchNotArrow = 5,      // 不允许内购
} KKIAPPurchType;

typedef void(^KKIAPCompletionHandle)(KKIAPPurchType type, NSDate *data);

@interface KKIAPManager : NSObject
+ (instancetype)shareInstance;
/**
 开始交易

 @param purchID ID
 @param handle 成功
 */
- (void)startPurchWithID:(NSString *)purchID completeHandle:(KKIAPCompletionHandle)handle;
@end

NS_ASSUME_NONNULL_END
