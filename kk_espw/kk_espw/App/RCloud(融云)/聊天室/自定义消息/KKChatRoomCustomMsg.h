//
//  KKChatRoomCustomMsg.h
//  kk_espw
//
//  Created by 阿杜 on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

/*!
 招募厅状态消息的类型名
 */
#define KKChatRoomGameStatusMessageTypeIdentifier @"KK:RCCMsg"


@interface KKChatRoomCustomMsg : RCMessageContent

@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *chatroomId;
@property (nonatomic, copy) NSString *content;

/**
 * ANCHOR_MIC_CLOSE => 主播关闭麦克风
 * ANCHOR_MIC_OPEN => 主播打开麦克风
 *
 * ESPW_ROOM_REFRESH_TYPE  => 开黑房状态改变
 * ESPW_SPECIAL_MSG_TYPE => 广播找人
 */
@property (nonatomic, copy) NSString *msgType;

/**
 * 如果是:ESPW_SPECIAL_MSG_TYPE => 广播找人
 * @"gameboardId,roomId" (两个id以逗号区分)
 *
 */
@property (nonatomic, copy) NSString *extra;

+ (instancetype)messageWithChatRoomId:(NSString *)chatroomId content:(NSString *)content withUserId:(NSString *)userId msgType:(NSString *)msgType;

@end


