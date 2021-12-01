//
//  KKCapitalFreeze.h
//  kk_espw
//
//  Created by 景天 on 2019/8/7.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCapitalFreeze : NSObject
/*
 "unfreezeAmount" : 60,
 "beginFreezeAmount" : 60,
 "memo" : "消费",
 "gmtCreate" : "2019-07-26 18:09:21",
 "freezeAmount" : 0
 */
@property (nonatomic, copy) NSString *freezeAmount;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSString *beginFreezeAmount;
@property (nonatomic, copy) NSString *unfreezeAmount;

@end

NS_ASSUME_NONNULL_END
