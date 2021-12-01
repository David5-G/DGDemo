//
//  KKLiveStudioMicRankPopVC.h
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBasePopVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomMicRankPopVC : KKChatRoomUserListBasePopVC

/** 是否是 正在排麦 */
@property (nonatomic, assign,getter=isRanking) BOOL ranking;

/** 是否是 正在正麦位 */
@property (nonatomic, assign) BOOL isOnMic;

@end

NS_ASSUME_NONNULL_END
