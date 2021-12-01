//
//  KKLiveStudioGameRoomSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/8/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioGameRoomSimpleModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger male;

@property (nonatomic, assign) NSInteger female;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *gameRoomId;

@property (nonatomic, copy) NSString *gameBoardId;

@property (nonatomic, copy) NSString *gmtRecommendedDue;

/**
 * QQ => QQ
 * WE_CHART => 微信
 */
@property (nonatomic, strong) KKNameMsgModel *platformType;

/**
 * 枚举字段如下：
 * BRONZE => 青铜
 * SILVER => 白银
 * GOLD => 黄金
 * PLATINUM => 铂金
 * DIAMOND => 钻石
 * STARSHINE => 星耀
 * KING => 王者
 * GLORY => 荣耀
 */
@property (nonatomic, strong) KKNameMsgModel *rank;

/**
 * MULTI_PLAYER_TEAM_ONE => 双人模式
 */
@property (nonatomic, strong) KKNameMsgModel *patternType;

@end

NS_ASSUME_NONNULL_END
