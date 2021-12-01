//
//  KKMyWalletService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMyWalletInfo;
@class KKRechargeInfo;

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestMyWalletAccountBlockSuccess)(KKMyWalletInfo *walletInfo);
typedef void(^requestMyWalletAccountBlockFail)(void);
typedef void(^requestMyWalletRechargeBlockSuccess)(KKRechargeInfo *rechargeInfo);
typedef void(^requestMyWalletRechargeBlockFail)(void);

typedef void(^requestToRechargeBlockSuccess)(KKRechargeInfo *rechargeInfo);
typedef void(^requestToRechargeBlockFail)(void);
@interface KKMyWalletService : NSObject
@property (nonatomic, copy) requestMyWalletAccountBlockSuccess requestMyWalletAccountBlockSuccess;
@property (nonatomic, copy) requestMyWalletAccountBlockFail requestMyWalletAccountBlockFail;
@property (nonatomic, copy) requestMyWalletRechargeBlockSuccess requestMyWalletRechargeBlockSuccess;
@property (nonatomic, copy) requestMyWalletRechargeBlockFail requestMyWalletRechargeBlockFail;
@property (nonatomic, copy) requestToRechargeBlockSuccess requestToRechargeBlockSuccess;
@property (nonatomic, copy) requestToRechargeBlockFail requestToRechargeBlockFail;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *fundChannelId;

/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 销毁
 */
+ (void)destroyInstance;

/**
 请求我的钱包信息
 
 @param success success
 @param fail fail
 */
+ (void)requestMyWalletInfoSuccess:(requestMyWalletAccountBlockSuccess)success Fail:(requestMyWalletAccountBlockFail)fail;


/**
 请求充值基本信息, 充值比例等

 @param success success
 @param fail fail
 */
+ (void)requestMyWalletRechargeInfoSuccess:(requestMyWalletRechargeBlockSuccess)success Fail:(requestMyWalletRechargeBlockFail)fail;


/**
 充值

 @param success success
 @param fail fail
 */
+ (void)requestToRechargeInfoSuccess:(requestToRechargeBlockSuccess)success Fail:(requestToRechargeBlockFail)fail;

@end

NS_ASSUME_NONNULL_END
