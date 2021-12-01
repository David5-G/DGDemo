//
//  KKMyWalletInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface KKAccountInfo : NSObject
@property (nonatomic, strong) NSDecimalNumber *freezeAmount;
@property (nonatomic, strong) NSDecimalNumber *avaiableAmount;
@property (nonatomic, copy) NSString *accountNo;

@end

@interface KKMyWalletInfo : NSObject

@property (nonatomic, strong) KKAccountInfo *rewardAccountInfoClientSimple;
@property (nonatomic, strong) KKAccountInfo *accountInfoClientSimple;

@end

NS_ASSUME_NONNULL_END
