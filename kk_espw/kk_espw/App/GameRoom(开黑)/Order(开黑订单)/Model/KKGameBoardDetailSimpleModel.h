//
//  KKGameBoardDetailSimpleModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPlayerEvaluationProfileIdModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 开黑房中玩家信息
@interface KKGameBoardDetailSimpleModel : NSObject

@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *userHeaderImgUrl;
@property (nonatomic, copy, nullable) NSString *userName;
@property (nonatomic, copy, nullable) NSString *joinId;
@property (nonatomic, copy, nullable) NSString *profilesId;
@property (nonatomic, copy, nullable) NSString *gmtStopPay;     ///< 待支付玩家最晚支付时间
@property (nonatomic, strong, nullable) NSNumber *reliableScore;
@property (nonatomic, strong, nullable) NSNumber *deposit;
@property (nonatomic, strong, nullable) NSNumber *ownerGameBoardCount;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *sex;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *purchaseOrderPayStatusEnum;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *userProceedStatus;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *gameRank;

@property (nonatomic, strong, nullable) NSArray<KKGameStatusInfoModel *> *preferLocations;
@property (nonatomic, strong, nullable) NSArray<KKGameStatusInfoModel *> *gamePosition;
@property (nonatomic, strong, nullable) NSArray<KKPlayerEvaluationProfileIdModel *> *evaluationProfileIds;
@property (nonatomic, strong, nullable) NSArray<KKPlayerMedalDetailModel *> *medalDetailList;

@property (nonatomic, strong, nullable) NSString *playRoadString;  ///< 玩家本局游戏所玩位置
@property (nonatomic, assign) BOOL isRoomOwner;                    ///< 该玩家是否为房主

@end

NS_ASSUME_NONNULL_END
