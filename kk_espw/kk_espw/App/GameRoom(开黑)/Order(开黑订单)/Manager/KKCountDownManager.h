//
//  KKCountDownManager.h
//  kk_espw
//
//  Created by hsd on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^kkCountDownTimerBlock)(NSTimeInterval timerInterval);

/** 定时器管理类 */
@interface KKCountDownManager : NSObject

//本类拥有一个线程池（也叫并发操作队列，规定队列中最多只允许存在 20 个并发线程），每分配一个计时器（即创建一个子线程）就将其放入池中，计时器跑完以后会自动从池子里销毁。
/** 线程池 */
@property(nonatomic, strong, nonnull) NSOperationQueue *pool;

/** 单例对象 */
+ (instancetype)standard;


/**
 *  开始倒计时，如果倒计时管理器里具有相同的key，则直接开始回调。
 *
 *  @param name         任务名字，用于标示唯一性
 *  @param totalTimeInterval 倒计时总时间
 *  @param isCreate     不存在此计时器线程时,是否要创建
 *  @param countingDown 倒计时，会多次回调，提供当前秒数
 *  @param finished     倒计时结束时调用，提供当前秒数，值恒为 0
 */
- (void)scheduledCountDownWithName:(NSString * _Nullable)name
                         totalTime:(NSTimeInterval)totalTimeInterval
                            create:(BOOL)isCreate
                      countingDown:(kkCountDownTimerBlock _Nullable)countingDown
                          finished:(kkCountDownTimerBlock _Nullable)finished;

/** 删除线程池里面名字为 name 的定时器 */
- (void)removeTaskWithName:(NSString * _Nullable)name;

/// 删除线程池里一组线程
- (void)removeTasksWithNameArray:(NSArray<NSString *> * _Nullable)nameArray;

@end

NS_ASSUME_NONNULL_END
