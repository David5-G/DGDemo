//
//  KKGameRoomBaseController.h
//  kk_espw
//
//  Created by hsd on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"
#import "KKGameScrollView.h"

@class KKGamePrepareToolView;
//@class KKGameChatInputView;
@class KKVoiceRoomInputView;
@class KKLiveStudioOnlineUserView;

NS_ASSUME_NONNULL_BEGIN

/// 开黑房基类, 使用时全部为其子类
@interface KKGameRoomBaseController : BaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, KKGameScrollViewDelegate>

#pragma mark - init params
/// (必须)开黑房id
@property (nonatomic, assign) NSInteger gameRoomId;

/// (必须)本局游戏所使用的名片id
@property (nonatomic, copy, nullable) NSString *gameProfilesIdStr;;

/// (非必须)游戏局id
@property (nonatomic, copy, nullable) NSString *gameBoardIdStr;

/// (非必须)聊天室id
@property (nonatomic, copy, nullable) NSString *groupIdStr;


#pragma mark - UI
#pragma mark navi
/// 导航栏背景图
@property (nonatomic, strong, nonnull) UIView *navView;

/// 右上角关闭按钮
@property (nonatomic, strong, nullable) CC_Button *navCloseBtn;

/// 右上角在线人数
@property (nonatomic, strong, nullable) KKLiveStudioOnlineUserView *studioOnlineUserView;

/// 返回按钮
@property (nonatomic, strong, nonnull) CC_Button *navBackBtn;

#pragma mark bg 导航下的展示superview
/// 背景滚动视图, 是 gameSuperView 的 父视图
@property (nonatomic, strong, nonnull) KKGameScrollView *backgroundScrollView;

/// 游戏父视图(暗色整个)
@property (nonatomic, strong, nonnull) UIView *gameSuperView;

/// 背景logo
@property (nonatomic, strong, nonnull) UIImageView *gameLogoImageView;

#pragma mark 局信息
/// 玩家等级
@property (nonatomic, strong, nonnull) UILabel *playerLevelLabel;

/// 横条状logo
@property (nonatomic, strong, nonnull) UIImageView *seperateLogoImageView;

/// 几人模式
@property (nonatomic, strong, nonnull) UILabel *playerNumberLabel;

/// 是否收费
@property (nonatomic, strong, nonnull) UILabel *chargeLabel;

/// 右侧大宝剑logo
@property (nonatomic, strong, nonnull) UIImageView *rightGameLogoImageView;

/// 本局游戏进行状态
@property (nonatomic, strong, nonnull) UILabel *gameStateLabel;

#pragma mark 玩家
/// 玩家准备列表
@property (nonatomic, strong, nullable) UICollectionView *playerListView;

/// 展示房间公告和 准备/离座 信息
@property (nonatomic, strong, nullable) KKGamePrepareToolView *prepareToolView;

#pragma mark 输入条
/// 聊天栏
@property (nonatomic, strong, nullable) KKVoiceRoomInputView *chatToolView;



#pragma mark - method
/// 创建中间 准备/离开/...视图
- (void)p_initPrepareView;

/// 创建聊天框
- (void)p_initChatToolView;

/// 创建开黑列表
- (void)p_initPlayerListView;

/// 创建导航栏右侧视图
- (void)p_initNavRightView;

/// 点击返回按钮
- (void)p_clickNavBackButton;

/// 点击关闭按钮
- (void)p_clickNavCloseButton;

/// 点击在线人数视图
- (void)p_clickStudioOnlineView;

@end

NS_ASSUME_NONNULL_END
