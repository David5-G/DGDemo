//
//  KKCountDownTask.h
//  kk_espw
//
//  Created by hsd on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 任务类
@interface KKCountDownTask : NSOperation

/** 计时中回调 */
@property(nonatomic, copy, nullable) void(^countingDownBlock)(NSTimeInterval timeInterval);

/** 计时结束回调 */
@property(nonatomic, copy, nullable) void(^finishedBlock)(NSTimeInterval timeInterval);

/** 计时剩余时间 */
@property(nonatomic, assign) NSTimeInterval leftTimeInterval;

/** 后台任务标示,确保任务进入后台依然能够计时 */
@property(nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

/** `NSOperation`的`name`属性只在iOS8+中存在，这里定义一个属性，用来兼容 iOS7 */
@property(nonatomic, copy) NSString *operationName;

@end

NS_ASSUME_NONNULL_END
