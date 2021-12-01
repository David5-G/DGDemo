//
//  KKFloatGameRoomView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "DGFloatButton.h"
NS_ASSUME_NONNULL_BEGIN
@class KKFloatGameRoomModel;
@class KKFloatVoiceRoomModel;
typedef void(^tapCloseGameRoomBlock)(void);

@interface KKFloatGameRoomView : DGFloatButton
/// 游戏局id
@property (nonatomic, copy, nullable) NSString *gameBoardIdStr;

/// 开黑房id
@property (nonatomic, assign) int gameRoomIdStr;

/// 聊天室id
@property (nonatomic, copy, nullable) NSString *groupIdStr;

/// 本局游戏所使用的名片id
@property (nonatomic, copy, nullable) NSString *gameProfilesIdStr;
/// 关闭开黑房
@property (nonatomic, copy) tapCloseGameRoomBlock tapCloseGameRoomBlock;
/// 数据
@property (nonatomic, strong) KKFloatGameRoomModel *gameModel;
@property (nonatomic, strong) KKFloatVoiceRoomModel *voiceModel;

/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 展示
 */
- (void)showKhSuspendedView;

/**
 移除
 */
- (void)removeKhSuspendedView;

/**
 销毁
 */
+ (void)destroyInstance;


@end

NS_ASSUME_NONNULL_END
