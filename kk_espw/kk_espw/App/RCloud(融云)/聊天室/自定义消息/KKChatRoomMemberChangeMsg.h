//
//  KKChatRoomMemberChangeMsg.h
//  kk_espw
//
//  Created by david on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

NS_ASSUME_NONNULL_BEGIN

/*! 聊天室成员变化 自定义消息 */
#define KKChatRoomMemberChangeMsgId @"KK:RMChangeMsg"

@interface KKChatRoomMemberChangeMsg : RCMessageContent
/**
 * JOIN => 加入
 * LEAVE => 退出
 * KICK => 踢出
 */
@property (nonatomic, copy) NSString *changeType;
@property (nonatomic, copy) NSString *changeUserId;
@end

NS_ASSUME_NONNULL_END
