//
//  KKCapitalService.m
//  kk_espw
//
//  Created by 景天 on 2019/8/7.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCapitalService.h"
#import "KKCapitalAccount.h"
#import "KKCapitalFreeze.h"
@implementation KKCapitalService
+ (void)requestCapitalAccountDataWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate CurrentPage:(NSNumber *)currentPage Success:(void (^)(NSMutableArray * _Nonnull, KKPaginator * _Nonnull))success Fail:(void (^)(void))fail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"ACCOUNT_LOG_QUERY" forKey:@"service"];
    [params safeSetObject:startDate forKey:@"startDate"];
    [params safeSetObject:endDate forKey:@"endDate"];
    [params safeSetObject:currentPage forKey:@"currentPage"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSMutableArray *dataList = responseDic[@"accountLogs"];
        KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *data = [NSMutableArray array];
            data = [KKCapitalAccount mj_objectArrayWithKeyValuesArray:dataList];
            if (success) {
                success(data, paginator);
            }
        }
    }];
}

+ (void)requestCapitalFreezeDataWithStartDate:(NSString *)startDate EndDate:(NSString *)endDate CurrentPage:(NSNumber *)currentPage Success:(void (^)(NSMutableArray * _Nonnull, KKPaginator * _Nonnull))success Fail:(void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"FREEZE_QUERY" forKey:@"service"];
    [params safeSetObject:startDate forKey:@"startDate"];
    [params safeSetObject:endDate forKey:@"endDate"];
    [params safeSetObject:currentPage forKey:@"currentPage"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSMutableArray *dataList = responseDic[@"freezeInfoList"];
        KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *data = [NSMutableArray array];
            data = [KKCapitalFreeze mj_objectArrayWithKeyValuesArray:dataList];
            if (success) {
                success(data, paginator);
            }
        }
    }];
}
@end
