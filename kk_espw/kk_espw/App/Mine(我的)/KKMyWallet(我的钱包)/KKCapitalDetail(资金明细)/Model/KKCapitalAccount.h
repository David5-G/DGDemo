//
//  KKCapitalAccount.h
//  kk_espw
//
//  Created by 景天 on 2019/8/7.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMessage;
NS_ASSUME_NONNULL_BEGIN

@interface KKCapitalAccount : NSObject
@property (nonatomic, copy) NSString *gmtTrans;
@property (nonatomic, strong) KKMessage *transDirection;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *transAmount;
@property (nonatomic, copy) NSString *balanceAfter;
@end

NS_ASSUME_NONNULL_END
