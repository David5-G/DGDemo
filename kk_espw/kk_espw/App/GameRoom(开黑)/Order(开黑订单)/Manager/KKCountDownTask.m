//
//  KKCountDownTask.m
//  kk_espw
//
//  Created by hsd on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCountDownTask.h"

@implementation KKCountDownTask

- (void)main { // main结束,一般就标志着这个队列该自动移除NSOperationQueue
    
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    while (--(self.leftTimeInterval) >= 0) {
        
        /// 取消定时器
        if (self.isCancelled) {
            self.countingDownBlock = nil;
            self.finishedBlock = nil;
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.countingDownBlock) {
                NSTimeInterval leftTime = self.leftTimeInterval >= 0 ? self.leftTimeInterval : 0;
                self.countingDownBlock(leftTime);
            }
        });
        
        //线程睡眠一秒钟
        if (self.leftTimeInterval > 0) {
            [NSThread sleepForTimeInterval:1.0];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.finishedBlock) {
            self.finishedBlock(0);
        }
    });
    
    if (self.taskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
