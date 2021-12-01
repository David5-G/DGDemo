//
//  KKMyWalletService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyWalletService.h"
#import "KKMyWalletInfo.h"
#import "KKRechargeInfo.h"

@implementation KKMyWalletService

static KKMyWalletService *myWalletService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        myWalletService = [[KKMyWalletService alloc] init];
    });
    return myWalletService;
}

+ (void)requestMyWalletInfoSuccess:(requestMyWalletAccountBlockSuccess)success Fail:(requestMyWalletAccountBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"ACCOUNT_INFO_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKMyWalletInfo *walletInfo = [KKMyWalletInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(walletInfo);
            }
        }
    }];
}

+ (void)requestMyWalletRechargeInfoSuccess:(requestMyWalletRechargeBlockSuccess)success Fail:(requestMyWalletRechargeBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"DEPOSIT_BASE_INFO_QUERY" forKey:@"service"];
    [params safeSetObject:@"KK_IPHONE" forKey:@"sortTypes"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKRechargeInfo *rechargeInfo = [KKRechargeInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(rechargeInfo);
            }
        }
    }];
}

+ (void)requestToRechargeInfoSuccess:(requestToRechargeBlockSuccess)success Fail:(requestToRechargeBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"DEPOSIT_APPLY" forKey:@"service"];
    [params safeSetObject:@"KK_IPHONE" forKey:@"sortTypes"];
    [params safeSetObject:[KKMyWalletService shareInstance].amount forKey:@"amount"];
    [params safeSetObject:[KKMyWalletService shareInstance].fundChannelId forKey:@"fundChannelId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKRechargeInfo *rechargeInfo = [KKRechargeInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(rechargeInfo);
            }
        }
    }];
}

+ (void)destroyInstance {
    myWalletService = nil;
}
@end
