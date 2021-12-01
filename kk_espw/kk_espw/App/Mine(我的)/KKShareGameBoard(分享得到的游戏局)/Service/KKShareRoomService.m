//
//  KKShareRoomService.m
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKShareRoomService.h"
#import "KKHomeRoomListInfo.h"
#import "KKShareGameInfo.h"

@implementation KKShareRoomService
static KKShareRoomService *shareRoomService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        shareRoomService = [[KKShareRoomService alloc] init];
    });
    return shareRoomService;
}

+ (void)requestShareRoomDataSuccess:(requestShareRoomDataBlockSuccess)success Fail:(requestShareRoomDataBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_QRCODE_SHARE_QUERY" forKey:@"service"];
    [params safeSetObject:[KKShareRoomService shareInstance].gameBoradId forKey:@"gameBoardId"];
    [params safeSetObject:[KKShareRoomService shareInstance].shareUserId forKey:@"shareUserId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSMutableArray *dataList = responseDic[@"dataList"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKShareGameInfo *shareGameInfo = [KKShareGameInfo mj_objectWithKeyValues:responseDic];
            KKHomeRoomListInfo *info = [KKHomeRoomListInfo mj_objectWithKeyValues:dataList.firstObject];
            if (success) {
                success(shareGameInfo, info);
            }
        }
    }];
}
@end
