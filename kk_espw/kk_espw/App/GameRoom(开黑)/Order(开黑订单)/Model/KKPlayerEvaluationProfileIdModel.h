//
//  KKPlayerEvaluationProfileIdModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameStatusInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - KKPlayerEvaluationProfileIdModel
/// 玩家标签
@interface KKPlayerEvaluationProfileIdModel : NSObject

@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *profilesId;
@property (nonatomic, strong, nullable) NSNumber *evaluationNum;
@property (nonatomic, strong, nullable) NSNumber *tagId;
@property (nonatomic, copy, nullable) NSString *tagCode;
@property (nonatomic, copy, nullable) NSString *gmtCreate;
@property (nonatomic, copy, nullable) NSString *gmtModified;
@property (nonatomic, strong, nullable) KKGameStatusInfoModel *type;

@end


#pragma mark - KKPlayerMedalDetailModel
/// 玩家勋章
@interface KKPlayerMedalDetailModel : NSObject

@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *currentMedalLevelConfigCode;
@property (nonatomic, strong, nullable) NSNumber *currentMedalLevelConfigId;
@property (nonatomic, strong, nullable) NSNumber *areaId;
@property (nonatomic, copy, nullable) NSString *adornBizId;
@property (nonatomic, strong, nullable) KKNameMsgModel *status;
@property (nonatomic, strong, nullable) NSNumber *currentValue;
@property (nonatomic, strong, nullable) NSNumber *maxMedalLevelValue;
@property (nonatomic, strong, nullable) NSNumber *medalConfigId;
@property (nonatomic, copy, nullable) NSString *medalConfigCode;
@property (nonatomic, copy, nullable) NSString *gmtExpired;
@property (nonatomic, copy, nullable) NSString *gmtAward;
@property (nonatomic, assign) BOOL adorned;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy, nullable) NSString *gmtCreate;
@property (nonatomic, copy, nullable) NSString *gmtModified;
@property (nonatomic, copy, nullable) NSString *gmtAdorned;
@end

NS_ASSUME_NONNULL_END
