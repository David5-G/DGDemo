//
//  KKGamePrice.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKUserMedelInfo;
NS_ASSUME_NONNULL_BEGIN
/*
 {
 "response" : {
 "jumpLogin" : 0,
 "nowTimestamp" : 1563964020126,
 "gameBoardPrice" : 5,
 "success" : 0,
 "medalAndLevelCode" : "GAME_GOD_MEDALGOD_V1",
 "maxPrice" : 10,
 "nowDate" : "2019-07-24 18:27:00",
 "userGameBoardPriceConfigId" : "4004982703255315990000005451",
 "minPrice" : 0
 }
 }
 */
@interface KKGamePrice : NSObject
@property (nonatomic, copy) NSString *maxPrice;
@property (nonatomic, copy) NSString *minPrice;
@property (nonatomic, copy) NSString *gameBoardPrice;
@property (nonatomic, strong) KKUserMedelInfo *userMedalDetail;
@property (nonatomic, copy) NSString *userGameBoardPriceConfigId;

@end

NS_ASSUME_NONNULL_END
