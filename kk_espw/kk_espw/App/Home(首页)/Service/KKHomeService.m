//
//  KKHomeService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/19.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKHomeService.h"
#import "KKHomeRoomListInfo.h"
#import "KKHomeRoomStatus.h"
#import "KKCardTag.h"
#import "KKCheckInfo.h"
#import "KKBanner.h"
#import "KKHomeVoiceRoomModel.h"
@implementation KKHomeService

static KKHomeService *homeService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        homeService = [[KKHomeService alloc] init];
    });
    return homeService;
}

+ (void)requestHomeListSuccess:(requestHomeListBlockSuccess)success Fail:(requestHomeListBlockFail)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_PAGE_QUERY" forKey:@"service"];
    [params safeSetObject:[KKHomeService shareInstance].page forKey:@"currentPage"];
    [params safeSetObject:[KKHomeService shareInstance].gameRoomId forKey:@"gameRoomId"];
    [params safeSetObject:[KKHomeService shareInstance].rank forKey:@"rank"];
    [params safeSetObject:[KKHomeService shareInstance].platFormType forKey:@"platFormType"];
    [params safeSetObject:@"10" forKey:@"pageSize"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            NSMutableArray *dataList = [NSMutableArray array];
            /// 模型嵌套模型
            for (NSDictionary *dic in responseDic[@"dataList"]) {
                KKHomeRoomListInfo *info = [KKHomeRoomListInfo mj_objectWithKeyValues:dic];
                [dataList addObject:info];
            }
            if (success) {
                success(dataList, paginator);
            }
        }
    }];
}

- (void)requestHomeListSuccess:(requestHomeListBlockSuccess)success Fail:(requestHomeListBlockFail)fail {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_PAGE_QUERY" forKey:@"service"];
    [params safeSetObject:self.page forKey:@"currentPage"];
    [params safeSetObject:self.gameRoomId forKey:@"gameRoomId"];
    [params safeSetObject:self.rank forKey:@"rank"];
    [params safeSetObject:self.platFormType forKey:@"platFormType"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            NSMutableArray *dataList = [NSMutableArray array];
            /// 模型嵌套模型
            for (NSDictionary *dic in responseDic[@"dataList"]) {
                KKHomeRoomListInfo *info = [KKHomeRoomListInfo mj_objectWithKeyValues:dic];
                [dataList addObject:info];
            }
            if (success) {
                success(dataList, paginator);
            }
        }
    }];
}

+ (void)requestHomeRoomStatusDataSuccess:(requestHomeRoomStatusDataBlockSuccess)success Fail:(requestHomeRoomStatusDataBlockFail)fail{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LIVE_CHANNEL_QUERY" forKey:@"service"];
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

+ (void)requestLastTimeGameBoadDataSuccess:(requestLastTimeGameBoardBlockSuccess)success Fail:(requestLastTimeGameBoardBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LAST_TIME_GAME_BOARD_DETAIL_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKCardTag *lastCard = [KKCardTag mj_objectWithKeyValues:responseDic[@"userGameProfiles"]];
            KKMessage *lastGameBoardInfo = [KKMessage mj_objectWithKeyValues:responseDic[@"gameBoard"][@"proceedStatus"]];
            if (success) {
                success(lastCard, lastGameBoardInfo);
            }
        }
    }];
}

- (void)requestLastTimeGameBoadDataSuccess:(requestLastTimeGameBoardBlockSuccess)success Fail:(requestLastTimeGameBoardBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LAST_TIME_GAME_BOARD_DETAIL_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKCardTag *lastCard = [KKCardTag mj_objectWithKeyValues:responseDic[@"userGameProfiles"]];
            KKMessage *lastGameBoardInfo = [KKMessage mj_objectWithKeyValues:responseDic[@"gameBoard"][@"proceedStatus"]];
            if (success) {
                success(lastCard, lastGameBoardInfo);
            }
        }
    }];
}

+ (void)requestCheckGameBoadDataSuccess:(requestCheckGameBoardBlockSuccess)success Fail:(requestCheckGameBoardBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHECK" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKCheckInfo *checkInfo = [KKCheckInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(checkInfo);
            }
        }
    }];
}

- (void)requestCheckGameBoadDataSuccess:(requestCheckGameBoardBlockSuccess)success Fail:(requestCheckGameBoardBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHECK" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKCheckInfo *checkInfo = [KKCheckInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(checkInfo);
            }
        }
    }];
}

+ (void)requestBannerDataSuccess:(requestBannerBlockSuccess)success Fail:(requestBannerBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"CMS_INFO_LIST_BY_CHANNEL_QUERY" forKey:@"service"];
    [params safeSetObject:@"index_ads" forKey:@"channelCode"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *dataList = [KKBanner mj_objectArrayWithKeyValuesArray:responseDic[@"cmsInfoClientSimpleList"]];
            if (success) {
                success(dataList);
            }
        }
    }];
}

+ (void)requestUserOnlineLiveDataSuccess:(void(^)(NSMutableArray *dataList))success Fail:(void(^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_INLINE_CHANNEL_QUERY" forKey:@"service"];
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

/// 离开聊天室
+ (void)requestForLeaveGameChatRoomGameBoardId:(NSString *)gameBoardId success:(void(^)(void))success{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LEAVE_GAME_BOARD_CHAT_ROOM" forKey:@"service"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            success();
        }
    }];

}

/// 离座
+ (void)requestForCancelSeatWithGameBoardId:(NSString *)gameBoardId
                                 gameRoomId:(NSInteger)gameRoomId
                                     joinId:(NSString *)joinId
                                 profilesId:(NSString *)profilesId
                                    success:(void(^)(void))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CANCEL_SEAT" forKey:@"service"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:[NSString stringWithFormat:@"%lu", gameRoomId] forKey:@"gameRoomId"];
    [params safeSetObject:joinId forKey:@"nowJoinId"];
    [params safeSetObject:profilesId forKey:@"profilesId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            if (success) {
                success();
            }
        }
    }];
}

+ (void)requestIsChatSuccess:(void (^)(NSString * _Nonnull))success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_JOINED_GROUPIDS_QUERY" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSMutableArray *dataList = responseDic[@"groupIdList"];
            if (success) {
                success(dataList.firstObject);
            }
        }
    }];
}

+ (void)requestIsJoinedChatWithGroupId:(NSString *)groupId Success:(void (^)(KKCheckInfo * _Nonnull))success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_IS_JOINED_QUERY" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params safeSetObject:groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            KKCheckInfo *checkInfo = [KKCheckInfo mj_objectWithKeyValues:responseDic];
            if (success) {
                success(checkInfo);
            }
        }
    }];
}

+ (void)request_game_board_join_consult_dataWithProfilesId:(NSString *)profilesId
                                                gameRoomId:(NSInteger)gameRoomId
                                               gameBoardId:(NSString *)gameBoardId
                                                   success:(void(^)(void))success
                                                      fail:(void(^)(NSString *errorMsg, NSString *errorName))fail{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_JOIN_CONSULT_QUERY" forKey:@"service"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", gameRoomId] forKey:@"gameRoomId"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:profilesId forKey:@"profilesId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (error) {

            if (fail) {
                fail(error, resModel.errorNameStr);
            }
            
        } else {
            
            if (success) {
                success();
            }
        }
    }];
}

+ (void)destroyInstance {
    homeService = nil;
}

+ (void)requesHomeVoiceRoomListWithCurrentPage:(NSNumber *)currentPage success:(void(^)(NSMutableArray *dataList, KKPaginator *paginator))success fail:(void(^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"VOICE_CHAT_ROOM_PAGE_QUERY" forKey:@"service"];
    [params safeSetObject:currentPage forKey:@"currentPage"];
    [params safeSetObject:@"10" forKey:@"pageSize"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            KKPaginator *paginator = [KKPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            NSMutableArray *dataList = [NSMutableArray array];
            /// 模型嵌套模型
            dataList = [KKHomeVoiceRoomModel mj_objectArrayWithKeyValuesArray:responseDic[@"dataList"]];
            if (success) {
                success(dataList, paginator);
            }
        }
    }];
}

+ (void)requesHomeVoiceRoomListWithRoomId:(NSString *)roomId success:(void(^)(NSMutableArray *dataList))success fail:(void(^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"VOICE_CHAT_ROOM_PAGE_QUERY" forKey:@"service"];
    [params safeSetObject:roomId forKey:@"roomId"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            NSMutableArray *dataList = [NSMutableArray array];
            dataList = [KKHomeVoiceRoomModel mj_objectArrayWithKeyValuesArray:responseDic[@"dataList"]];
            if (success) {
                success(dataList);
            }
        }
    }];
}
@end
