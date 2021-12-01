//
//  KKGameChargeToolView.h
//  kk_espw
//
//  Created by hsd on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KKGameChargeToolViewTapType) {
    KKGameChargeToolViewTapTypeBackground = 0,  ///< 点击背景
    KKGameChargeToolViewTapTypeCancel = 1,      ///< 点击取消
    KKGameChargeToolViewTapTypeCharge = 2,     ///< 充值
    KKGameChargeToolViewTapTypeCertain = 3,    ///< 确定
};

NS_ASSUME_NONNULL_BEGIN

@interface KKGameChargeToolView : UIView

/// 头像
@property (nonatomic, strong, nonnull, readonly) UIImageView *iconImgView;

@property (nonatomic, copy, nullable) void(^tapBlock)(KKGameChargeToolViewTapType tapType);

/**
 初始化
 @param safeBottom 底部安全距离
 */
- (instancetype)initWithSafeBottom:(CGFloat)safeBottom;

/// 设置昵称
- (void)setNickNameString:(NSString * _Nullable)nick;


/**
 设置余额
 @param balance 余额
 @param unitString 单位, 可空, 默认'K币'
 */
- (void)setBalanceCoinString:(NSString * _Nullable)balance unit:(NSString * _Nullable)unitString;

/**
 设置支付金额
 @param chargeCoin 支付金额
 @param unitString 单位, 可空, 默认'K币'
 */
- (void)setChargeToGameRoomOwner:(NSString * _Nonnull)chargeCoin unit:(NSString * _Nullable)unitString;

/// 显示
- (void)showIn:(UIView * _Nullable)inView;

/// 移除
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
