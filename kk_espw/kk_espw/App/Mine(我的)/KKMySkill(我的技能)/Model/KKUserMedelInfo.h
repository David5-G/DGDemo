//
//  KKUserMedelInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/25.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKUserMedelInfo : NSObject
/*
 "id" : "10034004982703216612680980080526",
 "adornBizId" : "10034004936981048100290980081957_1",
 "areaId" : 121061,
 "adorned" : 1,
 "gmtAdorned" : "2019-07-24 16:50:32",
 "currentMedalLevelConfigCode" : "GOD_V1",
 "currentValue" : 0,
 "medalConfigCode" : "GAME_GOD_MEDAL",
 "gmtCreate" : "2019-07-24 16:50:32",
 "gmtExpired" : "2119-06-30 16:50:32",
 "gmtModified" : "2019-07-24 16:50:32",
 "userId" : "10034004936981048100290980081957",
 "currentMedalLevelConfigId" : 40017,
 "maxMedalLevelValue" : -1,
 "gmtAward" : "2019-07-24 16:50:32",
 "medalConfigId" : 70001,
 "enabled" : 1,
 "status" : {
 "name" : "NORMAL",
 "message" : "普通"
 }
 }
 */
@property (nonatomic, copy) NSString *currentMedalLevelConfigCode;
@end

NS_ASSUME_NONNULL_END
