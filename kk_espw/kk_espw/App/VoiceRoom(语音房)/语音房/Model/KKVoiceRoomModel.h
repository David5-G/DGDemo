//
//  KKVoiceRoomModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKVoiceRoomSimpleModel.h"
#import "KKVoiceRoomUserSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomModel : NSObject

///语音房详情simple
@property (nonatomic, strong) KKVoiceRoomSimpleModel *voiceRoom;

///当前用户 是否被禁言
@property (nonatomic, assign) BOOL isForbidChat;

///在线人数
@property (nonatomic, assign) NSInteger inChannelUserCount;

///最初进来的users
@property (nonatomic, strong) NSArray <KKVoiceRoomUserSimpleModel *>*firstJoinUsers;

@end

NS_ASSUME_NONNULL_END
