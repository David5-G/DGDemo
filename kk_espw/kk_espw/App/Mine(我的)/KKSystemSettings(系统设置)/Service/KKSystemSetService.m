//
//  KKSystemSetService.m
//  kk_espw
//
//  Created by 景天 on 2019/8/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSystemSetService.h"

@implementation KKSystemSetService

- (void)request_RealName_Auth_Data_Success:(void (^)(NSString *isAuth))success Fail:(void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_REALNAME_AUTHENTICATION_QUERY" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        
        if (str) {
            
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSString *isAuth = responseDic[@"realNameAuthentication"];
            if (success) {
                success(isAuth);
            }
        }
    }];
}
@end
