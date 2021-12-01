//
//  KKMyCardService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyCardService.h"
#import "KKCardTag.h"

@implementation KKMyCardService

static KKMyCardService *myCardService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        myCardService = [[KKMyCardService alloc] init];
    });
    return myCardService;
}

+ (void)requestCardTagListSuccess:(requestCardTagListBlockSuccess)success Fail:(requestCardTagListBlockFail)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_GAME_PROFILES_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *data = [KKCardTag mj_objectArrayWithKeyValuesArray:responseDic[@"userGameProfilesList"]];
            if (success) {
                success(data);
            }
        }
    }];
}

+ (void)destroyInstance {
    myCardService = nil;
}
@end
