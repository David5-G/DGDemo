//
//  KKRechargeInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface KKChannels : NSObject
@property (nonatomic, copy) NSString *ID;
@end

@interface KKUserBaseInfo : NSObject
@property (nonatomic, copy) NSString *freezeAmount;
@property (nonatomic, copy) NSString *avaiableAmount;

@end

@interface KKRechargeInfo : NSObject
@property (nonatomic, strong) NSArray *priceList;
@property (nonatomic, strong) KKUserBaseInfo *userBaseInfo;
@property (nonatomic, copy) NSString *maxChargeFee;
@property (nonatomic, copy) NSString *logoUrl;
@property (nonatomic, copy) NSString *maxAllowAmount;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *minAllowAmount;
@property (nonatomic, copy) NSString *iosExchangeRate;
@property (nonatomic, strong) NSArray *fundChannels;
@end

NS_ASSUME_NONNULL_END
