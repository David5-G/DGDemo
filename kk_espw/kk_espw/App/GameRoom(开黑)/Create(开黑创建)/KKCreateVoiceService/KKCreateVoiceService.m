//
//  KKCreateVoiceService.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateVoiceService.h"

@implementation KKCreateVoiceService
+ (void)requestVoiceChatRoomDeclarationDataWithSuccess:(void (^)(NSMutableArray * _Nonnull))success fail:(nonnull void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"VOICE_CHAT_ROOM_DECLARATION_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *dataList = [NSMutableArray array];
            dataList = responseDic[@"voiceChatRoomDeclaration"];
            if (success) {
                success(dataList);
            }
        }
    }];
}

+ (void)requestCreateVoiceRoomWithDeclaration:(NSString *)declaration Success:(successBlock)success fail:(failBlock)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"VOICE_CHAT_ROOM_CREATE" forKey:@"service"];
    [params safeSetObject:declaration forKey:@"chatRoomTitle"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSString *roomId = [NSString stringWithFormat:@"%@", responseDic[@"id"]];
            NSString *channelId = [NSString stringWithFormat:@"%@", responseDic[@"channelId"]];

            if (success) {
                success(roomId, channelId);
            }
        }
    }];
}
@end
