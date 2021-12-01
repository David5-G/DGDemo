//
//  KKVoiceRoomSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKVoiceRoomMicPSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomSimpleModel : NSObject

///语音室的id
@property (nonatomic, copy) NSString *idStr;

///聊天室的id
@property (nonatomic, copy) NSString *channelId;

@property (nonatomic, copy) NSString *ownerUserId;

@property (nonatomic, copy) NSString *ownerUserLoginName;

@property (nonatomic, strong) NSString *ownerUserLogoUrl;

@property (nonatomic, copy) NSString *chatRoomTitle;

@property (nonatomic, strong) KKNameMsgModel *roomStatus;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, copy) NSString *gmtCreate;

@property (nonatomic, copy) NSString *gmtModified;

@property (nonatomic, strong) NSArray <KKVoiceRoomMicPSimpleModel *>*micPSimples;

@end

NS_ASSUME_NONNULL_END
