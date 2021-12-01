//
//  KKGameStatusInfoModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 游戏状态
typedef NS_ENUM(NSInteger, KKGameStatus) {
    KKGameStatusPlayerEnter = 0,            ///< 玩家进入房间
    KKGameStatusPlayerJoin = 1,             ///< 用户上车了
    KKGameStatusPlayerUnPay = 2,            ///< 用户待支付
    KKGameStatusPlayerReadied = 3,          ///< 用户已准备
    KKGameStatusAllPlayerReadied = 4,       ///< 所有玩家准备就绪
    KKGameStatusInPlaying = 5,              ///< 游戏进行中
    KKGameStatusGameOver = 6,               ///< 游戏结束
    KKGameStatusGameCancel = 7,             ///< 游戏关闭
    KKGameStatusGameFailSold = 8,           ///< 游戏流标
};

NS_ASSUME_NONNULL_BEGIN

/// 状态信息
@interface KKGameStatusInfoModel : NSObject

@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, copy, nullable) NSString *message;

@end

NS_ASSUME_NONNULL_END
