//
//  KKChatRoomUserSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKChatRoomMetalSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomUserSimpleModel : NSObject

#pragma mark - 基本属性
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *userLogoUrl;


#pragma mark - 主播独有
@property (nonatomic, copy) NSString *hostId;


#pragma mark - 状态属性
///是否在麦上
@property (nonatomic, assign) BOOL onMic;

///是否被禁言
@property (nonatomic, assign) BOOL forbidChat;

///用户佩戴的勋章
@property (nonatomic, strong) NSArray <KKChatRoomMetalSimpleModel *>*userMedalDetails;
@property (nonatomic, copy) NSString *ownerId;
@end

NS_ASSUME_NONNULL_END
