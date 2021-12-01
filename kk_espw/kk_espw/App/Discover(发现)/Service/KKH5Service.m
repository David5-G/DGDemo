//
//  KKH5Service.m
//  kk_espw
//
//  Created by 景天 on 2019/8/5.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKH5Service.h"
#import "KKH5Url.h"
@implementation KKH5Service
+ (void)requestH5URLDataSuccess:(requestH5URLBlockSuccess)success Fail:(requestH5URLBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GO_TO_H5" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            
            KKH5Url *propertiesInfo = [KKH5Url mj_objectWithKeyValues:responseDic[@"properties"]];
            if (success) {
                success(propertiesInfo);
            }
        }
    }];
}
@end
