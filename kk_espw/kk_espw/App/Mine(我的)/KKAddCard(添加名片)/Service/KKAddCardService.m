//
//  KKAddCardService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/25.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKAddCardService.h"

@implementation KKAddCardService
static KKAddCardService *addCardService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        addCardService = [[KKAddCardService alloc] init];
    });
    return addCardService;
}

+ (void)requestaddCardSuccess:(requestAddCardBlockSuccess)success Fail:(requestAddCardBlockFail)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:[KKAddCardService shareInstance].service forKey:@"service"];
    [params safeSetObject:[KKAddCardService shareInstance].platformType forKey:@"platformType"];
    [params safeSetObject:[KKAddCardService shareInstance].rank forKey:@"rank"];
    [params safeSetObject:[KKAddCardService shareInstance].nickName forKey:@"nickName"];
    [params safeSetObject:[KKAddCardService shareInstance].sex forKey:@"sex"];
    [params safeSetObject:[KKAddCardService shareInstance].serviceArea forKey:@"serviceArea"];
    [params safeSetObject:[KKAddCardService shareInstance].preferLocations forKey:@"preferLocations"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"modifyUserId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"createUserId"];
    [params safeSetObject:@"1" forKey:@"gameId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params safeSetObject:[KKAddCardService shareInstance].ID forKey:@"id"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            if ([[KKAddCardService shareInstance].service isEqualToString:@"USER_GAME_PROFILES_MODIFY"]) {
                 [CC_Notice show:@"修改名片成功"];
            }else
            {
                [CC_Notice show:@"添加名片成功"];
            }
            if (success) {
                success();
            }
        }
    }];
}

+ (void)destroyInstance {
    addCardService = nil;
}

@end
