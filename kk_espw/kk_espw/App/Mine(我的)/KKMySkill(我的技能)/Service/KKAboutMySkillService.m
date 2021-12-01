//
//  KKAboutMySkillService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKAboutMySkillService.h"
#import "KKGamePrice.h"

@implementation KKAboutMySkillService
static KKAboutMySkillService *mySkillService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        mySkillService = [[KKAboutMySkillService alloc] init];
    });
    return mySkillService;
}

+ (void)requestGamePriceSuccess:(requestGamePriceBlockSuccess)success Fail:(requestGamePriceBlockFail)fail {
    [[CC_Mask getInstance] start];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_GAME_BOARD_PRICE_QUERY" forKey:@"service"];
    [params safeSetObject:@"TEAM" forKey:@"gameBoardType"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        KKGamePrice *gPrice = [KKGamePrice mj_objectWithKeyValues:responseDic];
        if (str) {
            [[CC_Mask getInstance] stop];
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            [[CC_Mask getInstance] stop];
            if (success) {
                success(gPrice);
            }
        }
    }];
}

+ (void)requestUpdatePriceSuccess:(requestUpdatePriceBlockSuccess)success Fail:(requestUpdatePriceBlockFail)fail {
    [[CC_Mask getInstance] start];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_GAME_BOARD_PRICE_MODIFY" forKey:@"service"];
    [params safeSetObject:[KKAboutMySkillService shareInstance].userGameBoardPriceConfigId forKey:@"id"];
    [params safeSetObject:[KKAboutMySkillService shareInstance].modifiPrice forKey:@"modifiPrice"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [[CC_Mask getInstance] stop];
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            [[CC_Mask getInstance] stop];
            [CC_Notice show:@"设置成功"];
            if (success) {
                success();
            }
        }
    }];
}
@end
