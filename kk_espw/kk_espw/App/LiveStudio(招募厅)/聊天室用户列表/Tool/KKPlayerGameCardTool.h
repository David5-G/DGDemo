//
//  KKPlayerGameCardTool.h
//  kk_espw
//
//  Created by david on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
NS_ASSUME_NONNULL_BEGIN
@class KKPlayerGameCardTool;
@protocol KKPlayerGameCardToolDelagate <NSObject>
-(void)playerGameCardTool:(KKPlayerGameCardTool *)tool handleMsg:(NSString *)msg targetUserId:(NSString *)targetUserId;
@end



#pragma mark - 
@interface KKPlayerGameCardTool : NSObject

+(instancetype)shareInstance;

/** 是否禁止 tap点击背景调dismiss */
@property (nonatomic, assign) BOOL forbidTapBgDismiss;

/** 下麦自定义title */
@property (nonatomic, copy) NSString *hostMicQuitTitle;

/** 展示用户卡片信息 */
-(void)showUserInfo:(NSString *)userId
             roomId:(NSString *)roomId
           needKick:(BOOL)needKick
        isHostCheck:(BOOL)isHostCheck
            isOnMic:(BOOL)isOnMic
           delegate:(id<KKPlayerGameCardToolDelagate>)delegate;

/** 展示用户卡片信息
 * @param userId  用户id
 * @param roomId  所在房间的id
 * @param needKick 是否需要 踢出房间
 * @param isHostCheck 是否是主播/房主查看
 * @param isForGame 是否是用于game (=NO代表用于语音的麦位)
 * @param isOn 是否在位置上(game:开黑是否上车, mic: 是否上麦)
 * @param delegate 执行回调的block
 */
-(void)showUserInfo:(NSString *)userId
             roomId:(NSString *)roomId
           needKick:(BOOL)needKick
        isHostCheck:(BOOL)isHostCheck
          isForGame:(BOOL)isForGame
               isOn:(BOOL)isOn
           delegate:(id<KKPlayerGameCardToolDelagate>)delegate;


#pragma mark - jump
-(void)pushToGameReportVC:(NSString *)userId;


@end

NS_ASSUME_NONNULL_END
