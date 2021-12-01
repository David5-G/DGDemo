//
//  KKGameOrderTagDetailModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameStatusInfoModel.h"
#import "KKGameBoardDetailSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - KKGameUserGameTagModel
/// 玩家评价标签
@interface KKGameUserGameTagModel : NSObject

@property (nonatomic, assign) NSInteger gameTagCount;
@property (nonatomic, assign) NSInteger orderNumber;
@property (nonatomic, assign) NSInteger gameTagId;
@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *tagCode;

@end








#pragma mark - KKGameOrderDetailMemoModel
/// 订单描述
@interface KKGameOrderDetailMemoModel : NSObject

@property (nonatomic, copy, nullable) NSString *memo;

@end








#pragma mark - KKGameOrderTagDetailModel
/// 本局游戏别人对我的评价model
@interface KKGameOrderTagDetailModel : NSObject

@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *platFormType;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *depositType;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *gameBoardRank;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *proceedStatus;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *patternType;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *payType;

@property (nonatomic, strong, nullable) KKGameOrderDetailMemoModel *properties;

@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *ownerUserLogoUrl;
@property (nonatomic, copy, nullable) NSString *ownerUserId;
@property (nonatomic, copy, nullable) NSString *gameBoardId;
@property (nonatomic, copy, nullable) NSString *orderNo;    ///< 订单号
@property (nonatomic, copy, nullable) NSString *gmtEvaluateStart; ///< 评价开始时间
@property (nonatomic, copy, nullable) NSString *gmtEvaluateEnd; ///< 评价结束时间
@property (nonatomic, copy, nullable) NSString *gmtStopPay;     ///< 最晚支付时间
@property (nonatomic, copy, nullable) NSString *gameGmtStart; ///< 游戏开始时间
@property (nonatomic, copy, nullable) NSString *purchaseCreate; ///< 订单创建时间
@property (nonatomic, copy, nullable) NSString *purchaseEnd;    ///< 订单关闭时间
@property (nonatomic, copy, nullable) NSString *gmtPay; ///< 支付时间

@property (nonatomic, assign) NSInteger deposit;            ///< 价格
@property (nonatomic, assign) NSInteger gameDeposit;        ///< 本局收费单价
@property (nonatomic, assign) NSInteger purchaseDeposit;    ///< 够买
@property (nonatomic, assign) NSInteger gameRoomId;
@property (nonatomic, assign) NSInteger redemption; ///< 赎回

@property (nonatomic, assign) NSInteger autoDissolutionTimeConfig;  ///< 自动解散时间配置
@property (nonatomic, assign) NSInteger allowFinishTimeConfig;      ///< 最小结束时间配置

@property (nonatomic, strong, nonnull) NSArray<KKGameStatusInfoModel *> *ownerPosition;
@property (nonatomic, strong, nonnull) NSArray<KKGameUserGameTagModel *> *userGameTag; ///< 评价标签list
@property (nonatomic, strong, nonnull) NSArray<KKGameBoardDetailSimpleModel *> *dataList;

@end


NS_ASSUME_NONNULL_END
