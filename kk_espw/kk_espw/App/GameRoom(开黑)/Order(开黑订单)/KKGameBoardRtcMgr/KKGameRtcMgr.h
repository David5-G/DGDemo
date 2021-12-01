//
//  KKGameRtcMgr.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/24.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKGameRtcMgr : NSObject
+ (instancetype)shareInstance;

- (void)requestJoinGameRoomGameBoardId:(NSString *)gameBoardId channelId:(NSString *)channelId success:(void (^)(void))success;
@end

NS_ASSUME_NONNULL_END
