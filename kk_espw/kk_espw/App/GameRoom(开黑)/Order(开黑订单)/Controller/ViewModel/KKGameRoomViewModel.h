//
//  KKGameRoomViewModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameRoomInfoModel.h"
#import "KKGameRoomContrastModel.h"
#import "KKGameTimeConvertModel.h"
#import "KKChatRoomUserSimpleModel.h"
#import "KKCountDownManager.h"
#import "KKMyWalletService.h"
#import "KKMyWalletInfo.h"


NS_ASSUME_NONNULL_BEGIN

/// 开黑房页面viewModel
@interface KKGameRoomViewModel : NSObject

@property (nonatomic, assign) NSInteger gamePlayerNumbers;  ///< 默认5

/// (必须)开黑房id
@property (nonatomic, assign) NSInteger gameRoomId;
/// (必须)本局游戏所使用的名片id
@property (nonatomic, copy, nullable) NSString *gameProfilesIdStr;
/// (非必须)游戏局id
@property (nonatomic, copy, nullable) NSString *gameBoardIdStr;
/// (非必须)聊天室id
@property (nonatomic, copy, nullable) NSString *groupIdStr;
/// (非必须)加入id
@property (nonatomic, assign, nullable) NSString *gameJoinIdStr;
@property (nonatomic, assign, nullable) NSString *ownerLogoUrl;
@property (nonatomic, assign, nullable) NSString *channelId;

@property (nonatomic, assign) BOOL loginUserIsRoomOwner;        ///< 当前登录用户是否为房主
@property (nonatomic, assign) BOOL loginUserIsInGame;           ///< 当前登录用户是否在游戏里
@property (nonatomic, assign) BOOL reachMaxPlayers;             ///< 房间人数是否已满
@property (nonatomic, assign) KKGameStatus gameStatus;          ///< 当前游戏状态

@property (nonatomic, copy, nullable) NSString *oldGameBoardIdStr;  ///< 上一次对局id, 用于取消订单
@property (nonatomic, copy, nullable) NSString *oldOrderNoStr;      ///< 标记上一次未完成订单号,用于取消倒计时

@property (nonatomic, copy, nullable) NSString *orderNoStr;         ///< 订单号

@property (nonatomic, assign) NSInteger depositPrice;               ///< 收费标准, 大于0表示收费局, 否则免费局
@property (nonatomic, assign) CGFloat kiperLimitTime;             ///< 请离限制时间

@property (nonatomic, strong, nullable) KKGameRoomInfoModel *infoModel; ///< 房间信息
@property (nonatomic, weak, nullable) KKGameBoardDetailSimpleModel *targetRemoveSimpleModel; ///< 当前选择要移除的玩家
@property (nonatomic, strong, nullable) KKGameBoardDetailSimpleModel *roomOwnerSimpleModel; ///< 房主
@property (nonatomic, strong, nullable) KKGameBoardDetailSimpleModel *currentSimpleModel; ///< 当前玩家(已上车)

@property (nonatomic, assign) NSInteger totalOnlinePeopleCount; ///< 总在线人数
@property (nonatomic, strong, nullable) NSArray<KKChatRoomUserSimpleModel *> *onlinePeopleArray; ///< 聊天室在线人数

@property (nonatomic, copy, nullable) NSString *shareURL;   ///< 分享链接

@property (nonatomic, assign) BOOL isCloseGameRoom;     ///< 是否关闭开黑房
@property (nonatomic, strong) NSMutableArray *onCarPeopleArray; ///<在车上的人
#pragma mark - Action

/// 离开 开黑房 间隔时间 配置查询
- (void)checkForLeaveGameRoomTimeConfigQuery;

/// 检查可否取消倒计时, force 是否强制取消
- (void)checkCancelCountDownEnable:(BOOL)force;

/// 尝试加入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock;

/// 退出开黑房
- (void)exitGameRoomWithSuccess:(void(^_Nullable)(void))successBlock;

#pragma mark - 处理数据
/// 处理开黑房数据
- (void)dealWithGameRoomInfoWith:(NSDictionary *_Nonnull)responseDic;

#pragma mark - 网络请求
- (void)requestForAll:(void(^_Nullable)(void))success;

/// 获取房间信息
- (void)requestForGameRoomDetailInfo;

/// 点击用户头像, 请求玩家信息
- (void)requestForPlayerHeaderIconWith:(NSIndexPath *_Nonnull)indexPath showCardBlock:(void(^_Nullable)(NSDictionary * _Nonnull responseDic))showBlock;

/// 加好友
- (void)requestForAddFriendWith:(NSString *_Nonnull)targetUserId;

/// 移除开黑房
- (void)requestForRemoveFromGameRoomWithUserId:(NSString *)userId gameBoardId:(NSString *)gameBoardId successsuccessBlock:(void(^)(void))successBlock;

/// 解散
- (void)requestForDissolveGameRoomSuccess:(void(^_Nullable)(void))successBlock;

/// '上车'/切换位置
- (void)requestForOccupySeat:(KKGameBoardDetailSimpleModel *_Nonnull)simpleModel status:(NSInteger)status success:(void(^_Nullable)(void))successBlock;

/// 点击'准备', 加入游戏
- (void)requestForGameTogether:(void(^_Nullable)(NSDictionary * _Nonnull responseDic))successBlock;

/// 游戏开始
- (void)requestForGameStart:(void(^_Nullable)(void))successBlock;

/// 游戏结束
- (void)requestForGameOver:(void(^_Nullable)(void))successBlock;

/// 离座
- (void)requestForCancelSeat:(void(^_Nullable)(void))resultBlock success:(void(^_Nullable)(void))successBlock;

/// 呼叫主持
- (void)requestForCallLed:(void(^_Nullable)(void))alertBlock;

/// 余额查询
- (void)requestForMyWalletInfo:(void(^_Nullable)(KKMyWalletInfo * _Nonnull myWallet))alertBlock;

/// 余额支付
- (void)requestForPayOrderNo:(void(^_Nullable)(void))successBlock;

/// 取消订单
- (void)requestForCancelOrderNo:(void(^_Nullable)(void))resultBlock success:(void(^_Nullable)(void))successBlock;

/// 加入聊天室
- (void)requestForJoinGameChatRoom:(void(^_Nullable)(void))successBlock;

/// 离开聊天室
- (void)requestForLeaveGameChatRoomSuccess:(void(^_Nullable)(void))successBlock;

/// 获取开黑房在线人数
- (void)requestForChatRoomOnlinePeople:(void(^_Nullable)(void))successBlock;

/// 请离限制时间查询
- (void)requestForOwnerKiperLimitTime;

// 游戏局未开始前自动结束时间配置查询
//- (void)requestForGameLeaveTimeConfig;

/// 进群查询
- (void)requestForIntoGameGroupWithWechat:(void(^_Nullable)(NSString * _Nullable urlStr))wechatBlock
                                       qq:(void(^_Nullable)(NSString * _Nullable urlStr))qqBlock;

/// 分享查询
- (void)requestForShareUrl;

/// 查询是否在聊天室
- (void)requestForIsInChatRoom:(void(^_Nullable)(BOOL isInCurrentChatRoom))successBlock;

/// 请他离队, 变成观众
- (void)requestPleaseLeavcTeamWithUserId:(NSString *)userId success:(void (^)(void))success fail:(void (^)(void))fail;
/// 禁言
- (void)requestGameBoardUserForbiddenWithUserId:(NSString *)userId gameBoardRoomId:(NSInteger)gameBoardRoomId Success:(void(^)(void))success;
/// 解开禁言
- (void)requestGameBoardUserNoForbiddenWithUserId:(NSString *)userId gameBoardRoomId:(NSInteger)gameBoardRoomId Success:(void(^)(void))success;
/// 禁言状态咨询
- (void)requestForbiddenStatusWithUserId:(NSString *)userId groupId:(NSString *)groupId success:(void(^)(NSInteger status))success;
@end

NS_ASSUME_NONNULL_END
