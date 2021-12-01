//
//  KKPlayerCardCollectionCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGameRoomInfoModel.h"

/// 交互状态
typedef NS_ENUM(NSInteger, KKPlayerCardUserActionStatus) {
    KKPlayerCardUserActionStatusOccupy = 1,     ///< 上车
    KKPlayerCardUserActionStatusSwitch = 2,   ///< 切换位置
};

NS_ASSUME_NONNULL_BEGIN

/// 玩家准备时的卡片
@interface KKPlayerCardCollectionCell : UICollectionViewCell

@property (nonatomic, copy, nullable) void(^tapPrepareBlock)(KKGameBoardDetailSimpleModel * _Nonnull simpleModel, KKPlayerCardUserActionStatus actionStatus); ///< 点击"上车"回调

@property (nonatomic, strong, nullable) KKGameBoardDetailSimpleModel *dataModel;    ///< 数据源
@property (nonatomic, assign) BOOL loginUserIsRoomOwner;        ///< 当前登录用户是否为房主
@property (nonatomic, assign) BOOL loginUserIsInGame;           ///< 当前登录用户是否已经在玩家列表
@property (nonatomic, assign) BOOL loginUserIsPrepare;          ///< 当前登录用户是否已准备
@property (nonatomic, assign) BOOL forceHiddenJoinBtn;          ///< 强制隐藏上车按钮
@property (nonatomic, assign) BOOL reachMaxPlayers;             ///< 人数是否已满
@property (nonatomic, assign) BOOL isSpeaking;             ///< 是否开启动画
@end

NS_ASSUME_NONNULL_END
