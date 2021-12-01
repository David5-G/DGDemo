//
//  KKUserFeedBackService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKUserFeedBackService.h"

@implementation KKUserFeedBackService
static KKUserFeedBackService *userFeedBackService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        userFeedBackService = [[KKUserFeedBackService alloc] init];
    });
    return userFeedBackService;
}

+ (void)requestUserFeedBackSuccess:(requestFeedbackBlockSuccess)success Fail:(requestFeedbackBlockFail)fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_ADVICE_CREATE" forKey:@"service"];
    [params safeSetObject:[KKUserFeedBackService shareInstance].adviceConent forKey:@"adviceConent"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            [CC_Notice show:@"反馈成功"];
            if (success) {
                success();
            }
        }
    }];
}
@end
