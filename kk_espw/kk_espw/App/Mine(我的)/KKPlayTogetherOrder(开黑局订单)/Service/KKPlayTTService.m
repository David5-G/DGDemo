//
//  KKPlayTTService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKPlayTTService.h"
#import "KKOrderListInfo.h"

@implementation KKPlayTTService

static KKPlayTTService *playTTService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        playTTService = [[KKPlayTTService alloc] init];
    });
    return playTTService;
}

+ (void)requestOrderListSuccess:(requestOrderListBlockSuccess)success Fail:(requestOrderListBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_QUERY" forKey:@"service"];
    [params safeSetObject:[KKPlayTTService shareInstance].currentPage forKey:@"currentPage"];
    [params safeSetObject:[KKPlayTTService shareInstance].pageSize forKey:@"pageSize"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            NSMutableArray *dataList = [NSMutableArray array];
            dataList = [KKOrderListInfo mj_objectArrayWithKeyValuesArray:responseDic[@"purchaseOrderQueryResponse"]];
            if (success) {
                success(dataList, paginator);
            }
        }
    }];
}

+ (void)requestDissolveGameBoardId:(NSString *)gameBoardId Success:(void (^)(void))success Fail:(void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_DISSOLVE" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:@"房主解散开黑房，订单关闭。" forKey:@"memo"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            if (success) {
                success();
            }
        }
    }];
}

+ (void)requestEndGameBoardId:(NSString *)gameBoard
                       userId:(NSString *)userId
                      Success:(void (^)(void))success
                         Fail:(void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_EVALUATE" forKey:@"service"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:gameBoard forKey:@"gameBoardId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            if (success) {
                success();
            }
        }
    }];
}

+ (void)requestCanEvaluateTimeSuccess:(void (^)(NSString *config, NSString *systmeDate))success Fail:(void (^)(void))fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_FINISH_TIME_CONFIG_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSString *config = responseDic[@"config"];
            NSString *systemDate = responseDic[@"systemDate"];

            if (success) {
                success(config, systemDate);
            }
        }
    }];
}
@end
