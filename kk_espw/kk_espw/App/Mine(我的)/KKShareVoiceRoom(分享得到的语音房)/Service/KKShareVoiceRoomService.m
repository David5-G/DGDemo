//
//  KKShareVoiceRoomService.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKShareVoiceRoomService.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKShareGameInfo.h"
@implementation KKShareVoiceRoomService
+ (void)requestShareRoomDataWithShareId:(NSString *)shareId roomId:(NSString *)roomId Success:(void(^)(KKShareGameInfo *shareInfo, KKHomeVoiceRoomModel *roomModel))success Fail:(void(^)(void))fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"VOICE_CHAT_ROOM_SHARE_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:roomId forKey:@"roomId"];
    [params safeSetObject:shareId forKey:@"shareUserId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        /// 这里数据结构变了, 很气!
        NSDictionary *responseDic = resModel.resultDic[@"response"];
//        NSMutableArray *dataList = responseDic[@"dataList"];
        NSDictionary *result = responseDic[@"result"];

        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKShareGameInfo *shareGameInfo = [KKShareGameInfo mj_objectWithKeyValues:responseDic];
            KKHomeVoiceRoomModel *info = [KKHomeVoiceRoomModel mj_objectWithKeyValues:result];
            if (success) {
                success(shareGameInfo, info);
            }
        }
    }];
}
@end
