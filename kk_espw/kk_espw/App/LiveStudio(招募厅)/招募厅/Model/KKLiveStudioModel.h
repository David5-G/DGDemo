//
//  KKLiveStudioModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKLiveStudioSimpleModel.h"
#import "KKChatRoomUserSimpleModel.h"

@class
KKLiveStudioChatRoomSimpleModel;

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioModel : NSObject

///直播间信息
@property (nonatomic, strong) KKLiveStudioSimpleModel *studio;

///麦上用户
@property (nonatomic, strong) KKChatRoomUserSimpleModel *micUser;

///最早加入的用户 
@property (nonatomic, strong) NSArray <KKChatRoomUserSimpleModel *> *firstJoinUsers;

///主播
@property (nonatomic, strong) KKChatRoomUserSimpleModel *host;

///聊天室信息 
@property (nonatomic, strong) KKLiveStudioChatRoomSimpleModel *chatRoom;

@end


/// 聊天室信息
@interface KKLiveStudioChatRoomSimpleModel : NSObject

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *ownerType;//CHANNEL

@property (nonatomic, copy) NSString *ownerId;

@end

NS_ASSUME_NONNULL_END
