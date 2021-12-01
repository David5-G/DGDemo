//
//  KKSuspenViewManager.h
//  kk_espw
//
//  Created by 景天 on 2019/8/9.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKFloatLiveStudioView;
@class KKFloatGameRoomView;
@class KKHomeRoomListInfo;
NS_ASSUME_NONNULL_BEGIN


typedef void(^tapedExitRecruitBlock)(void);
typedef void(^tapedExitGameBoardBlock)(void);

@interface KKSuspenViewManager : NSObject
+ (instancetype)shareInstance;

/// 点击了退出招募厅的Block
@property (nonatomic, copy) tapedExitRecruitBlock tapedExitRecruitBlock;
/// 点击退出了游戏局
@property (nonatomic, copy) tapedExitGameBoardBlock tapedExitGameBoardBlock;

/**
 赋值
 
 @param recruitName 招募厅名字
 @param compereName 主持人名字
 @param compereHeadUrl 主持人头像
 
 */

+ (void)setRecruitName:(NSString *)recruitName compereName:(NSString *)compereName compereHeadUrl:(NSString *)compereHeadUrl;

/**
 是否在招募厅

 @return yes
 */
+ (BOOL)isJoinLiveStudio;


/**
 是否加入了开黑房

 @return yes
 */
+ (BOOL)isJoinGameBoard;

/**
 展示招募厅浮窗

 @param complete 点击方法回调
 @param complete 关闭方法回调

 */
+ (void)showRecruitViewComplete:(void(^)(void))complete closeBlock:(void(^)(void))closeBlock;



/**
 展示开黑进行中

 @param complete 点击方法回调
 */
+ (void)showGameBoardViewComplete:(void(^)(void))complete;


/**
 隐藏开黑进行中
 */
+ (void)hideKHGameBoardView;

/**
 隐藏招募厅
 */
+ (void)hideRecruitView;
@end

NS_ASSUME_NONNULL_END
