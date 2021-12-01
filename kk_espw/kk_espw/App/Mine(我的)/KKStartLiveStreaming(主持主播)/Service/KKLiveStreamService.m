//
//  KKLiveStreamService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKLiveStreamService.h"
#import "KKHomeRoomStatus.h"
@implementation KKLiveStreamService

static KKLiveStreamService *liveStreamService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        liveStreamService = [[KKLiveStreamService alloc] init];
    });
    return liveStreamService;
}

+ (void)requestAnchorPresidChannelDataSuccess:(requestAnchorPresidChannelBlockSuccess)success Fail:(requestAnchorPresidChannelBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"ANCHOR_PRESIDE_CHANNEL_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *dataList = [NSMutableArray array];
            dataList = [KKHomeRoomStatus mj_objectArrayWithKeyValuesArray:responseDic[@"channelSimples"]];
            if (success) {
                success(dataList);
            }
        }
    }];
}

+ (void)destroyInstance {
    liveStreamService = nil;
}
@end
