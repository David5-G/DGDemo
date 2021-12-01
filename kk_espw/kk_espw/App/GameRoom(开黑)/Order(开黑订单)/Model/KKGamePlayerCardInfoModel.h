//
//  KKGamePlayerCardInfoModel.h
//  kk_espw
//
//  Created by david on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKPlayerEvaluationProfileIdModel.h"


/// 最大显示的游戏局数
static NSInteger kk_player_max_game_count = 9999;
/// 最大显示的 评价次数 & 组队次数 & 好评次数
static NSInteger kk_player_max_game_time = 999;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - KKPlayerMedalLevelConfigModel
@interface KKPlayerMedalLevelConfigModel : NSObject
@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, copy, nullable) NSString *code;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *minValue;
@property (nonatomic, strong, nullable) NSNumber *maxIncreaseValueOfDay;
@property (nonatomic, strong, nullable) NSNumber *medalConfigId;
@property (nonatomic, strong, nullable) NSNumber *value;
@property (nonatomic, strong, nullable) NSNumber *decreaseValueOfOnce;
@property (nonatomic, strong, nullable) NSNumber *maxDecreaseValueOfDay;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, copy, nullable) NSString *gmtCreate;
@property (nonatomic, copy, nullable) NSString *gmtModified;
@end



#pragma mark - KKGamePlayerCardInfoModel
@interface KKGamePlayerCardInfoModel : NSObject
///目标用户
@property (nonatomic, copy, nullable) NSString *targetUserId;
///用户名
@property (nonatomic, copy, nullable) NSString *nickName;
///用户头像地址
@property (nonatomic, copy, nullable) NSString *userLogoUrl;
///年纪
@property (nonatomic, strong, nullable) NSNumber *age;
///性别
@property (nonatomic, strong, nullable) KKNameMsgModel *sex;
///是否好友
@property (nonatomic, assign) BOOL isFriend;
///是否禁言
@property (nonatomic, assign) BOOL forbidden;
///开黑次数
@property (nonatomic, strong, nullable) NSNumber *gameBoardCount;
///与我开黑次数
@property (nonatomic, strong, nullable) NSNumber *countWithTargetUser;
///我给的好评数
@property (nonatomic, strong, nullable) NSNumber *evaluationCountWithTargetUser;
///用户勋章
@property (nonatomic, strong, nullable) NSArray<KKPlayerMedalDetailModel *> *userMedalDetailList;
///勋章配置
@property (nonatomic, strong, nullable) NSArray<KKPlayerMedalLevelConfigModel *> *medalLevelConfigList;
@end




NS_ASSUME_NONNULL_END
