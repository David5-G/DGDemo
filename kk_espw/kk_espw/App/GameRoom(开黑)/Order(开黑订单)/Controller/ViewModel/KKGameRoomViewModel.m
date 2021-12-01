//
//  KKGameRoomViewModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomViewModel.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
#import "SSProgressHUD.h"
#import "KKRtcService.h"
@interface KKGameRoomViewModel ()

@property (nonatomic, strong, nonnull) dispatch_group_t signalGroup;    ///< 信号组

@property (nonatomic, strong, nullable) NSDate *enterGameRoomDate;  ///< 进入开黑房日期
@property (nonatomic, assign) NSTimeInterval leaveGameRoomTimeConfig;   ///< 离开限制时间

@end

@implementation KKGameRoomViewModel

#pragma mark - init
- (instancetype)init {
    if (self = [super init]) {
        self.leaveGameRoomTimeConfig = 5; ///< 默认5秒
    }
    return self;
}

- (NSMutableArray *)onCarPeopleArray {
    if (!_onCarPeopleArray) {
        _onCarPeopleArray = [NSMutableArray array];
    }
    return _onCarPeopleArray;
}

#pragma mark - get
- (NSInteger)gamePlayerNumbers {
    return 5;
}

- (dispatch_group_t)signalGroup {
    if (!_signalGroup) {
        _signalGroup = dispatch_group_create();
    }
    return _signalGroup;
}

#pragma mark - Action
/// 离开 开黑房 间隔时间 配置查询
- (void)checkForLeaveGameRoomTimeConfigQuery {
    self.enterGameRoomDate = [NSDate date];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LEAVE_GAME_ROOM_TIME_CONFIG_QUERY" forKey:@"service"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            CCLOG(@"请求配置时间失败: error = %@", error);
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.leaveGameRoomTimeConfig = [responseDic[@"config"] doubleValue];
        }
    }];
}

/// 检查可否取消倒计时, force 是否强制取消
- (void)checkCancelCountDownEnable:(BOOL)force {
    if (force) {
        if (self.oldOrderNoStr && self.orderNoStr && [self.oldOrderNoStr isEqualToString:self.orderNoStr]) {
            [[KKCountDownManager standard] removeTaskWithName:self.orderNoStr];
        } else {
            [[KKCountDownManager standard] removeTaskWithName:self.oldOrderNoStr];
            [[KKCountDownManager standard] removeTaskWithName:self.orderNoStr];
        }
        
        if (self.oldGameBoardIdStr && self.infoModel.gameBoardClientSimple.idStr &&
            [self.oldGameBoardIdStr isEqualToString:self.infoModel.gameBoardClientSimple.idStr]) {
            [[KKCountDownManager standard] removeTaskWithName:self.oldGameBoardIdStr];
        } else {
            [[KKCountDownManager standard] removeTaskWithName:self.oldGameBoardIdStr];
            [[KKCountDownManager standard] removeTaskWithName:self.infoModel.gameBoardClientSimple.idStr];
        }

    } else {
        if (self.loginUserIsRoomOwner) {
            if (self.gameStatus != KKGameStatusAllPlayerReadied) {
                [[KKCountDownManager standard] removeTaskWithName:self.oldGameBoardIdStr];
                [[KKCountDownManager standard] removeTaskWithName:self.infoModel.gameBoardClientSimple.idStr];
            }
            
        } else {
            if (self.gameStatus != KKGameStatusPlayerUnPay) {
                [[KKCountDownManager standard] removeTaskWithName:self.oldOrderNoStr];
            }
            if (self.gameStatus != KKGameStatusAllPlayerReadied) {
                [[KKCountDownManager standard] removeTaskWithName:self.oldGameBoardIdStr];
                [[KKCountDownManager standard] removeTaskWithName:self.infoModel.gameBoardClientSimple.idStr];
            }
        }
    }
}

/*
/// 退出开黑房
- (void)exitFromGameRoomWithAlertBlock:(void(^)(void))alertBlock success:(void(^)(void))successBlock {
    KKGameStatus gameStatus = self.gameStatus;
    if (self.loginUserIsRoomOwner) {
        if (gameStatus == KKGameStatusPlayerEnter ||
            gameStatus == KKGameStatusAllPlayerReadied) {
            if (alertBlock) {
                alertBlock();
            } else {
                [self requestForDissolveGameRoomSuccess:successBlock];
            }
            
        }
    } else {
        WS(weakSelf)
        if (gameStatus == KKGameStatusPlayerEnter) {
            [self requestForLeaveGameChatRoomSuccess:successBlock];
            
        } else if (gameStatus == KKGameStatusPlayerJoin) {
            [self requestForCancelSeat:^{
                [weakSelf requestForLeaveGameChatRoomSuccess:successBlock];
            } success:nil];
            
        } else if (gameStatus == KKGameStatusPlayerUnPay ||
                   gameStatus == KKGameStatusPlayerReadied ||
                   gameStatus == KKGameStatusAllPlayerReadied) {
            [self requestForCancelOrderNo:^{
                [weakSelf requestForLeaveGameChatRoomSuccess:successBlock];
            } success:nil];
        }
    }
}
*/

/// 尝试加入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"JOIN_GAME_BOARD_CHAT_ROOM" forKey:@"service"];
    [params safeSetObject:(gameboardId ?: self.gameBoardIdStr) forKey:@"gameBoardId"];
    
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            CCLOG(@"加入聊天室失败: error = %@", error);
            [CC_Notice show:error];
        } else {
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// 退出开黑房
- (void)exitGameRoomWithSuccess:(void (^)(void))successBlock {
    
    // 限制时间内不可退出
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.enterGameRoomDate];
    if (interval < self.leaveGameRoomTimeConfig) {
        NSString *err = [NSString stringWithFormat:@"等待%.0lf秒后，才能退出。", self.leaveGameRoomTimeConfig];
        [CC_Notice show:err];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LEAVE_GAME_BOARD" forKey:@"service"];
    
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            if ([resModel.errorNameStr isEqualToString:@"GAME_BOARD_STATUS_ERROR"]) {
                [CC_Notice show:@"开黑局已开始，不能退出。"];
            } else {
                [CC_Notice show:error];
            }
        } else {
            
            [[KKRtcService shareInstance] leaveRoom:self.channelId success:^{
                [HUD stop];
                BBLOG(@"退出rtc开黑房 - 成功");
                //成功
                if (successBlock) {
                    successBlock();
                }
                
                
            } error:^(RongRTCCode code) {
                [HUD stop];
                BBLOG(@"退出rtc开黑房 - 失败");
                
                dispatch_main_async_safe(^{
                    [CC_Notice show:@"退出开黑房失败！"];
                });
            }];
            
            
        }
    }];
}

#pragma mark - 处理数据
/// 处理开黑房数据
- (void)dealWithGameRoomInfoWith:(NSDictionary *)responseDic {
    [self.onCarPeopleArray removeAllObjects];
    //1.gameBoardDetailSimpleList
    KKGameRoomInfoModel *infoModel = [KKGameRoomInfoModel mj_objectWithKeyValues:responseDic];
    CCLOG(@"gameBoardDetailSimpleList_count == %lu", infoModel.gameBoardDetailSimpleList.count);
    // 保存聊天室id和游戏局id
    self.groupIdStr = infoModel.groupId;
    self.gameBoardIdStr = infoModel.gameBoardClientSimple.idStr;
    
    // 判断房主
    self.loginUserIsRoomOwner = [[KKUserInfoMgr shareInstance].userId isEqualToString:infoModel.gameBoardClientSimple.ownerUserId];
    self.ownerLogoUrl = infoModel.gameBoardClientSimple.ownerUserlogoUrl;
    self.channelId = infoModel.gameBoardClientSimple.channelId;
    // 刷新数据前清空之前数据
    self.loginUserIsInGame = NO;
    self.reachMaxPlayers = NO;
    self.currentSimpleModel = nil;
    self.roomOwnerSimpleModel = nil;
    self.gameStatus = KKGameStatusPlayerEnter;
    self.orderNoStr = infoModel.currentUserPurchaseNo;
    
    //收费情况
    self.depositPrice = [infoModel.gameBoardClientSimple.deposit integerValue];
    
    NSMutableArray<KKGameBoardDetailSimpleModel *> *playerInfos = [NSMutableArray arrayWithCapacity:self.gamePlayerNumbers];
    
    //填充占位数据
    for (NSInteger index = 0; index < self.gamePlayerNumbers; index ++) {
        [playerInfos addObject:[[KKGameBoardDetailSimpleModel alloc] init]];
    }
    
    // 玩家人数
    NSInteger playerNumber = [[KKGameRoomContrastModel shareInstance].patternMapDic[infoModel.gameBoardClientSimple.patternType.name ?: @""] integerValue] + 1;
    
    // 已上车人数
    NSInteger playerOccupyNumber = 0;
    // 已经准备的玩家人数
    NSInteger playerReadyNumber = 0;
    
    // 遍历
    for (KKGameBoardDetailSimpleModel *simpleModel in infoModel.gameBoardDetailSimpleList) {
        
        BOOL isRoomOwner = [simpleModel.userId isEqualToString:infoModel.gameBoardClientSimple.ownerUserId];
        BOOL isInGame = [simpleModel.userId isEqualToString:[KKUserInfoMgr shareInstance].userId];
        BOOL isPrepare = [simpleModel.userProceedStatus.name isEqualToString:@"PREPARE"];
        BOOL isPay = [simpleModel.purchaseOrderPayStatusEnum.name isEqualToString:@"FREEZE_FINISH"];
        
        simpleModel.isRoomOwner = isRoomOwner;
        
        if (simpleModel.userId != nil) {
            playerOccupyNumber ++;
            // 获取在车上的人的模型
            [self.onCarPeopleArray addObject:simpleModel];
        }
        
        if (isRoomOwner) {
            self.roomOwnerSimpleModel = simpleModel;
        }
        
        if (isInGame) {
            self.loginUserIsInGame = YES;
            self.currentSimpleModel = simpleModel;
        }
        
        // 准备且支付过了才算准备成功
        if (isPrepare && isPay) {
            playerReadyNumber ++;
        }
        
        // 排序
        NSString *name = simpleModel.gamePosition.firstObject.name;
        if (name && [KKGameRoomContrastModel shareInstance].positionMapDic[name]) {
            simpleModel.playRoadString = [KKGameRoomContrastModel shareInstance].positionMapDic[name].title;
            NSInteger index = [KKGameRoomContrastModel shareInstance].positionMapDic[name].position;
            [playerInfos replaceObjectAtIndex:index withObject:simpleModel];
        }
    }
    
    // 达到最大玩家人数
    if (playerOccupyNumber == playerNumber) {
        self.reachMaxPlayers = YES;
    }
    
    // 当前用户已在准备列表
    if (self.loginUserIsInGame) {
        
        // 非房主
        if (!self.loginUserIsRoomOwner) {
            BOOL isPrepare = [self.currentSimpleModel.userProceedStatus.name isEqualToString:@"PREPARE"];
            BOOL isPay = [self.currentSimpleModel.purchaseOrderPayStatusEnum.name isEqualToString:@"FREEZE_FINISH"];
            
            if (isPrepare) {
                self.gameStatus = isPay ? KKGameStatusPlayerReadied : KKGameStatusPlayerUnPay;
                
            } else if ([self.currentSimpleModel.userProceedStatus.name isEqualToString:@"OCCUPY"]) {
                self.gameStatus = KKGameStatusPlayerJoin;
            }
        }
        
        // 所有玩家都已准备
        if (playerReadyNumber == playerNumber) {
            self.gameStatus = KKGameStatusAllPlayerReadied;
        }
        
        if ([infoModel.gameBoardClientSimple.proceedStatus.name isEqualToString:@"PROCESSING"]) {
            self.gameStatus = KKGameStatusInPlaying;
        }
    }
    
    infoModel.gameBoardDetailSimpleList = [playerInfos copy];
    self.infoModel = infoModel;
}

/// 保存旧数据,用于取消倒计时
- (void)catchOldDatasForCancelCountDown {
    self.oldGameBoardIdStr = self.infoModel.gameBoardClientSimple.idStr;
    self.oldOrderNoStr = self.orderNoStr;
}

#pragma mark - 网络请求
- (void)requestForAll:(void(^)(void))success {
    [self catchOldDatasForCancelCountDown];
    [self requestForGameRoomDetailInfo];
    dispatch_group_notify(self.signalGroup, dispatch_get_main_queue(), ^{
        if (success) {
            success();
        }
    });
}

/// 获取房间信息
- (void)requestForGameRoomDetailInfo {
    dispatch_group_enter(self.signalGroup);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:self.gameProfilesIdStr forKey:@"profilesId"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", (long)self.gameRoomId] forKey:@"gameRoomId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
            
        if (error) {
            // 开黑房已结束
            if ([resModel.errorNameStr isEqualToString:@"GAME_BOARD_NOT_ONGOING_NOT_EXISTED"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:resModel.errorNameStr object:nil];
            
            // 段位不符
            } else if ([resModel.errorNameStr isEqualToString:@"USER_GAME_PROFILES_NOT_CONFORM"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:resModel.errorNameStr object:nil];
                
            } else {
                [CC_Notice show:error];
            }
            
        }else {
            [weakSelf dealWithGameRoomInfoWith:responseDic];
        }
        
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
    }];
}

/// 点击用户头像, 请求玩家信息
/// 查询禁言状态
- (void)requestForPlayerHeaderIconWith:(NSIndexPath *)indexPath showCardBlock:(void(^)(NSDictionary *responseDic))showBlock {
    
    if (indexPath.item > self.infoModel.gameBoardDetailSimpleList.count - 1) {
        return;
    }
    
    KKGameBoardDetailSimpleModel *simpleModel = self.infoModel.gameBoardDetailSimpleList[indexPath.item];
    //1. 游戏房间id
    NSInteger gameRoomId = self.infoModel.gameBoardClientSimple.gameRoomId;
    if (!simpleModel.userId) {
        return;
    }
    /// GAME_INFO_WITH_TARGET_USER_DETAIL_QUERY
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_INFO_WITH_TARGET_USER_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:simpleModel.userId forKey:@"targetUserId"];
    [params safeSetObject:@(gameRoomId) forKey:@"roomId"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (error) {
            [CC_Notice show:error];
        }else {
            if (showBlock) {
                showBlock(responseDic);
            }
        }
    }];
}

/// 加好友
- (void)requestForAddFriendWith:(NSString *)targetUserId {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"ADD_FRIEND" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"applyUserId"];
    [params safeSetObject:targetUserId forKey:@"recieveUserId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userInfoModel.nickName forKey:@"validateMessage"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            [CC_Notice show:@"好友申请已发出"];
        }
    }];
}

/// 移除开黑房
- (void)requestForRemoveFromGameRoomWithUserId:(NSString *)userId gameBoardId:(NSString *)gameBoardId successsuccessBlock:(void(^)(void))successBlock {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_GAME_KICK_PLAYER" forKey:@"service"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:@"被请离开黑房，订单关闭。" forKey:@"memo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            if ([resModel.errorNameStr isEqualToString:@"GAME_BOARD_STATUS_ERROR"]) {
                [CC_Notice show:@"开黑局已开始，不能移除。"];
            } else {
                [CC_Notice show:error];
            }
        }else {
            [CC_Notice show:@"移除成功"];
            [weakSelf requestForAll:successBlock];
        }
    }];
}

/// 解散
- (void)requestForDissolveGameRoomSuccess:(void(^)(void))successBlock {
    
    // 限制时间内, 不可解散
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.enterGameRoomDate];
    if (interval < self.leaveGameRoomTimeConfig) {
        NSString *err = [NSString stringWithFormat:@"等待%.0lf秒后，才能退出。", self.leaveGameRoomTimeConfig];
        [CC_Notice show:err];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_DISSOLVE" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@"房主解散开黑房，订单关闭。" forKey:@"memo"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// '上车'/切换位置
- (void)requestForOccupySeat:(KKGameBoardDetailSimpleModel *)simpleModel status:(NSInteger)status success:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_OCCUPY_SEAT" forKey:@"service"];
    [params safeSetObject:self.gameProfilesIdStr forKey:@"profilesId"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", (long)self.gameRoomId] forKey:@"gameRoomId"];
    [params safeSetObject:self.currentSimpleModel.joinId forKey:@"oldJoinId"];
    [params safeSetObject:simpleModel.joinId forKey:@"nowJoinId"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    
    [self showLoadingWithMaskType:SSProgressHUDMaskTypeClear];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hideHUD];
        });
        
        if (error) {
            [CC_Notice show:error];
        }else {
            //[CC_Notice show:@"上车成功" atView:weakSelf.view];
            [weakSelf requestForAll:successBlock];
        }
    }];
}

/// 点击'准备', 加入游戏
- (void)requestForGameTogether:(void(^)(NSDictionary *responseDic))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_JOIN" forKey:@"service"];
    [params safeSetObject:self.currentSimpleModel.joinId forKey:@"joinId"];
    [params safeSetObject:self.currentSimpleModel.profilesId forKey:@"profilesId"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            if (successBlock) {
                NSDictionary *responseDic = resModel.resultDic[@"response"];
                successBlock(responseDic);
            }
        }
    }];
}

/// 游戏开始
- (void)requestForGameStart:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_START" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        
        if (error) {
            [CC_Notice show:error];
        }else {
            [CC_Notice show:@"游戏开始"];
            [weakSelf requestForAll:successBlock];
        }
    }];
}

/// 游戏结束
- (void)requestForGameOver:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_EVALUATE" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// 离座
- (void)requestForCancelSeat:(void(^)(void))resultBlock success:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CANCEL_SEAT" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", (long)self.gameRoomId] forKey:@"gameRoomId"];
    [params safeSetObject:self.currentSimpleModel.joinId forKey:@"nowJoinId"];
    [params safeSetObject:self.currentSimpleModel.profilesId forKey:@"profilesId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            if (resultBlock) {
                resultBlock();
            } else {
                //[CC_Notice show:@"离座成功" atView:weakSelf.view];
                [weakSelf requestForAll:successBlock];
            }
        }
    }];
}

/// 呼叫主持
- (void)requestForCallLed:(void(^)(void))alertBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_ROOM_CALL_LED" forKey:@"service"];
    [params safeSetObject:self.infoModel.gameBoardClientSimple.rank.name forKey:@"gameBoardRank"];
    [params safeSetObject:[NSString stringWithFormat:@"%ld", (long)self.gameRoomId] forKey:@"gameRoomId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"fromUserId"];
    //[params safeSetObject:self.groupIdStr forKey:@"toChatroomIds"];
    
    NSString *contentStr = [NSString stringWithFormat:@"%@大区%@段位缺位置，大神快来，主持帮我喊人，房间ID：%ld",
                            self.infoModel.gameBoardClientSimple.platformType.message,
                            self.infoModel.gameBoardClientSimple.rank.message,
                            (long)self.infoModel.gameBoardClientSimple.gameRoomId];
    [params safeSetObject:contentStr forKey:@"content"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            if (alertBlock) {
                alertBlock();
            }
        }
    }];
}

/// 余额查询
- (void)requestForMyWalletInfo:(void(^)(KKMyWalletInfo * _Nonnull myWallet))alertBlock {
    [KKMyWalletService requestMyWalletInfoSuccess:^(KKMyWalletInfo * _Nonnull walletInfo) {
        if (alertBlock) {
            alertBlock(walletInfo);
        }
    } Fail:^{
    }];
}

/// 余额支付
- (void)requestForPayOrderNo:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_PAY" forKey:@"service"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    [params safeSetObject:@"ACCOUNT" forKey:@"payType"];
    [params safeSetObject:@(self.depositPrice) forKey:@"paidFee"];
    //[params safeSetObject:@{} forKey:@"depositParameters"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            [CC_Notice show:@"支付成功"];
            [weakSelf requestForAll:successBlock];
        }
    }];
}

/// 取消订单
- (void)requestForCancelOrderNo:(void(^)(void))resultBlock success:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_CANCEL" forKey:@"service"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            [CC_Notice show:@"取消成功"];
            if (resultBlock) {
                resultBlock();
            } else {
                if (successBlock) {
                    [weakSelf requestForAll:successBlock];
                }
            }
        }
    }];
}

/// 加入聊天室
- (void)requestForJoinGameChatRoom:(void (^)(void))successBlock {
    [self joinGameRoomWithGameBoardId:nil Success:successBlock];
}

/// 离开聊天室
- (void)requestForLeaveGameChatRoomSuccess:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LEAVE_GAME_BOARD_CHAT_ROOM" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            CCLOG(@"退出聊天室失败: error = %@", error);
            [CC_Notice show:error];
        } else {
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// 获取开黑房在线人数
- (void)requestForChatRoomOnlinePeople:(void(^)(void))successBlock {
    
    if (!self.groupIdStr) {
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_MEMBERS_QUERY" forKey:@"service"];
    [params safeSetObject:self.groupIdStr forKey:@"groupId"];
    [params safeSetObject:@"1" forKey:@"currentPage"];
    [params safeSetObject:@"10" forKey:@"pageSize"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSDictionary *groupIdDic = responseDic[@"countByGroupIds"];
            if (weakSelf.groupIdStr && [groupIdDic isKindOfClass:[NSDictionary class]]) {
                weakSelf.totalOnlinePeopleCount = [groupIdDic[weakSelf.groupIdStr] integerValue];
            }
            weakSelf.onlinePeopleArray = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:responseDic[@"channelUsers"]];
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// 请离限制时间查询
- (void)requestForOwnerKiperLimitTime {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"OWNER_KIPER_LIMIT_TIME" forKey:@"service"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.kiperLimitTime = [responseDic[@"config"] doubleValue];
        }
    }];
}

/*
/// 游戏局未开始前自动结束时间配置查询
- (void)requestForGameLeaveTimeConfig {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_AUTO_DISSOLUTION_TIME_CONFIG_QUERY" forKey:@"service"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.gameLeaveTimeConfig = [responseDic[@"config"] integerValue];
        }
    }];
}
 */

/// 进群查询
- (void)requestForIntoGameGroupWithWechat:(void(^)(NSString * urlStr))wechatBlock qq:(void(^)(NSString * urlStr))qqBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_GROUP_QRCODEURL_QUERY" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            if ([responseDic[@"groupType"] isEqualToString:@"WEIXIN"]) {
                if (wechatBlock) {
                    wechatBlock(responseDic[@"url"]);
                }
            } else {
                if (qqBlock) {
                    qqBlock(responseDic[@"gameGroupLink"]);
                }
            }
        }
    }];
}

/// 分享查询
- (void)requestForShareUrl {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        NSArray *urls = [modelURL.SHARE_DOWNLOAD componentsSeparatedByString:@"?"];
        NSString *frantStr = urls.firstObject;
        NSString *lastStr = urls.lastObject;
        NSString *shareHeadUrl = weakSelf.infoModel.userLogoUrl;
        NSString *roomName = [weakSelf.infoModel.gameBoardClientSimple.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //roomName = [weakSelf.infoModel.gameBoardClientSimple.title stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet letterCharacterSet]];
        NSString *platFormType = weakSelf.infoModel.gameBoardClientSimple.platformType.name;
        NSString *rank = weakSelf.infoModel.gameBoardClientSimple.rank.name;
        NSInteger roomId = weakSelf.infoModel.gameBoardClientSimple.gameRoomId;
        NSString *gameBoardId = self.gameBoardIdStr;
        //升级包修改, 新增type=game
        weakSelf.shareURL = [NSString stringWithFormat:@"%@?shareHeadUrl=%@&roomName=%@&platFormType=%@&rank=%@&roomId=%zi&gameBoardId=%@&type=game&%@", frantStr, shareHeadUrl, roomName, platFormType, rank, roomId, gameBoardId, lastStr];
    } Fail:^{
    }];
}

/// 查询是否在聊天室
- (void)requestForIsInChatRoom:(void(^)(BOOL isInCurrentChatRoom))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CHAT_ROOM_JOINED_GROUPIDS_QUERY" forKey:@"service"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSArray<NSString *> *groupIdArr = responseDic[@"groupIdList"];
            
            BOOL isIn = NO;
            if ([groupIdArr isKindOfClass:[NSArray class]]) {
                for (NSString *groupId in groupIdArr) {
                    if ([groupId isEqualToString:weakSelf.groupIdStr]) {
                        isIn = YES;
                        break;
                    }
                }
            }
            
            if (successBlock) {
                successBlock(isIn);
            }
        }
    }];
}

- (void)requestPleaseLeavcTeamWithUserId:(NSString *)userId success:(void (^)(void))success fail:(void (^)(void))fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_PLEASE_LEAVE_TEAM" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
            
            if (fail) {
                fail();
            }
        } else {
            if (success) {
                success();
            }
        }
    }];
}

- (void)requestGameBoardUserForbiddenWithUserId:(NSString *)userId gameBoardRoomId:(NSInteger)gameBoardRoomId Success:(void(^)(void))success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_ROOM_USER_FORBIDDEN_CHAT_SET" forKey:@"service"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    [params safeSetObject:@(gameBoardRoomId) forKey:@"gameBoardRoomId"];

    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
            
        } else {
            [CC_Notice show:@"禁言成功"];
            if (success) {
                success();
            }
        }
    }];
}

- (void)requestGameBoardUserNoForbiddenWithUserId:(NSString *)userId gameBoardRoomId:(NSInteger)gameBoardRoomId Success:(void(^)(void))success {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_ROOM_USER_FORBIDDEN_CHAT_CANCEL" forKey:@"service"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    [params safeSetObject:@(gameBoardRoomId) forKey:@"gameBoardRoomId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
            
        } else {
            [CC_Notice show:@"已解开禁言"];
            if (success) {
                success();
            }
        }
    }];
}

- (void)requestForbiddenStatusWithUserId:(NSString *)userId groupId:(NSString *)groupId success:(void(^)(NSInteger status))success{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_ROOM_FORBID_CHAT_USER_CONSULT" forKey:@"service"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:groupId forKey:@"groupId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (error) {
            [CC_Notice show:error];
            
        } else {
            NSInteger status = [responseDic[@"forbidden"] integerValue];
            if (success) {
                success(status);
            }
        }
    }];

}
@end
