//
//  KKChatRoomMicPositionMsg.h
//  kk_espw
//
//  Created by david on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

/*! 招募厅状态消息的类型名 */
#define KKChatRoomMicPositionMsgId @"KK:MPChangeMsg"

@interface KKChatRoomMicPositionMsg : RCMessageContent
/**
 * CARRY => 抱麦 *
 * LOCK => 锁麦
 * UNLOCK => 解锁麦
 * FORBIDDEN => 禁麦
 * UNFORBIDDEN => 解禁
 * KICK => 踢麦
 * UP => 上麦 *
 * DOWN => 下麦 *
 * CHANGE => 跳麦
 */
@property (nonatomic, copy) NSString *micChangeType;

@property (nonatomic, copy) NSString *fromChangeUserId;
@property (nonatomic, copy) NSString *toChangeUserId;
@property (nonatomic, copy) NSString *extra;

@end

NS_ASSUME_NONNULL_END
