//
//  KKGameBoardClientSimpleModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameStatusInfoModel.h"
#import "KKCreateGameUserCardModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 开黑房信息
@interface KKGameBoardClientSimpleModel : NSObject

/* preceedStatus 有以下几种状态
 INIT => 待支付
 RECRUIT => 招募中
 PROCESSING => 比赛中
 EVALUATE => 待评价
 FINISH => 已完成
 CANCEL => 关闭
 FAIL_SOLD => 流标
 */

@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, copy, nullable) NSString *ownerUserId;
@property (nonatomic, copy, nullable) NSString *ownerUserlogoUrl;
@property (nonatomic, assign) NSInteger gameRoomId;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, strong, nonnull) NSNumber *gameId;
@property (nonatomic, strong, nullable) NSNumber *deposit;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *boardType;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *proceedStatus;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *platformType;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *rank;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *patternType;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *depositType;

@property (nonatomic, strong, nullable) NSArray<KKGameStatusInfoModel *> *ownerPosition;
@property (nonatomic, strong, nullable) NSArray<KKCreateGameUserCardModel *> *dataList;

@property (nonatomic, copy, nullable) NSString *gmtCreate;
@property (nonatomic, copy, nullable) NSString *gmtModified;
@property (nonatomic, copy, nullable) NSString *maxGmtPay;
@property (nonatomic, copy, nullable) NSString *gmtBoardStart;
@property (nonatomic, copy, nullable) NSString *gmtBoardEnd;
@property (nonatomic, copy, nullable) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
