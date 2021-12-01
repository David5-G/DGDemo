//
//  KKChatRoomConversationViewController.h
//  kk_espw
//
//  Created by 阿杜 on 2019/8/8.
//  Copyright © 2019 david. All rights reserved.
//




///通知: 开黑房状态改变
#define REFRESH_GAME_BOARD_ROOM_NOTIFICATION @"REFRESH_GAME_BOARD_ROOM_NOTIFICATION"
///通知: 聊天室成员变化
#define CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION @"CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION"
///通知: 直播间麦位变化
#define LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION @"LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION"
///通知: 直播间 主播mic变化
#define LIVE_STUDIO_HOST_MIC_CHANGE_NOTIFICATION @"LIVE_STUDIO_HOST_MIC_CHANGE_NOTIFICATION"



typedef NS_ENUM(NSUInteger, KKChatRoomTableVCThemeStyle) {
    KKChatRoomTableVCThemeStyleDefault,//默认,cell白色背景
    KKChatRoomTableVCThemeStyleDark,//深色模式,cell透明背景,内容label黑色背景且带圆角
};


#pragma mark -

#import <UIKit/UIKit.h>
#import "KKChatRoomMessage.h"

NS_ASSUME_NONNULL_BEGIN
@class KKChatRoomTableVC;
@protocol KKChatRoomTableVCDelegate <NSObject>
@optional
-(void)chatRoom:(KKChatRoomTableVC *)chatRoomTableVC didSelectMsg:(KKChatRoomMessage *)msg;
-(void)chatRoomWillBeginDragging:(KKChatRoomTableVC *)chatRoomTableVC;
@end


@interface KKChatRoomTableVC : UITableViewController

/** 带UI样式初始化 */
-(instancetype)initWithThemeStyle:(KKChatRoomTableVCThemeStyle)themeStyle;

/** 目标会话ID */
@property(nonatomic, copy, nonnull) NSString *targetId;

/** 代理 */
@property (nonatomic, weak) id<KKChatRoomTableVCDelegate>delegate;

/** 发送消息 */
-(void)sendTextMsg:(NSString *)text success:(void (^)(long messageId))successBlock error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock;

/** 退出聊天室 */
-(void)quitChatRoomSuccess:(void (^_Nullable)(void))successBlock error:(void (^_Nullable)(RCErrorCode status))errorBlock;

/** 清空聊天列表 */
-(void)cleanHistoryMessages;

@end

NS_ASSUME_NONNULL_END
