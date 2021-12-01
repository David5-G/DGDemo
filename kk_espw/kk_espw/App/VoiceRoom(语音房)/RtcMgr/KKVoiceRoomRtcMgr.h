//
//  KKVoiceRoomRtcMgr.h
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomRtcMgr : NSObject


#pragma mark - life circle
+ (instancetype)shareInstance;

#pragma mark - service
/** 请求 进入语音房
 *  先加入rtc,再请求后台的加入接口
 */
-(void)requestJoinRoom:(NSString *)roomId channel:(NSString *)channelId success:(void(^)(void))success;

/** 请求 离开语音房
 *  先离开rtc, 再请求后台的离开接口
 */
-(void)requestLeaveRoom:(NSString *)roomId channel:(NSString *)channelId success:(void(^)(void))success;

/** 请求 离开rtc语音房 */
-(void)requestLeaveRtcRoomByLoginElse:(void( ^ _Nullable )(void))success;


/** 请求 房间状态,允许进入才回调block */
-(void)checkRoomStatus:(NSString *)roomId success:(void(^)(void))success;


#pragma mark - tool
/** 是否加入了某房间 */
-(BOOL)isJoinedRoom:(NSString *)roomId channel:(NSString *)channelId;

@end

NS_ASSUME_NONNULL_END
