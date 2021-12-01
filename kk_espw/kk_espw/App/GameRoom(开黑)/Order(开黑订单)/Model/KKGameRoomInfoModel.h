//
//  KKGameRoomPlayerInfoModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/1.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
#import "KKGameStatusInfoModel.h"
#import "KKGameBoardClientSimpleModel.h"
#import "KKGamePlayerCardInfoModel.h"
#import "KKGameBoardDetailSimpleModel.h"
#import "KKPlayerEvaluationProfileIdModel.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - KKGameRoomInfoModel
/// 开黑房(房间+玩家)信息
@interface KKGameRoomInfoModel : NSObject

@property (nonatomic, copy, nonnull) NSString *userId;           ///< 用户id
@property (nonatomic, copy, nonnull) NSString *userLogoUrl;      ///< 头像
@property (nonatomic, copy, nonnull) NSString *nickName;         ///< 昵称
@property (nonatomic, copy, nonnull) NSString *groupId;          ///< 聊天室id
@property (nonatomic, copy, nonnull) NSString *baseUserLogoUrl;  ///< 基础头像地址
@property (nonatomic, copy, nullable) NSString *currentUserPurchaseNo; ///< 订单号

@property (nonatomic, assign) CGFloat allowFinishTimeConfig;           ///< 最短游戏结束时间
@property (nonatomic, assign) CGFloat autoDissolutionTimeConfig;        ///< 自动解散游戏时间时间

@property (nonatomic, strong, nonnull) KKGameBoardClientSimpleModel *gameBoardClientSimple; ///< 房间信息
@property (nonatomic, strong, nonnull) NSArray<KKGameBoardDetailSimpleModel *> *gameBoardDetailSimpleList;      ///< 开黑房玩家信息列表

@end



NS_ASSUME_NONNULL_END
