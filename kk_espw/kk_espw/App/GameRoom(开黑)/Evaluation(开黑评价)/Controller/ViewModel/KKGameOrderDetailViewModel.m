//
//  KKGameOrderDetailViewModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOrderDetailViewModel.h"
#import "KKGameRoomContrastModel.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
#import "KKCountDownManager.h"

@implementation KKGameOrderDetailViewModel

#pragma mark - get
- (NSInteger)gamePlayerNumbers {
    return 5;
}

#pragma mark - tool
/// 检查可否取消倒计时, force 是否强制取消
- (void)checkCancelCountDownEnable:(BOOL)force {
    [[KKCountDownManager standard] removeTaskWithName:self.orderNoStr];
}

-(NSString *)proceedStatusMsg {
    if ([self.orderModel.proceedStatus.name isEqualToString:@"CANCEL"] ||
        [self.orderModel.proceedStatus.name isEqualToString:@"FAIL_SOLD"] ) {
        return @"已关闭";
    }
    return self.orderModel.proceedStatus.message;
}

#pragma mark - 数据处理
- (void)dealWithEvaluateDetailData:(NSDictionary *)responseDic {
    
    KKGameOrderTagDetailModel *orderModel = [KKGameOrderTagDetailModel mj_objectWithKeyValues:responseDic];
    
    // 判断房主
    self.loginUserIsRoomOwner = [[KKUserInfoMgr shareInstance].userId isEqualToString:orderModel.ownerUserId];
    
    // 刷新数据前清空之前数据
    self.gameStatus = KKGameStatusPlayerEnter;
    
    //收费情况
    self.depositPrice = orderModel.gameDeposit;
    
    // 玩家人数
    NSInteger playerNumber = [[KKGameRoomContrastModel shareInstance].patternMapDic[orderModel.patternType.name ?: @""] integerValue] + 1;
    
    // 已上车人数
    NSInteger playerOccupyNumber = 0;
    
    //填充占位数据
    NSMutableArray<KKGameBoardDetailSimpleModel *> *playerInfos = [NSMutableArray arrayWithCapacity:self.gamePlayerNumbers];
    for (NSInteger index = 0; index < self.gamePlayerNumbers; index ++) {
        [playerInfos addObject:[[KKGameBoardDetailSimpleModel alloc] init]];
    }
    
    // 遍历
    for (KKGameBoardDetailSimpleModel *simpleModel in orderModel.dataList) {
        
        simpleModel.isRoomOwner = [simpleModel.userId isEqualToString:orderModel.ownerUserId];
        if (simpleModel.isRoomOwner) {
            self.roomOwnerSimpleModel = simpleModel;
        }
        
        if (simpleModel.userId != nil) {
            playerOccupyNumber ++;
        }
        
        // 排序
        NSString *name = simpleModel.gamePosition.firstObject.name;
        if (name && [KKGameRoomContrastModel shareInstance].positionMapDic[name]) {
            simpleModel.playRoadString = [KKGameRoomContrastModel shareInstance].positionMapDic[name].title;
            NSInteger index = [KKGameRoomContrastModel shareInstance].positionMapDic[name].position;
            [playerInfos replaceObjectAtIndex:index withObject:simpleModel];
        }
    }
    
    if (playerOccupyNumber == playerNumber) {
        self.reachMaxPlayers = YES;
    }
    
    if ([orderModel.proceedStatus.name isEqualToString:@"RECRUIT"]) {
        self.gameStatus = KKGameStatusPlayerEnter;
        
    } else if ([orderModel.proceedStatus.name isEqualToString:@"INIT"]) {
        self.gameStatus = KKGameStatusPlayerUnPay;
        
    } else if ([orderModel.proceedStatus.name isEqualToString:@"CANCEL"]) {
        self.gameStatus = KKGameStatusGameCancel;
        
    } else if ([orderModel.proceedStatus.name isEqualToString:@"PROCESSING"]) {
        self.gameStatus = KKGameStatusInPlaying;
        
    } else if ([orderModel.proceedStatus.name isEqualToString:@"FINISH"]) {
        self.gameStatus = KKGameStatusGameOver;
        
    } else if ([orderModel.proceedStatus.name isEqualToString:@"FAIL_SOLD"]) {
        self.gameStatus = KKGameStatusGameFailSold;
    }
    
    orderModel.dataList = [playerInfos copy];
    self.orderModel = orderModel;
}

#pragma mark - 网络请求
/// 获取本局游戏对我的评价
- (void)requestForGameBoardEvaluateDetail:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        } else {
            [weakSelf dealWithEvaluateDetailData:resModel.resultDic[@"response"]];
            if (successBlock) {
                successBlock();
            }
        }
    }];
}

/// 离开聊天室
- (void)requestForLeaveGameChatRoomSuccess:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LEAVE_GAME_BOARD_CHAT_ROOM" forKey:@"service"];
    [params safeSetObject:self.orderModel.gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    
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

/// 解散
- (void)requestForDissolveGameRoomSuccess:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_DISSOLVE" forKey:@"service"];
    [params safeSetObject:self.orderModel.gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [params safeSetObject:@"房主解散开黑房，订单关闭。" forKey:@"memo"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error];
        }else {
            if (successBlock) {
                successBlock();
            }
            //[weakSelf requestForLeaveGameChatRoomSuccess:successBlock];
        }
    }];
}

/// 游戏结束
- (void)requestForGameOver:(void(^)(void))successBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_EVALUATE" forKey:@"service"];
    [params safeSetObject:self.orderModel.gameBoardId forKey:@"gameBoardId"];
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

/// 分享查询
- (void)requestForShareUrl {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        NSArray *urls = [modelURL.SHARE_DOWNLOAD componentsSeparatedByString:@"?"];
        NSString *frantStr = urls.firstObject;
        NSString *lastStr = urls.lastObject;
        NSString *shareHeadUrl = weakSelf.orderModel.ownerUserLogoUrl;
        NSString *roomName = weakSelf.orderModel.title;
        NSString *platFormType = weakSelf.orderModel.platFormType.name;
        NSString *rank = weakSelf.orderModel.gameBoardRank.name;
        NSInteger roomId = weakSelf.orderModel.gameRoomId;
        NSString *gameBoardId = self.orderModel.gameBoardId;
        
        weakSelf.shareURL = [NSString stringWithFormat:@"%@?shareHeadUrl=%@&roomName=%@&platFormType=%@&rank=%@&roomId=%zi&gameBoardId=%@&%@", frantStr, shareHeadUrl, roomName, platFormType, rank, roomId, gameBoardId, lastStr];
    } Fail:^{
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
            [weakSelf requestForGameBoardEvaluateDetail:successBlock];
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
            [CC_Notice show:@"取消订单成功"];
            if (resultBlock) {
                resultBlock();
            } else {
                if (successBlock) {
                    [weakSelf requestForGameBoardEvaluateDetail:successBlock];
                }
            }
        }
    }];
}

/// 进群查询
- (void)requestForIntoGameGroupWithWechat:(void(^)(NSString * urlStr))wechatBlock qq:(void(^)(NSString * urlStr))qqBlock {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_GROUP_QRCODEURL_QUERY" forKey:@"service"];
    [params safeSetObject:self.orderModel.gameBoardId forKey:@"gameBoardId"];
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

@end
