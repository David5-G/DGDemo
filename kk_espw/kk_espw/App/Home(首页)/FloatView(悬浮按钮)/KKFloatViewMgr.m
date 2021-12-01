//
//  KKFloatViewMgr.m
//  kk_espw
//
//  Created by david on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//
#import "KKFloatViewMgr.h"
#import "KKLiveStudioVC.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKGameRoomManager.h"
#import "KKGameRoomOwnerController.h"
#import "KKHomeVC.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKFloatVoiceRoomModel.h"
#import "KKVoiceRoomViewModel.h"
#import "KKVoiceRoomVC.h"
#import "KKRtcService.h"
#import "KKVoiceRoomRtcMgr.h"
#import "KKGameRtcMgr.h"
@implementation KKFloatViewMgr

#pragma mark - life circle
static KKFloatViewMgr *_floatViewMgr = nil;
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _floatViewMgr = [[super allocWithZone:NULL] init];
    });
    return _floatViewMgr;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return _floatViewMgr;
}

- (id)copy {
    return _floatViewMgr;
}

#pragma mark -
/// 离开招募厅
- (void)tryToLeaveLiveStudio:(void(^)(void))success {
    //1.当前悬浮的不是招募厅
    if (self.liveStudioModel.studioId.length < 1) {
        return;
    }
    //2.调招募厅的离开
    [KKLiveStudioVC shareInstance].studioId =self.liveStudioModel.studioId;
    [[KKLiveStudioRtcMgr shareInstance] requestLeaveStudio:self.liveStudioModel.studioId success:^{
        self.liveStudioModel = nil;
        if (success) {
            success();
        }
    }];
}

/// 离开开黑房
- (void)tryToLeaveGameRoom:(void(^)(void))success {
    [[KKGameRoomManager sharedInstance] exitFromGameRoomWithSuccess:^{
        self.type = KKFloatViewTypeUnknow;
        self.gameRoomModel.gameRoomId = 0;
        if (success) {
            success();
        }
    }];
}

/// 离开语音房
- (void)tryLeaveVoiceRoom:(void(^)(void))success {
    CCLOG(@"roomId = %ld \n channelId = %@", (long)self.voiceRoomModel.roomId, self.voiceRoomModel.channelId);
    [[KKVoiceRoomRtcMgr shareInstance] requestLeaveRoom:[NSString stringWithFormat: @"%ld", self.voiceRoomModel.roomId] channel:self.voiceRoomModel.channelId success:^{
        self.voiceRoomModel.roomId = 0;
        if (success) {
            success();
        }
    }];
}

/// setModel
- (void)setLiveStudioModel:(KKFloatLiveStudioModel *)liveStudioModel {
    _liveStudioModel = liveStudioModel;
    [self showFloatView];
}

- (void)setGameRoomModel:(KKFloatGameRoomModel *)gameRoomModel {
    _gameRoomModel = gameRoomModel;
    [self showFloatView];
}

- (void)setVoiceRoomModel:(KKFloatVoiceRoomModel *)voiceRoomModel {
    _voiceRoomModel = voiceRoomModel;
    [self showFloatView];
}


- (void)showFloatView{
    WS(weakSelf)
    if (self.gameRoomModel.gameRoomId > 0 || self.voiceRoomModel.roomId > 0) {
        if (self.hiddenFloatView == YES) {
            
        }else {
            [[KKFloatGameRoomView shareInstance] showKhSuspendedView];
        }
        if (self.gameRoomModel.gameRoomId > 0) {
            [KKFloatGameRoomView shareInstance].gameModel = self.gameRoomModel;
        }
        if (self.voiceRoomModel.roomId > 0) {
            [KKFloatGameRoomView shareInstance].voiceModel = self.voiceRoomModel;
        }
        
        [[KKFloatGameRoomView shareInstance] addTapWithTimeInterval:0.3 tapBlock:^(UIView * _Nonnull view) {
            //1.点击的时候 检查下当前开黑房的状态, 招募中才可以进入, 其他状态移除掉
            [weakSelf requestFloatRoomViewTypeInfoSuccess:^(NSString * _Nonnull type) {
                //2. 判断是开黑房的类型
                if ([type isEqualToString:@"game"]) {
                    
                    //2.如果是观众白银 房主黄金   之后有一个上车的铂金段位, 那么观众就进不去开黑房间. 提示 "开黑房段位不符合，你已退出开黑房"
                    [weakSelf request_game_board_join_consult_dataWithProfilesId:weakSelf.gameRoomModel.gameProfilesIdStr gameRoomId:weakSelf.gameRoomModel.gameRoomId gameBoardId:weakSelf.gameRoomModel.gameBoardIdStr success:^{
                        //3.有黑框都允许进入
                        [weakSelf pushGameBoardDetailRoomId:weakSelf.gameRoomModel.gameRoomId gameBoardId:weakSelf.gameRoomModel.gameBoardIdStr gameProfilesId:weakSelf.gameRoomModel.gameProfilesIdStr groupId:weakSelf.gameRoomModel.groupIdStr];
                        
                        [weakSelf removeFloatGameBoardView];
                    } fail:^(NSString *errorMsg, NSString *errorName) {
                        if ([errorName isEqualToString:@"USER_GAME_PROFILES_NOT_CONFORM"]) {
                            [weakSelf tryToLeaveGameRoom:^{
                                [CC_Notice show:@"开黑房段位不符合，你已退出开黑房"];
                                [weakSelf removeFloatGameBoardView];
                            }];
                            return ;
                        }
                        
                        [weakSelf tryToLeaveGameRoom:^{
                            [CC_Notice show:errorMsg];
                            [weakSelf removeFloatGameBoardView];
                        }];
                    }];
                }else {
                    // 语音房的进入
                    [weakSelf pushVoiceRoomDetailVCWithRoomId:[NSString stringWithFormat:@"%ld", self.voiceRoomModel.roomId] channelId:self.voiceRoomModel.channelId];
                }
            }];
        }];
        /// 点击关闭开黑房按钮
        [KKFloatGameRoomView shareInstance].tapCloseGameRoomBlock = ^{
            if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
                [weakSelf tryToLeaveGameRoom:^{
                    //1. 如果登录用户是房主, 刷新列表
                    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:weakSelf.gameRoomModel.ownerUserId]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VOICE_ROOM_HOST_LEAVE object:self userInfo:nil];
                    }
                    [[KKFloatViewMgr shareInstance] cleanGameData];
                }];
            }
            
            if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
                [weakSelf tryLeaveVoiceRoom:^{
                    //1. 如果登录用户是房主, 刷新列表
                    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:weakSelf.voiceRoomModel.ownerUserId]) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_ROOM_DISSOLVE object:nil];
                    }
                    [[KKFloatViewMgr shareInstance] cleanVoiceData];
                }];
            }
        };
        
    }else{
        
        [[KKFloatGameRoomView shareInstance] removeFromSuperview];
        [KKFloatGameRoomView destroyInstance];
    }
    
    if (self.liveStudioModel.studioId.length != 0) {
        if (self.hiddenFloatView == YES) {
            
        }else {
            [[KKFloatLiveStudioView shareInstance] showkSuspendedView];
        }
        
        [[KKFloatLiveStudioView shareInstance] setTitle:self.liveStudioModel.title Name:self.liveStudioModel.hostName ImgUrl:self.liveStudioModel.hostLogoUrl];
        
        [[KKFloatLiveStudioView shareInstance] addTapWithTimeInterval:0.3 tapBlock:^(UIView * _Nonnull view) {
            [[KKLiveStudioRtcMgr shareInstance] requestJoinStudio:weakSelf.liveStudioModel.studioId success:^{
                [weakSelf pushToLiveStudioVCWithStudioId:weakSelf.liveStudioModel.studioId];
                [weakSelf removeFloatStudioView];
            }];
        }];
        
        [KKFloatLiveStudioView shareInstance].tapCloseLiveStudio = ^{
            [weakSelf tryToLeaveLiveStudio:^{
                [[KKFloatViewMgr shareInstance] cleanLiveData];
                
                weakSelf.tapCloseButtonBlock();
            }];
            
        };
    }else{
        [self removeFloatStudioView];
    }
}

- (void)removeFloatStudioView {
    [[KKFloatLiveStudioView shareInstance] removeFromSuperview];
    [KKFloatLiveStudioView destroyInstance];
}

- (void)removeFloatGameBoardView {
    self.gameRoomModel = nil;
    [[KKFloatGameRoomView shareInstance] removeFromSuperview];
    [KKFloatGameRoomView destroyInstance];
}

- (void)checkShowFloatView{
    [self checkShowGameRoomFloatView];
    [self checkShowLiveStudioFloatView];
}

/// 检查开黑房, 语音房
- (void)checkShowGameRoomFloatView{
    [self requestFloatRoomViewTypeInfoSuccess:^(NSString * _Nonnull type) { }];
}

// 检查招募厅悬浮窗
- (void)checkShowLiveStudioFloatView{
    [self requestUserOnlineLiveSuccess:^{ }];
}

// 检查开黑房悬浮窗
- (void)requestFloatRoomViewTypeInfoSuccess:(void(^)(NSString *type))success {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_JOINED_QUERY" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
        [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
            
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            
            if (!responseDic[@"groupSouceType"]) {
                [weakSelf cleanGameData];
                [weakSelf cleanVoiceData];
                return ;
            }
            
            if ([responseDic[@"groupSouceType"] isEqualToString:@"ESPW-GAMEROOM"]) {
                KKFloatGameRoomModel *gameModel = [KKFloatGameRoomModel new];
                //1. 房间Id
                gameModel.gameRoomId = [responseDic[@"roomId"] integerValue];
                //2. 群组Id
                //2.1 开黑房参数需要添加一个GroupId;
                gameModel.groupIdStr = responseDic[@"groupId"];
                NSDictionary *gameBoardRoomInfoSimple = responseDic[@"gameBoardRoomInfoSimple"];
                //3. 局Id
                gameModel.gameBoardIdStr = gameBoardRoomInfoSimple[@"gameBoardId"];
                //4. 名片Id
                gameModel.gameProfilesIdStr = gameBoardRoomInfoSimple[@"gameProfilesId"];
                //5. 局状态
                gameModel.gameBoardstatus = gameBoardRoomInfoSimple[@"gameBoardstatus"];
                gameModel.gameJoinId = responseDic[@"gameJoinId"];
                gameModel.joined = responseDic[@"joined"];
                //6. 房主头像
                gameModel.ownerLogoUrl = responseDic[@"ownerLogoUrl"];
                //7. 链接Rtc ChannelId
                gameModel.channelId = [NSString stringWithFormat:@"%@", responseDic[@"channelId"]];
                //8. 房主id
                gameModel.ownerUserId = responseDic[@"ownerUserId"];
                //9. 重新赋值
                self.gameRoomModel = gameModel;
                success(@"game");
            }else if ([responseDic[@"groupSouceType"] isEqualToString:@"ESPW-VOICE-CHAT-ROOM"]) {
                KKFloatVoiceRoomModel *voiceModel = [KKFloatVoiceRoomModel new];
                //1. 房主头像
                voiceModel.ownerLogoUrl = responseDic[@"ownerLogoUrl"];
                //2. 房主姓名
                voiceModel.ownerName = responseDic[@"ownerLoginName"];
                //3. id
                voiceModel.roomId = [responseDic[@"roomId"] integerValue];
                voiceModel.channelId = [NSString stringWithFormat:@"%@", responseDic[@"channelId"]];
                //4. 房主Id
                voiceModel.ownerUserId = responseDic[@"ownerUserId"];
                //4. 填写相应的信息
                self.voiceRoomModel = voiceModel;
                success(@"voice");
            }
        }
    }];
}

#pragma mark - Jump
/// 进入开黑房详情
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId {
    [[KKGameRtcMgr shareInstance] requestJoinGameRoomGameBoardId:gameBoardId channelId:self.gameRoomModel.channelId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = gameProfilesId;
            [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
            [KKGameRoomOwnerController sharedInstance].gameRoomId = roomid;
            [KKGameRoomOwnerController sharedInstance].groupIdStr = groupId;
            [[KKGameRoomOwnerController sharedInstance] pushSelfByNavi:[KKRootContollerMgr getRootNav]];
            
        });
    }];
}
/// 进入语音房详情
- (void)pushVoiceRoomDetailVCWithRoomId:(NSString *)roomId channelId:(NSString *)channelId{
    [[KKVoiceRoomRtcMgr shareInstance] requestJoinRoom:roomId channel:channelId success:^{
        KKVoiceRoomVC *voiceRoomVC = [KKVoiceRoomVC shareInstance];
        voiceRoomVC.roomId = roomId;
        [voiceRoomVC pushSelfByNavi:[KKRootContollerMgr getRootNav]];
    }];
}

/// 查询招募厅是否存在
- (void)requestUserOnlineLiveSuccess:(void(^)(void))success{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_INLINE_CHANNEL_QUERY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (str) {
            [CC_Notice show:str];
        }else {
            NSArray *channelSimples  = responseDic[@"channelSimples"];
            NSDictionary *channelDic = channelSimples.firstObject;
            if (channelDic) {
                KKFloatLiveStudioModel *liveStudioModel = [KKFloatLiveStudioModel new];
                liveStudioModel.hostLogoUrl = channelDic[@"anchorLogoUrl"];
                liveStudioModel.hostName = channelDic[@"anchorName"];
                liveStudioModel.studioId = [channelDic[@"channelId"] stringValue];
                liveStudioModel.title = channelDic[@"channelName"];
                
                if (![channelDic[@"channelName"] containsString:@"ESPW-VOICE-CHAT-ROOM"] && ![channelDic[@"channelName"] containsString:@"ESPW-GAMEROOM"]) {
                    self.liveStudioModel = liveStudioModel;
                }else {
                    self.liveStudioModel = nil;
                }
            }else {
                self.liveStudioModel = nil;
            }
            if (success) {
                success();
            }
        }
    }];
}

/// 进入招募厅
- (void)pushToLiveStudioVCWithStudioId:(NSString *)studioId {
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            KKLiveStudioVC *liveStudioVC = [KKLiveStudioVC shareInstance];
            liveStudioVC.studioId = studioId;
            [liveStudioVC pushSelfByNavi:[KKRootContollerMgr getRootNav]];
        });
    } error:^(RCConnectErrorCode status) {
        
    }];
}

/// 检查入局名片是否符合
- (void)request_game_board_join_consult_dataWithProfilesId:(NSString *)profilesId
                                                gameRoomId:(NSInteger)gameRoomId
                                               gameBoardId:(NSString *)gameBoardId
                                                   success:(void(^)(void))success
                                                      fail:(void(^)(NSString *errorMsg, NSString *errorName))fail{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_JOIN_CONSULT_QUERY" forKey:@"service"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", (long)gameRoomId] forKey:@"gameRoomId"];
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

/// 个别位置是隐藏视图, 有的位置
- (void)cleanLiveData {
    self.liveStudioModel = nil;
    [[KKFloatLiveStudioView shareInstance] removeFromSuperview];
    [KKFloatLiveStudioView destroyInstance];
}

- (void)cleanGameData {
    self.gameRoomModel = nil;
    [[KKFloatGameRoomView shareInstance] removeFromSuperview];
    [KKFloatGameRoomView destroyInstance];
}

- (void)cleanVoiceData {
    self.voiceRoomModel = nil;
    [[KKFloatGameRoomView shareInstance] removeFromSuperview];
    [KKFloatGameRoomView destroyInstance];
}

- (void)hiddenLiveStudioFloatView {
    [KKFloatLiveStudioView shareInstance].hidden = YES;
}

- (void)hiddenGameRoomFloatView {
    [KKFloatGameRoomView shareInstance].hidden = YES;
}

- (void)notHiddenLiveStudioFloatView {
    [KKFloatLiveStudioView shareInstance].hidden = NO;

}

- (void)notHiddenGameRoomFloatView {
    [KKFloatGameRoomView shareInstance].hidden = NO;
}

- (void)dealloc{
    CCLOG(@"------------");
}

@end
