//
//  KKCountDownManager.m
//  kk_espw
//
//  Created by hsd on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCountDownManager.h"
#import "KKCountDownTask.h"

@interface KKCountDownManager ()

@end

@implementation KKCountDownManager

/** 单例对象 */
+ (instancetype)standard {
    static KKCountDownManager *countDownDefault = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        countDownDefault = [[KKCountDownManager alloc] init];
        countDownDefault.pool = [[NSOperationQueue alloc] init];
    });
    return countDownDefault;
}

- (void)scheduledCountDownWithName:(NSString *)name totalTime:(NSTimeInterval)totalTimeInterval create:(BOOL)isCreate countingDown:(kkCountDownTimerBlock)countingDown finished:(kkCountDownTimerBlock)finished {
    
    if (_pool.operations.count > 20) { //最多20个并发线程
        return;
    }
    
    KKCountDownTask *task = nil;
    
    //查询该名字的任务是否存在
    for (KKCountDownTask *alsoTask in _pool.operations) {
        if ([alsoTask.operationName isEqualToString:name]) {
            task = alsoTask;
            break;
        }
    }
    //存在,继续跑定时器
    if (task != nil) {
        task.leftTimeInterval = totalTimeInterval;
        task.countingDownBlock = countingDown;
        task.finishedBlock = finished;
        if (countingDown) {
            countingDown(task.leftTimeInterval);
        }
        
    }else {//不存在,如果 允许创建(isCreate),则创建定时器线程,否则返回
        if (!isCreate) {
            return;
        }
        task = [[KKCountDownTask alloc] init];
        task.leftTimeInterval = totalTimeInterval;
        task.countingDownBlock = countingDown;
        task.finishedBlock = finished;
        task.operationName = name;
        
        [_pool addOperation:task];
    }
    
}

- (void)removeTaskWithName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return;
    }
    //查询该名字的任务是否存在
    for (KKCountDownTask *alsoTask in _pool.operations) {
        if ([alsoTask.operationName isEqualToString:name]) {
            [alsoTask cancel];
            return;
        }
    }
}

- (void)removeTasksWithNameArray:(NSArray<NSString *> *)nameArray {
    
    if (![nameArray isKindOfClass:[NSArray class]]) {
        return;
    }
    
    //查询该名字的任务是否存在
    for (KKCountDownTask *alsoTask in _pool.operations) {
        if (alsoTask.operationName && [nameArray containsObject:alsoTask.operationName]) {
            [alsoTask cancel];
        }
    }
}

@end
