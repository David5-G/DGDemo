//
//  KKRtcService.h
//  kk_espw
//
//  Created by david on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongRTCLib/RongRTCLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRtcService : NSObject

#pragma mark - life circle
+ (instancetype)shareInstance;
- (void)remove;


#pragma mark - rtc
/** 当前加入的 rtc房间 (当加入房间成功之后，才会是有效值 */
@property (nonatomic, strong, readonly) RongRTCRoom *rtcRoom;

/** 关闭所有声音 */
@property (nonatomic, assign) BOOL muteAllVoice;

/** 设置 直播间代理 */
- (void)setRTCRoomDelegate:(id<RongRTCRoomDelegate>)delegate;

/** 设置 直播间引擎代理 */
- (void)setRTCEngineDelegate:(id<RongRTCActivityMonitorDelegate>)delegate;


#pragma mark 加入/退出
/** 加入直播间 */
- (void)joinRoom:(NSString *)roomId success:(void (^)( RongRTCRoom *room))success error:(void (^)(RongRTCCode code))error;

/** 退出直播间 */
- (void)leaveRoom:(NSString*)roomId success:(void (^)(void))success error:(void (^)(RongRTCCode code))error;


#pragma mark  音频流
/** 发布 音视频流 */
- (void)pulishCurrentUserAudioStream;

/** 取消发布 音视频流 */
- (void)unpublishCurrentUserAudioStream;

/** 订阅 远端音频stream */
- (void)subscribeRemoteUserAudioStream:(NSString *)userId;

/** 取消订阅 远端音频stream */
- (void)unsubscribeRemoteUserAudioStream:(NSString *)userId;


#pragma mark 麦克风/扬声器
/** 设置麦克风 是否可用 */
- (void)setMicrophoneDisable:(BOOL)disable;


@end

NS_ASSUME_NONNULL_END
