//
//  KKFloatGameRoomModel.h
//  kk_espw
//
//  Created by david on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKFloatGameRoomModel : NSObject

/// (必须)开黑房id
@property (nonatomic, assign) NSInteger gameRoomId;

/// (必须)本局游戏所使用的名片id
@property (nonatomic, copy, nullable) NSString *gameProfilesIdStr;;

/// (非必须)游戏局id
@property (nonatomic, copy, nullable) NSString *gameBoardIdStr;

/// (非必须)聊天室id
@property (nonatomic, copy, nullable) NSString *groupIdStr;

/// 当前房间的状态
@property (nonatomic, copy) NSString *gameBoardstatus;
/// 上车
@property (nonatomic, copy) NSString *gameJoinId;
/// 观众
@property (nonatomic, copy) NSString *joined;
/// 房主名
@property (nonatomic, copy) NSString *ownerName;
/// 链接Rtc
@property (nonatomic, copy) NSString *channelId;
/// 房主头像
@property (nonatomic, copy) NSString *ownerLogoUrl;
@property (nonatomic, copy) NSString *type;
/// 房主Id
@property (nonatomic, copy) NSString *ownerUserId;
@end

NS_ASSUME_NONNULL_END
