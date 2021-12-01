//
//  KKGameOrderDetailViewModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameOrderTagDetailModel.h"
#import "KKMyWalletService.h"
#import "KKMyWalletInfo.h"
#import "KKGameBoardDetailSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKGameOrderDetailViewModel : NSObject

@property (nonatomic, assign) NSInteger gamePlayerNumbers;  ///< 默认5

@property (nonatomic, assign) KKGameStatus gameStatus;          ///< 当前游戏状态
@property (nonatomic, assign) BOOL loginUserIsRoomOwner;        ///< 当前登录用户是否为房主
@property (nonatomic, assign) BOOL reachMaxPlayers;             ///< 房间人数是否已满
@property (nonatomic, assign) NSInteger depositPrice;           ///< 收费标准, 大于0表示收费局, 否则免费局
@property (nonatomic, copy, nullable) NSString *orderNoStr;     ///< 订单号
@property (nonatomic, copy, nullable) NSString *shareURL;       ///< 分享链接

@property (nonatomic, weak, nullable) KKGameBoardDetailSimpleModel *roomOwnerSimpleModel; ///< 房主
@property (nonatomic, strong, nullable) KKGameOrderTagDetailModel *orderModel; ///< 数据源



#pragma mark - tool
/// 检查可否取消倒计时, force 是否强制取消
- (void)checkCancelCountDownEnable:(BOOL)force;

///点单的状态
-(NSString *)proceedStatusMsg;

#pragma mark - 网络请求
/// 获取本局游戏对我的评价
- (void)requestForGameBoardEvaluateDetail:(void(^_Nullable)(void))successBlock;

/// 解散
- (void)requestForDissolveGameRoomSuccess:(void(^_Nullable)(void))successBlock;

/// 游戏结束
- (void)requestForGameOver:(void(^_Nullable)(void))successBlock;

/// 分享查询
- (void)requestForShareUrl;

/// 余额查询
- (void)requestForMyWalletInfo:(void(^_Nullable)(KKMyWalletInfo * _Nonnull myWallet))alertBlock;

/// 余额支付
- (void)requestForPayOrderNo:(void(^_Nullable)(void))successBlock;

/// 取消订单
- (void)requestForCancelOrderNo:(void(^_Nullable)(void))resultBlock success:(void(^_Nullable)(void))successBlock;

/// 进群查询
- (void)requestForIntoGameGroupWithWechat:(void(^_Nullable)(NSString * _Nullable urlStr))wechatBlock
                                       qq:(void(^_Nullable)(NSString * _Nullable urlStr))qqBlock;

@end

NS_ASSUME_NONNULL_END
