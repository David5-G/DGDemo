//
//  KKAboutMySkillService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKGamePrice;
NS_ASSUME_NONNULL_BEGIN
typedef void(^requestGamePriceBlockSuccess)(KKGamePrice *price);
typedef void(^requestGamePriceBlockFail)(void);
typedef void(^requestUpdatePriceBlockSuccess)(void);
typedef void(^requestUpdatePriceBlockFail)(void);

@interface KKAboutMySkillService : NSObject
@property (nonatomic, copy) requestGamePriceBlockSuccess requestGamePriceBlockSuccess;
@property (nonatomic, copy) requestGamePriceBlockFail requestGamePriceBlockFail;
@property (nonatomic, copy) requestUpdatePriceBlockSuccess requestUpdatePriceBlockSuccess;
@property (nonatomic, copy) requestUpdatePriceBlockFail requestUpdatePriceBlockFail;


/**
 游戏局价格Id
 */
@property (nonatomic, copy) NSString *userGameBoardPriceConfigId;

/**
 修改的价格
 */
@property (nonatomic, copy) NSString *modifiPrice;

/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 请求游戏局价格
 
 @param success success
 @param fail fail
 */
+ (void)requestGamePriceSuccess:(requestGamePriceBlockSuccess)success Fail:(requestGamePriceBlockFail)fail;


/**
 修改游戏价格

 @param success success
 @param fail fail
 */
+ (void)requestUpdatePriceSuccess:(requestUpdatePriceBlockSuccess)success Fail:(requestUpdatePriceBlockFail)fail;


@end

NS_ASSUME_NONNULL_END
